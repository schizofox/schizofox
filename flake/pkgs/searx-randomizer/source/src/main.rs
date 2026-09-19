use std::{fs::File, io::Read, net::SocketAddr};

use anyhow::{Context, Result};
use clap::Parser;
use log::{error, info};
use rand::Rng;
use rouille::router;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Opts {
  /// IP address to bind the server
  #[clap(short = 'i', long, default_value = "127.0.0.1")]
  ip: String,

  /// Port to bind the server
  #[clap(short = 'p', long, default_value = "8000")]
  port: u16,

  /// Path to the JSON file containing Searx instances
  #[clap(short = 'f', long, env = "SEARX_INSTANCES")]
  searx_instances: String,
}

fn main() -> Result<()> {
  env_logger::Builder::from_env(
    env_logger::Env::default().default_filter_or("info"),
  )
  .init();

  let opts = Opts::parse();

  smol::block_on(async {
    let engines = load_engines(&opts.searx_instances)
      .await
      .context("Failed to load search engines")?;

    let addr: SocketAddr = format!("{}:{}", opts.ip, opts.port)
      .parse()
      .context("Invalid address format")?;

    start_server(addr, engines)
  })
}

async fn load_engines(path: &str) -> Result<Vec<String>> {
  let mut json = String::new();
  File::open(path)
    .and_then(|mut file| file.read_to_string(&mut json))
    .with_context(|| format!("Failed to read file '{path}'"))?;

  let engines: Vec<String> =
    serde_json::from_str(&json).context("Failed to deserialize JSON")?;

  if engines.is_empty() {
    error!("The list of search engines is empty. Please check the input file.");
    anyhow::bail!("Empty search engines list");
  }

  info!("Loaded {} search engines", engines.len());
  Ok(engines)
}

fn start_server(addr: SocketAddr, engines: Vec<String>) -> Result<()> {
  info!("Starting server on {}", addr);

  rouille::start_server(addr.to_string(), move |request| {
    router!(request,
        (GET) (/) => {
            rouille::Response::text("Incorrect endpoint! Please use /search!")
        },
        (GET) (/search) => {
            let engine = get_random_element(&engines);
            info!("Redirecting to engine: {}", engine);
            rouille::Response::redirect_302(format!(
                "https://{}/search?{}",
                engine,
                request.raw_query_string()
            ))
        },
        _ => rouille::Response::empty_404()
    )
  });
}

/// Returns a random element from a slice.
///
/// # Panics
///
/// Panics if the slice is empty.
pub fn get_random_element<T>(vector: &[T]) -> &T {
  let mut rng = rand::rng();
  let random_index = rng.random_range(0..vector.len());
  &vector[random_index]
}
