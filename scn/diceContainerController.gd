extends Node3D

# The board and its invisible walls
@onready var scene := $/root/Dice/Scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transform.origin = scene.transform.origin
	transform.basis = scene.transform.basis
