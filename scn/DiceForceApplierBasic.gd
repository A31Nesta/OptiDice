extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if transform.origin.y <= 1.5:
		var multDelta = delta * 50
		
		var forceToApply : Vector3 = (Input.get_accelerometer() - Input.get_gravity()) * Vector3(100, 100, 200) * multDelta
		forceToApply = Vector3(forceToApply.x, forceToApply.z, forceToApply.y)
		var torqueToApply : Vector3 = (Input.get_gyroscope()) * 50 * multDelta
		torqueToApply = Vector3(torqueToApply.x, torqueToApply.z, torqueToApply.y)
		apply_force(forceToApply)
		apply_torque(torqueToApply)
