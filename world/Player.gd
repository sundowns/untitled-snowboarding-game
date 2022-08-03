extends CharacterBody3D
class_name Player

@onready var floor_cast: RayCast3D = $FloorCast

@export var turning_speed: float = 5.0

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float):
	# Add the gravity.
	if is_on_floor() or floor_cast.is_colliding():
		grounded_slope_movement(delta)
	else:
		aerial_movement(delta)
	move_and_slide()

func aerial_movement(delta: float):
	velocity.y -= gravity * delta

func grounded_slope_movement(_delta: float):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("turn_left", "turn_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	if direction:
		velocity.x = direction.x * turning_speed
	else:
		velocity.x = move_toward(velocity.x, 0, turning_speed)
	orient_down_slope()

func orient_down_slope():
	if floor_cast.is_colliding():
		var collision_normal = floor_cast.get_collision_normal()
		if collision_normal != Vector3.ZERO:
			var xform = align_with_y(global_transform, collision_normal)
			global_transform = global_transform.interpolate_with(xform, 0.2)

# Given an up direction (y), align the transform so that its local up vector matches y
func align_with_y(transform: Transform3D, new_y: Vector3):
	transform.basis.y = new_y
	transform.basis.x = -transform.basis.z.cross(new_y)
	transform.basis = transform.basis.orthonormalized()
	return transform
