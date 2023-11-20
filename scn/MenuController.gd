extends ColorRect

var buttons : Array
@onready var rollButton := $CenterContainer/Button
@onready var diceScene := $/root/Dice

# Timer to make the buttons clickable
var timer : float = 0
# Same as saying enabled or not disabled
# I'm using "disable" and "enable" already
# so for the sake of clarity I'll call this
# variable clickable. It refers to the Buttons
var clickable := false

# Called when the node enters the scene tree for the first time.
func _ready():
	# We get our buttons here and put them in an array
	buttons.push_back($"D4")
	buttons.push_back($"D6")
	buttons.push_back($"D8")
	buttons.push_back($"D10")
	buttons.push_back($"D12")
	buttons.push_back($"D20")
	buttons.push_back($"D100")
	buttons.push_back($Options)
	
	# Extra :)
	buttons.push_back($Coin)

# We use a timer to enable all buttons after 0.5 seconds
func _process(delta):
	if timer < 0.5:
		timer += delta
	elif not clickable:
		clickable = true
		for i in range(buttons.size()):
			buttons[i].disabled = false
		rollButton.disabled = false

func disable():
	# We reset the buttons' parameters and hide them
	for i in range(buttons.size()):
		buttons[i].counter = 0
		buttons[i].disabled = true
		buttons[i].set_process(false)
		buttons[i].hide()
	rollButton.disabled = true
	rollButton.set_process(false)
	rollButton.hide()
	
	# we reset the timer and clickable parameter
	clickable = false
	timer = 0
	
	# We finally hide this node
	set_process(false)
	hide()

func enable():
	for i in range(buttons.size()):
		buttons[i].set_process(true)
		buttons[i].show()
	rollButton.set_process(true)
	rollButton.show()
	
	set_process(true)
	show()

# The callback for the Roll Button
func _on_roll_button_pressed():
	# We get how many dice we need, this way we can well Dice Manager
	# how many dice we need to instanciate and where
	var d4c = buttons[0].counter
	var d6c = buttons[1].counter
	var d8c = buttons[2].counter
	var d10c = buttons[3].counter
	var d12c = buttons[4].counter
	var d20c = buttons[5].counter
	var d100c = buttons[6].counter
	
	var coin = buttons[8].counter # coin
	
	# We need to know the total so we can specify the size of the dice
	var total = d4c + d6c + d8c + d10c + d12c + d20c + d100c + coin
	var size : float
	if total <= 7:
		size = 1.0
	else:
		size = (5.0/total)+0.25
	print("SIZE: " + str(size))
	
	# We add the dice to the main scene
	diceScene.addDice(diceScene.d4, d4c, size)
	diceScene.addDice(diceScene.d6, d6c, size)
	diceScene.addDice(diceScene.d8, d8c, size)
	diceScene.addDice(diceScene.d10, d10c, size)
	diceScene.addDice(diceScene.d12, d12c, size)
	diceScene.addDice(diceScene.d20, d20c, size)
	diceScene.addDice(diceScene.coin, coin, size)
	
	# We tell the main scene that the menu is already closed
	diceScene.menuOpen = false
	
	# We disable this scene
	disable()

func open_options():
	print("settings clickity clackity")
	var settings := load("res://scn/Settings.tscn")
	var instance = settings.instantiate()
	add_child(instance)
