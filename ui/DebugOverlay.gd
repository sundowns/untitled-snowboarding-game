extends Control
class_name DebugOverlay

@onready var label: Label = $Label

class DebugField:
	var entity: Object
	var field_name: String
	var display_name: String
	func _init(_entity: Object, _field_name: String, _display_name: String):
		self.entity = _entity
		self.field_name = _field_name
		self.display_name = _display_name

var fields: Array = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var debug_string = ""
	for field in fields:
		var value = field.entity.get(field.field_name)
		debug_string += "[%s]: %s \n" % [field.display_name, value]
	label.text = debug_string

func register_field(entity: Object, field_name: String, display_name: String):
	fields.append(DebugField.new(entity, field_name, display_name))
