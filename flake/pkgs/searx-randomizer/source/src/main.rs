use std::{
    fs,
    net::{IpAddr, SocketAddr},
    path::{Path, PathBuf},
};

use anyhow::{Context, Result};
use log::{error, info};
use pound::Parse;
use tiny_http::{Header, Method, Request, Response, Server};

/// An instance randomizer for Searx and Searxng
#[derive(Parse, Debug)]
#[pound(name = "searx-randomizer")]
struct Opts {
    /// IP address to bind the server
    #[pound(short = 'i', long, default = "127.0.0.1")]
    ip: IpAddr,

    /// Port to bind the server
    #[pound(short = 'p', long, default = "8000")]
    port: u16,

    /// Path to the JSON file containing Searx instances
    #[pound(short = 'f', long, env = "SEARX_INSTANCES")]
    searx_instances: PathBuf,
}

fn main() -> Result<()> {
    env_logger::Builder::from_env(env_logger::Env::default().default_filter_or("info")).init();

    let opts = Opts::parse();

    let engines = load_engines(&opts.searx_instances).context("Failed to load search engines")?;
    let addr = SocketAddr::new(opts.ip, opts.port);
    start_server(addr, engines)
}

fn load_engines(path: &Path) -> Result<Vec<String>> {
    let json = fs::read_to_string(path)
        .with_context(|| format!("Failed to read file '{}'", path.display()))?;
    let engines: Vec<String> = serde_json::from_str(&json).context("Failed to deserialize JSON")?;
    if engines.is_empty() {
        error!("The list of search engines is empty. Please check the input file.");
        anyhow::bail!("Empty search engines list");
    }

    info!("Loaded {} search engines", engines.len());
    Ok(engines)
}

fn start_server(addr: SocketAddr, engines: Vec<String>) -> Result<()> {
    let server =
        Server::http(addr).map_err(|err| anyhow::anyhow!("Failed to bind {addr}: {err}"))?;
    info!("Starting server on {addr}");

    for request in server.incoming_requests() {
        if let Err(err) = handle_request(request, &engines) {
            error!("Failed to handle request: {err:#}");
        }
    }
    Ok(())
}

fn handle_request(request: Request, engines: &[String]) -> Result<()> {
    let query = match (request.method(), request.url()) {
        (&Method::Get, "/") => {
            return request
                .respond(Response::from_string(
                    "Incorrect endpoint! Please use /search!",
                ))
                .context("Failed to send HTTP response");
        }
        (&Method::Get, "/search") => Some(""),
        (&Method::Get, url) => url.strip_prefix("/search?"),
        _ => None,
    };

    let Some(query) = query else {
        return request
            .respond(Response::empty(404))
            .context("Failed to send HTTP response");
    };

    let engine = &engines[rand::random_range(0..engines.len())];
    info!("Redirecting to engine: {engine}");
    let location = format!("https://{engine}/search?{query}");
    let header = Header::from_bytes("Location", location)
        .map_err(|()| anyhow::anyhow!("Invalid redirect location"))?;
    request
        .respond(Response::empty(302).with_header(header))
        .context("Failed to send HTTP response")
}
