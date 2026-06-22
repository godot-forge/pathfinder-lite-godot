# Pathfinder Lite — Godot 4

Free Godot 4 addon for pathfinding helpers. Wraps NavigationServer2D/3D with a simple autoload API.

## Features (Lite — Free)

- Up to **4 agents**
- `register_agent()` / `unregister_agent()` / `is_registered()`
- `request_path(agent_id, from, to)` — 2D path via NavigationServer2D
- `request_path_3d(agent_id, from, to)` — 3D path via NavigationServer3D
- `smooth_path(path, threshold)` — remove collinear points
- `clear_cache()` / `cache_size()`
- Signals: `path_ready(id, path)` / `path_failed(id)`

## Quick Start

```gdscript
# Autoload: Pathfinder
Pathfinder.register_agent("hero", $Hero/NavigationAgent2D)
Pathfinder.path_ready.connect(func(id, path): print("Path: ", path))
Pathfinder.request_path("hero", global_position, target_position)
```

## Upgrade to PRO

[Pathfinder PRO](https://godot-forge.itch.io/pathfinder-pro-godot) adds:
- Unlimited agents
- Agent groups + `move_group_to()`
- Async path requests
- LRU path cache with configurable limit
- `path_length()` / `path_direction_at()`
- `nearest_nav_point_2d/3d()`

---
Made with ♥ by [GodotForge](https://itch.io/profile/godot-forge)
