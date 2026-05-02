@tool
extends TextureButton

@export var cost: int = 20
@export var scene: PackedScene
@onready var cost_label: Label = $MarginContainer/Cost
@export_multiline var description: String
@export_tool_button("Ver") var _ver = ver

func ver():
	%UnidadTooltip.text = description

func _ready():
	cost_label.text = str(cost)
