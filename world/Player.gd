extends KinematicBody
class_name Player

onready var floor_cast: RayCast = $FloorCast
onready var mesh_anchor: Spatial = $MeshAnchor

export(float) var forward_speed: float = 10.0
export(float) var terminal_velocity: float = 50.0

export(Resource) var backside_vector
export(Resource) var frontside_vector 

var velocity: Vector3 = Vector3.ZERO
var heading: Vector3 = Vector3.FORWARD

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float):
	if is_on_floor() or floor_cast.is_colliding():
		grounded_slope_movement(delta)
	apply_gravity(delta)
	limit_velocity()
	velocity = move_and_slide(velocity, Vector3.UP)

func apply_gravity(delta: float):
	# Add the gravity
	velocity.y -= gravity * delta

func grounded_slope_movement(delta: float):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var left_right = Input.get_axis("turn_left", "turn_right")
	# Intentionally dont reset to forward, so we stay on an edge
	if left_right < 0:
		heading = backside_vector.xyz
	elif left_right > 0:
		heading = frontside_vector.xyz
	var forward_heading_vector = (transform.basis * heading).normalized() * forward_speed * delta
	velocity += forward_heading_vector
	orient_down_slope()
	orient_on_edge(left_right)

func orient_down_slope():
	if floor_cast.is_colliding():
		var collision_normal = floor_cast.get_collision_normal()
		if collision_normal != Vector3.ZERO:
			var xform = align_with_y(global_transform, collision_normal)
			global_transform = global_transform.interpolate_with(xform, 0.2)

func orient_on_edge(left_right: float):
	if left_right < 0:
		mesh_anchor.rotation = Vector3(0,0, 0.1)
	elif left_right > 0:
		mesh_anchor.rotation = Vector3(0,0, -0.1)

# Given an up direction (y), align the transform so that its local up vector matches y
func align_with_y(xform: Transform, new_y: Vector3):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func limit_velocity():
	if velocity.length() > terminal_velocity:
		velocity = velocity.normalized() * terminal_velocity
