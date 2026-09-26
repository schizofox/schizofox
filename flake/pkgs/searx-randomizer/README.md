# searx-randomizer

Searx(ng) instance randomizer for Schizofox.

The service listens on `127.0.0.1:8000`. A request to `/search` redirects to a
random configured instance over HTTPS, preserving the query string. Set
`programs.schizofox.search.searxRandomizer.instances` to a nonempty list of
Searx hostnames (without `https://` or a path).

For direct CLI use, pass a JSON array of hostnames with `--searx-instances` or
`SEARX_INSTANCES`; `--ip` accepts IPv4 or IPv6 addresses and `--port` changes
the listening port:

```sh
# List available instances
$ printf '%s\n' '["searx.be", "search.notashelf.dev"]' > engines.json

# Run with your own instance list
$ searx-randomizer --searx-instances ./engines.json
```
