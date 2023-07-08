extends TextureButton

# This counter registers every time the button gets pressed
# The RollButton script takes this value and uses it to tell
# the Dice node from the main scene to generate the dice
var counter : int = 0

func _pressed():
	counter = counter + 1
