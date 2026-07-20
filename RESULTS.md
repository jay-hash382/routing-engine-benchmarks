# Taiwan car-routing build results

Measured on 2026-07-20 using separate GitHub-hosted `ubuntu-24.04` runners. Each build was limited to 4 CPUs and 14 GiB container memory and used the same 325,160,347-byte Geofabrik Taiwan PBF.

| Engine | Build wall time | Peak build memory | Deployable graph | Validation |
|---|---:|---:|---:|---|
| OSRM MLD | 94 s | 2,861,219,840 B (2.66 GiB) | 1,127,791,136 B (1.05 GiB) | High-speed cross-city route OK |
| GraphHopper 11 CH | 50 s | 3,744,653,312 B (3.49 GiB) | 139,506,233 B (133.0 MiB) | `/info` ready; route smoke workflow included |
| Valhalla | 62 s | 2,688,389,120 B (2.50 GiB) | 322,416,640 B (307.5 MiB `tiles.tar`) | Auto cross-city route OK |

## Interpretation

- All three fit comfortably within a 12 GiB Oracle Always Free Ampere instance for Taiwan car routing.
- A 4 GiB machine is too close to GraphHopper's measured build peak and leaves little operating-system headroom. Build on 8–12 GiB even if runtime later proves smaller.
- GraphHopper produced the smallest graph and fastest build in this configuration; OSRM produced the largest artifact.
- These are build peaks, not steady-state server RAM. Runtime idle/load measurements should be performed only for the selected finalist.
- Results are reproducible through manual GitHub Actions workflows. Generated graphs are not retained as artifacts.

Data: © OpenStreetMap contributors; extract distributed by Geofabrik under ODbL.
