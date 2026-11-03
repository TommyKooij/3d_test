## This is the main script of the game.
class_name Game
extends "res://main/scripts/scene_manager.gd"

static var instance: Game

# The game starts in this map.
@export_file var starting_map: String


func _enter_tree() -> void:
	instance = self


func _exit_tree() -> void:
	if instance == self:
		instance = null


func _ready() -> void:
	# Make sure Game is in initial state.
	Singleton.reset_state()
	
	# Assign player for Game.
	set_player($Player)
	
	# Load the starting room.
	load_room(starting_map)
	
	# Find the save point and teleport the player to it, to start at the save point.
	var start := map.get_node_or_null(^"Start")
	if start:
		player.position = start.position
	
	# Reset position tracking.
	await get_tree().physics_frame


## Return this node from anywhere.
static func get_instance() -> Game:
	return instance
