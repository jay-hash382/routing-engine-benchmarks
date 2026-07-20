# Taiwan Routing Engine Benchmarks

Independent, reproducible GitHub Actions benchmarks for building a Taiwan car-routing graph from the same Geofabrik OpenStreetMap PBF.

This repository does not contain or modify the Road Weather Taiwan app, backend, or map-tile repositories.

## Engines

- OSRM (MLD)
- GraphHopper 11
- Valhalla

Each workflow downloads `taiwan-latest.osm.pbf`, records the input size, wall-clock build time, peak container memory, generated graph size, image/version information, and a smoke-route result. Generated routing graphs are deleted with the runner and are not committed or uploaded.

Workflows are manual (`workflow_dispatch`) so benchmarks only run intentionally. Small text reports are retained as workflow artifacts.

Data: © OpenStreetMap contributors, distributed by Geofabrik under ODbL.

