extends ColorRect

# Buttons go here

# Type of floor
# -------------
var woodFloor : TextureButton
var blackFloor : TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	woodFloor = $VBoxContainer/MarginContainer2/HBoxContainer/Wood
	blackFloor = $VBoxContainer/MarginContainer2/HBoxContainer/Black


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_wood_pressed():
	ProjectSettings.set_setting("boardTexture", "res://textures/Wood.png")
	
	var cfgfile := ConfigFile.new()
	cfgfile.set_value("texture", "board", "res://textures/Wood.png")
	cfgfile.save("user://config.cfg")
	print("Saved config")
	
	close_scene()


func _on_black_pressed():
	ProjectSettings.set_setting("boardTexture", "res://textures/BlackBoard.png")
	
	var cfgfile := ConfigFile.new()
	cfgfile.set_value("texture", "board", "res://textures/BlackBoard.png")
	cfgfile.save("user://config.cfg")
	print("Saved config")
	
	close_scene()

func close_scene():
	$/root/Dice.reloadMaterials()
	queue_free()
