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
const coin : PackedScene = preload("res://DiceObjects/coin.tscn")
var diceOnScreen = []
var diceMaterials = []
# Where do we spawn the dice?
var currentDiceHeight = 1
const maxSpawnHeight = 27

var floor : MeshInstance3D


# Scene State:
# --------------------------------
var menuOpen := false
var isFrozen := false
var physicsRunning := true
# Which die I'm checking? (is the die out of bounds?)
var dieChecking := 0

# Input:
# --------------------------------
# Number of taps
# - Single tap: toggle frozen mode
# - Double tap: menu
var taps : int = 0
var timer : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if !ProjectSettings.has_setting("boardTexture"):
		print("created default for boardTexture")
		ProjectSettings.set_setting("boardTexture", "res://textures/Wood.png")
	
	var cfgfile := ConfigFile.new()
	var err = cfgfile.load("user://config.cfg")

	floor = $Board

	if err == OK:
		var c = cfgfile.get_value("texture", "board", "none")
		
		if c == "none":
			cfgfile.set_value("texture", "board", "res://textures/Wood.png")
			cfgfile.save("user://config.cfg")
		
		loadMaterials()
	else:
		print("File didn't load :(")
		reloadMaterials()
	
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
			$CenterContainer/Label.visible = false
			$CenterContainer/Label.modulate.a = 0
		
		# Reset the taps and the timer
		timer = 0
		taps = 0
	
	# If the physics are running make sure that any die gets out of bounds
	# Check one die per frame to calculate less things
	if physicsRunning:
		if diceOnScreen.size() > 0:
			if diceOnScreen[dieChecking].transform.origin.y <= -1:
				diceOnScreen[dieChecking].transform.origin = Vector3(3, 28, 3)
		
			dieChecking += 1
			if dieChecking == diceOnScreen.size():
				dieChecking = 0
	
	# We check dice values
	var showText := true
	
	# If we're in Frozen State and the physics are running
	if isFrozen && physicsRunning:
		
		# We start calculating the sum of the dice
		# At some point we could end with a die that isn't
		# stationary, in that case its value will be -1
		# If we find a -1 we stop calculating
		var sum = 0
		for i in range(diceOnScreen.size()):
			var value = diceOnScreen[i].getDieValue()
			if value == -1:
				showText = false
				break
			sum = sum + value
		
		# If the above code was successful we stop the
		# physics and we show the result on the screen
		if showText:
			$CenterContainer/Label.text = str(sum)
			
			physicsRunning = false
			for j in range(diceOnScreen.size()):
				diceOnScreen[j].freeze = true
			
			print("The physics has been stopped")
		else:
			# If it wasn't successful, we have to make sure
			# that the opacity of the text is still 0
			$CenterContainer/Label.modulate.a = 0
			
	# If we're in Frozen Mode and the physics isn't running
	# we gradually increase the opacity of the text
	elif isFrozen && !physicsRunning:
		if $CenterContainer/Label.modulate.a < 0.75:
			$CenterContainer/Label.modulate.a += delta
	
	# If we're not in Frozen Mode and the physics are not running
	# we just need to enable the physics again
	elif !isFrozen && !physicsRunning:
		physicsRunning = true
		for i in range(diceOnScreen.size()):
			diceOnScreen[i].freeze = false
		print("The physics has been resumed")

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
	$CenterContainer/Label.visible = true
	for i in range(diceOnScreen.size()):
		diceOnScreen[i].set_process(false)

func unfreeze():
	$CenterContainer/Label.visible = false
	$CenterContainer/Label.modulate.a = 0
	for i in range(diceOnScreen.size()):
		diceOnScreen[i].set_process(true)

func showMenu():
	# Delete all dice on screen to replace them with the ones selected
	for i in range(diceOnScreen.size()):
		diceOnScreen[i].queue_free()
	diceOnScreen.clear()
	dieChecking = 0
	
	# Show Menu
	menuOpen = true
	currentDiceHeight = 1
	instance.enable()


func addDice(die : PackedScene, count : int, size : float = 1):
	if count <= 0:
		return
		
	for i in range(count):
		var d = die.instantiate()
		# We randomly select the material and also scale the dice and collision shape
		if die != coin:
			d.get_child(0).material_override = diceMaterials[randi() % diceMaterials.size()]
		d.get_child(0).transform = d.get_child(0).transform.scaled(Vector3(size, size, size))
		d.get_child(1).transform = d.get_child(1).transform.scaled(Vector3(size, size, size))
		# d.gravity_scale = 4 * size
		d.transform.origin.y = currentDiceHeight
		diceOnScreen.push_back(d)
		add_child(d)
		
		# Update current dice height, we use size*2 because each die has a size of
		# aproximately 2x2x2
		currentDiceHeight = currentDiceHeight + size*2

func reloadMaterials():
		floor.material_override.albedo_texture = load(ProjectSettings.get_setting("boardTexture"))

func loadMaterials():
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("user://config.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		print("File didn't load :(")
		reloadMaterials()
		return
	
	floor.material_override.albedo_texture = load(config.get_value("texture", "board", "res://textures/Wood.png"))
