extends Node3D

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")

func _ready() -> void:
	pass


func idle():
	state_machine.travel("player_anims_Idle")

func move():
	state_machine.travel("player_anims_Walking")

func crouch():
	state_machine.travel("player_anims/Crouching_Idle")
