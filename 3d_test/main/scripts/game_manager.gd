## The class behind the Singleton object, i.e. the main script of this project.
## This class has various methods for interacting with sub-systems at runtime.
@tool
class_name GameManager
extends Node

var last_player_position := Vector3i.MAX
var exact_player_position: Vector3
var current_room: Node3D


func _enter_tree() -> void:
	pass


## Resets the state of the [Singleton] to initial one.
## You should call it every time you start a new game session.
func reset_state() -> void:
	last_player_position = Vector3i.MAX
	exact_player_position = Vector3.ZERO


## Sets the position of the [Player] to be tracked by [Game]. 
func set_player_position(position: Vector3) -> void:
	exact_player_position = position
	if not current_room:
		return
