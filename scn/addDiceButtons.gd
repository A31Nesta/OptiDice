extends TextureButton

var counter : int = 0
var timer : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer < 0.5:
		timer += delta
	elif disabled:
		disabled = false

func _pressed():
	counter = counter + 1
