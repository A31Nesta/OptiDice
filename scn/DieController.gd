extends RigidBody3D

@export var normals = []
@export var values = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# The force is only applied if we're on the ground
	# Previous versions checked for collisions but it was
	# slower and it didn't work correctly with many dice
	if transform.origin.y <= 1.5:
		var multDelta = delta * 75
		
		# Here we remove the gravity from the accelerometer and make it twice as sensitive to vertical force
		# The device's sensors give the vertical value as Z so to make it work properly we need to put the Z in the Y's place
		var forceToApply : Vector3 = (Input.get_accelerometer() - Input.get_gravity()) * Vector3(100, 100, 200) * multDelta
		forceToApply = Vector3(forceToApply.x, forceToApply.z, forceToApply.y)
		
		var torqueToApply : Vector3 = (Input.get_gyroscope()) * 50 * multDelta
		torqueToApply = Vector3(torqueToApply.x, torqueToApply.z, torqueToApply.y)
		
		apply_force(forceToApply)
		apply_torque(torqueToApply)

func isStationary():
	var velThreshold = 0.5
	var angVelThreshold = 0.4
	
	# We just check if the die is not moving or rotating too much
	if linear_velocity.length() < velThreshold && angular_velocity.length() < angVelThreshold:
		return true
	
	return false

func getDieValue():
	if not isStationary():
		return -1
	
	if values.size() == 0:
		return -1
	
	# ---< INSTANT DEATH >--- #
	
	const vector = Vector3(0, 1, 0);
	
	var closestIndex
	var closestAngle = 360
	
	var rAng = quaternion.get_angle()
	var rAxis = quaternion.get_axis().normalized()
	# rAxis = Vector3(rAxis.y, rAxis.x, rAxis.z)
	# print("rAxis: ", rAxis)
	
	for i in range(normals.size()):
		var angle = normals[i].rotated(rAxis, rAng).normalized().angle_to(vector)
		# print("Ang", normals[i].rotated(rAxis, rAng))
		if angle < closestAngle:
			closestAngle = angle
			closestIndex = i
	
	return values[closestIndex]
