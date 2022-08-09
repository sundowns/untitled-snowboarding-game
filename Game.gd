extends Node

onready var hud = $HUD
onready var world: GameWorld = $World

func _ready():
# warning-ignore:return_value_discarded
	world.connect("player_spawned", hud, "register_player")
	world.initialise()
