extends TextureButton

@onready var diceScene = $/root/Dice
@onready var uiScene = $"../.."

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

func _pressed():
	print("AMOGUS!")
	diceScene.addDice(diceScene.d4, $"../../D4".counter)
	diceScene.addDice(diceScene.d6, $"../../D6".counter)
	diceScene.addDice(diceScene.d8, $"../../D8".counter)
	diceScene.addDice(diceScene.d10, $"../../D10".counter)
	diceScene.addDice(diceScene.d12, $"../../D12".counter)
	diceScene.addDice(diceScene.d20, $"../../D20".counter)
	diceScene.addDice(diceScene.d100, $"../../D100".counter)
	diceScene.menuOpen = false
	uiScene.queue_free()
