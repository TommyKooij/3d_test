## Class designed for use in main game scenes.
## This script is responsible for map management and player tracking.
extends Node

var player: Node3D
var map: Node3D
var map_changing: bool

## Emitted when [method load_room] has loaded a room. You can use it when you want to call some methods after loading a room (e.g. positioning the player).
signal room_loaded


## Sets the node to be tracked by this class. When player was assigned, [method Singleton.set_player_position] will be called automatically at the end of every physics frame, updating the player position.
func set_player(p_player: Node3D):
	player = p_player
	player.get_tree().physics_frame.connect(_on_physics_tick, CONNECT_DEFERRED)


## Loads a map and adds as a child of this node. If a map already exists, it will be removed before the new one is loaded. 
## This method is asynchronous, so you should call it with [code]await[/code] if you want to do something after the map is loaded. Alternatively, you can use [signal room_loaded].
func load_room(path: String):
	if map_changing:
		return
	
	map_changing = true
	
	if map:
		map.queue_free()
		await map.tree_exited
		map = null
	
	map = load(path).instantiate()
	add_child(map)
	
	map_changing = false
	room_loaded.emit()


func _on_physics_tick():
	if is_inside_tree() and can_process():
		Singleton.set_player_position(player.position)
