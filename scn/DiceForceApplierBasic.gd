extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# The force is only applied if we're on the ground
	# Previous versions checked for collisions but it was
	# slower and it didn't work correctly with many dice
	if transform.origin.y <= 1.5:
		var multDelta = delta * 50
		
		# Here we remove the gravity from the accelerometer and make it twice as sensitive to vertical force
		# The device's sensors give the vertical value as Z so to make it work properly we need to put the Z in the Y's place
		var forceToApply : Vector3 = (Input.get_accelerometer() - Input.get_gravity()) * Vector3(100, 100, 200) * multDelta
		forceToApply = Vector3(forceToApply.x, forceToApply.z, forceToApply.y)
		
		var torqueToApply : Vector3 = (Input.get_gyroscope()) * 50 * multDelta
		torqueToApply = Vector3(torqueToApply.x, torqueToApply.z, torqueToApply.y)
		
		apply_force(forceToApply)
		apply_torque(torqueToApply)
