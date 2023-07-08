extends Label

var counter = 0

func on_disable_called():
	counter = 0
	text = str(counter)

func _on_d_pressed():
	counter += 1
	text = str(counter)
