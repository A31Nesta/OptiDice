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
	# We add the dice to the main scene
	diceScene.addDice(diceScene.d4, buttons[0].counter)
	diceScene.addDice(diceScene.d6, buttons[1].counter)
	diceScene.addDice(diceScene.d8, buttons[2].counter)
	diceScene.addDice(diceScene.d10, buttons[3].counter)
	diceScene.addDice(diceScene.d12, buttons[4].counter)
	diceScene.addDice(diceScene.d20, buttons[5].counter)
	diceScene.addDice(diceScene.d100, buttons[6].counter)
	
	# We tell the main scene that the menu is already closed
	diceScene.menuOpen = false
	
	# We disable this scene
	disable()
