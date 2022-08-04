extends Camera3D
class_name FollowingCamera

@export var offset: Vector3 = Vector3.UP

var target: Node3D = null

func set_target(new_target: Node3D):
	target = new_target

func _process(delta):
	if target:
		look_at_from_position(target.global_position + offset, target.global_position)
