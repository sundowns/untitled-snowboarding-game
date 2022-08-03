extends Node3D
class_name World

signal player_spawned(player)

@export var player_scene = preload("res://world/Player.tscn")

@onready var player_spawn_point: Position3D = $PlayerSpawnPoint
@onready var entities: Node = $Entities

func initialise():
	spawn_player()

func spawn_player():
	var player: Player = player_scene.instantiate()
	entities.add_child(player)
	player.global_transform.origin = player_spawn_point.global_transform.origin
	player_spawned.emit(player)
