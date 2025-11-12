extends CharacterBody3D

@onready var camera_pivot : Node3D = %CameraPivot
@onready var camera : Camera3D = %Camera3D
@onready var player_model : Node3D = %player_model

@export_category("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity : float = 0.25

@export_category("Movement")
@export var move_speed : float = 8.0
@export var acceleration : float = 20.0
@export var rotation_speed : float = 10.0
@export var jump_impulse : float = 12.0

var camera_input_direction : Vector2 = Vector2.ZERO
var last_movement_direction : Vector3 = Vector3.BACK
var gravity : float = -30.0


func _physics_process(delta: float) -> void:
	camera_pivot.rotation.x += camera_input_direction.y * delta
	camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -PI / 6.0, PI / 3.0)
	camera_pivot.rotation.y -= camera_input_direction.x * delta
	
	camera_input_direction = Vector2.ZERO

	_movement(delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	
func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		camera_input_direction = event.screen_relative * mouse_sensitivity
		

func _movement(delta: float) -> void:
	var raw_input : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var forward : Vector3 = camera.global_basis.z
	var right : Vector3 = camera.global_basis.x

	# Movement calculations
	var move_direction : Vector3 = forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	# Velocity calculations
	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	velocity.y = y_velocity + gravity * delta

	# Jump calculations
	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_impulse

	move_and_slide()

	# Player Model angle calculations
	if move_direction.length() > 0.2:
		last_movement_direction = move_direction
	var target_angle : float = Vector3.BACK.signed_angle_to(last_movement_direction, Vector3.UP)
	player_model.global_rotation.y = lerp_angle(player_model.rotation.y, target_angle, rotation_speed * delta)

	# Animations
	if is_starting_jump:
		print("Jumping")
	elif not is_on_floor() and velocity.y < 0:
		print("Falling")
	elif is_on_floor():
		var is_starting_crouch := Input.is_action_just_pressed("crouch")
		if is_starting_crouch:
			print("Crouching")
		else:
			var ground_speed : float = velocity.length()
			if ground_speed > 0.0:
				player_model.move()
			else:
				player_model.idle()
