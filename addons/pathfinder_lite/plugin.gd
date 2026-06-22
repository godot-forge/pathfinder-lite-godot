@tool
extends EditorPlugin

func _enable_plugin() -> void:
	add_autoload_singleton("Pathfinder", "res://addons/pathfinder_lite/pathfinder.gd")

func _disable_plugin() -> void:
	remove_autoload_singleton("Pathfinder")
