extends Node3D

var menuOpen : bool = false
var instance
var scene : PackedScene = preload("res://scn/menu.tscn")

# Dice scenes
var d4 : PackedScene = preload("res://DiceObjects/d4_rb.tscn")
var d6 : PackedScene = preload("res://DiceObjects/d6_rb.tscn")
var d8 : PackedScene = preload("res://DiceObjects/d8_rb.tscn")
var d10 : PackedScene = preload("res://DiceObjects/d10_rb.tscn")
var d12 : PackedScene = preload("res://DiceObjects/d12_rb.tscn")
var d20 : PackedScene = preload("res://DiceObjects/d20_rb.tscn")
var d100 : PackedScene = preload("res://DiceObjects/d100_rb.tscn")

var diceOnScreen = []

# Called when the node enters the scene tree for the first time.
func _ready():
	diceOnScreen.push_back(d6.instantiate())
	add_child(diceOnScreen[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and !menuOpen:
		# Delete all dice on screen to replace them with the ones selected
		for i in range(diceOnScreen.size()):
			diceOnScreen[i].queue_free()
		diceOnScreen.clear()
		
		# Show Menu
		menuOpen = true
		instance = scene.instantiate()
		add_child(instance)

func addDice(die : PackedScene, count : int):
	if count <= 0:
		return
	elif count > 1:
		for i in range(count):
			var d = die.instantiate()
			diceOnScreen.push_back(d)
			add_child(d)
		return
	
	var d = die.instantiate()
	diceOnScreen.push_back(d)
	add_child(d)
