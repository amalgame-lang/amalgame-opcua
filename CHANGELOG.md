# Changelog

## v0.1.1 — 2026-11-19

### Fixed

- The client config (and its logger) is built before the client
  (`UA_Client_newWithConfig`) : in v0.1.0 the logger was set after the
  event loop had taken the default one, so open62541 logged every
  reconnection attempt, and a client whose server went away did not
  always connect again on the next call. Logging : fatal only (the
  application reports losses itself, once).
- `Connect` returns -1 when open62541 cannot create the client.

## v0.1.0 — 2026-11-18

First version.

- Client : `Connect` (handle that reconnects by itself), `ReadMany` (one
  Read request for many nodes, values as numbers, status code per value),
  `BrowseTree` (address space as JSON, with data type, value,
  `EngineeringUnits` and `EURange` of every variable), `LastError`,
  `StatusName`.
- Test server : `ServerStart`, `ServerAddAnalog` (folder path, unit,
  EURange), `ServerAddInt`, `ServerSet`.
- open62541 v1.4.22 amalgamation generated with OpenSSL encryption and
  without PubSub (`tools/gen-amalgamation.ps1`, `NOTICE.md`), logging
  warnings and errors only.
- `tests/opcua_smoke.am` : 16 checks, green on Linux (Ubuntu 24.04).
