extends Node3D

# Scenes and Instancing
# --------------------------------
const scene : PackedScene = preload("res://scn/menu.tscn")
var instance
const d4 : PackedScene = preload("res://DiceObjects/d4_rb.tscn")
const d6 : PackedScene = preload("res://DiceObjects/d6_rb.tscn")
const d8 : PackedScene = preload("res://DiceObjects/d8_rb.tscn")
const d10 : PackedScene = preload("res://DiceObjects/d10_rb.tscn")
const d12 : PackedScene = preload("res://DiceObjects/d12_rb.tscn")
const d20 : PackedScene = preload("res://DiceObjects/d20_rb.tscn")
const d100 : PackedScene = preload("res://DiceObjects/d100_rb.tscn")
var diceOnScreen = []
var diceMaterials = []

# Scene State:
# --------------------------------
var menuOpen := false
var isFrozen := false

# Input:
# --------------------------------
# Number of taps
# - Single tap: toggle frozen mode
# - Double tap: menu
var taps : int = 0
var timer : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# We add the possible materials to the array
	diceMaterials.push_back(preload("res://Dice/Materials/Rad.tres"))
	diceMaterials.push_back(preload("res://Dice/Materials/Mag.tres"))
	diceMaterials.push_back(preload("res://Dice/Materials/Col.tres"))
	
	# Put a d6 by default
	addDice(d6, 1)
	
	# We instanciate at start, this way we don't need to reload it and the game runs faster
	# In the profiler the bottleneck when opening the menu is in Process Time, so this
	# should help (It didn't, but at least now the code is somewhat cleaner)
	instance = scene.instantiate()
	add_child(instance)
	instance.disable()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer < 0.25:
		if taps > 0:
			timer += delta
	else:
		if taps == 1:
			toggleFreeze()
		else: # (taps is 2 or more)
			showMenu()
			isFrozen = false
		
		# Reset the taps and the timer
		timer = 0
		taps = 0

func _input(event):
	# We include the menuOpen variable here because we don't want
	# this scene to be processing input while we use the menu
	if event is InputEventMouseButton and !menuOpen:
		if event.pressed: # We only want press, not release
			taps += 1

func toggleFreeze():
	if isFrozen:
		unfreeze()
		isFrozen = false
	else:
		freeze()
		isFrozen = true

func freeze():
	for i in range(diceOnScreen.size()):
		diceOnScreen[i].set_process(false)

func unfreeze():
	for i in range(diceOnScreen.size()):
		diceOnScreen[i].set_process(true)

func showMenu():
	# Delete all dice on screen to replace them with the ones selected
	for i in range(diceOnScreen.size()):
		diceOnScreen[i].queue_free()
	diceOnScreen.clear()
	
	# Show Menu
	menuOpen = true
	instance.enable()

func addDice(die : PackedScene, count : int):
	if count <= 0:
		return
	elif count > 1:
		for i in range(count):
			var d = die.instantiate()
			d.get_child(0).material_override = diceMaterials[randi() % diceMaterials.size()]
			diceOnScreen.push_back(d)
			add_child(d)
		return
	
	var d = die.instantiate()
	d.get_child(0).material_override = diceMaterials[randi() % diceMaterials.size()]
	diceOnScreen.push_back(d)
	add_child(d)
