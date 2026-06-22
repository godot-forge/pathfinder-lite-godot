extends Node

const MAX_AGENTS := 4

signal path_ready(agent_id: String, path: Array)
signal path_failed(agent_id: String)

var _agents: Dictionary = {}
var _map: RID = RID()
var _path_cache: Dictionary = {}

# Register a NavigationAgent2D or NavigationAgent3D node under an id
func register_agent(agent_id: String, agent_node: Node) -> void:
	if _agents.size() >= MAX_AGENTS:
		push_warning("Pathfinder Lite: max %d agents reached." % MAX_AGENTS)
		return
	_agents[agent_id] = agent_node

func unregister_agent(agent_id: String) -> void:
	_agents.erase(agent_id)

func is_registered(agent_id: String) -> bool:
	return _agents.has(agent_id)

func registered_agents() -> Array:
	return _agents.keys()

# Request a path — result emitted via path_ready signal
func request_path(agent_id: String, from: Vector2, to: Vector2, map: RID = RID()) -> void:
	var cache_key: String = "%s|%s|%s" % [agent_id, from, to]
	if _path_cache.has(cache_key):
		emit_signal("path_ready", agent_id, _path_cache[cache_key])
		return
	var nav_map: RID = map if map.is_valid() else NavigationServer2D.get_maps()[0] if NavigationServer2D.get_maps().size() > 0 else RID()
	if not nav_map.is_valid():
		emit_signal("path_failed", agent_id)
		return
	var query := NavigationPathQueryParameters2D.new()
	query.map = nav_map
	query.start_position = from
	query.target_position = to
	var result := NavigationPathQueryResult2D.new()
	NavigationServer2D.query_path(query, result)
	var path: Array = Array(result.path)
	if path.is_empty():
		emit_signal("path_failed", agent_id)
		return
	_path_cache[cache_key] = path
	emit_signal("path_ready", agent_id, path)

# Request a 3D path
func request_path_3d(agent_id: String, from: Vector3, to: Vector3, map: RID = RID()) -> void:
	var cache_key: String = "%s|%s|%s" % [agent_id, from, to]
	if _path_cache.has(cache_key):
		emit_signal("path_ready", agent_id, _path_cache[cache_key])
		return
	var nav_map: RID = map if map.is_valid() else NavigationServer3D.get_maps()[0] if NavigationServer3D.get_maps().size() > 0 else RID()
	if not nav_map.is_valid():
		emit_signal("path_failed", agent_id)
		return
	var query := NavigationPathQueryParameters3D.new()
	query.map = nav_map
	query.start_position = from
	query.target_position = to
	var result := NavigationPathQueryResult3D.new()
	NavigationServer3D.query_path(query, result)
	var path: Array = Array(result.path)
	if path.is_empty():
		emit_signal("path_failed", agent_id)
		return
	_path_cache[cache_key] = path
	emit_signal("path_ready", agent_id, path)

# Simplify a path by removing collinear points (threshold in pixels/units)
func smooth_path(path: Array, threshold: float = 2.0) -> Array:
	if path.size() < 3:
		return path
	var result: Array = [path[0]]
	for i in range(1, path.size() - 1):
		var prev = path[i - 1]
		var curr = path[i]
		var next = path[i + 1]
		var d1 = curr - prev
		var d2 = next - curr
		if d1.normalized().distance_to(d2.normalized()) > threshold * 0.01:
			result.append(curr)
	result.append(path[path.size() - 1])
	return result

func clear_cache() -> void:
	_path_cache.clear()

func cache_size() -> int:
	return _path_cache.size()
