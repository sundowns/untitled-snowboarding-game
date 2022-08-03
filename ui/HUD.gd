extends CanvasLayer
class_name HudLayer

@onready var debug_overlay: DebugOverlay = $DebugOverlay

func register_player(player: Player):
	debug_overlay.register_field(player, "velocity", "p_vel")
