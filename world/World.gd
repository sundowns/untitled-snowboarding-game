extends Spatial
class_name GameWorld

signal player_spawned(player)

export(PackedScene) var player_scene = preload("res://world/Player.tscn")

onready var player_spawn_point: Position3D = $Terrain/PlayerSpawnPoint
onready var entities: Node = $Entities
onready var camera: FollowingCamera = $FollowingCamera

func initialise():
	spawn_player()

func spawn_player(set_as_camera_target: bool = true):
	var player: Player = player_scene.instance()
	entities.add_child(player)
	player.global_transform = player_spawn_point.global_transform
#	player_spawned.emit(player)
	emit_signal("player_spawned", player)
	if set_as_camera_target:
		camera.set_target(player)
