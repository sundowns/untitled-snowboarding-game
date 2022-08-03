extends Node

@onready var hud: HudLayer = $HUD
@onready var world: World = $World

func _ready():
	world.connect("player_spawned", hud.register_player)
	world.initialise()
