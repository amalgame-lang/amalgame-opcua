# Changelog

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
