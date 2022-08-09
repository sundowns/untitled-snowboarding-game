extends Camera
class_name FollowingCamera

export(Vector3) var offset: Vector3 = Vector3.UP

var target: Spatial = null

func set_target(new_target: Spatial):
	target = new_target

func _process(_delta):
	if target:
		look_at_from_position(target.global_transform.origin + offset, target.global_transform.origin, Vector3.UP)
