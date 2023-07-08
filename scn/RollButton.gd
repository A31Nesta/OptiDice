extends TextureButton

var timer : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer < 0.5:
		timer += delta
	elif disabled:
		disabled = false
