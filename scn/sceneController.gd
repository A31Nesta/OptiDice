extends Node3D

# CODE GRABBED FROM GODOT EXAMPLES!!
# https://github.com/godotengine/godot-demo-projects/blob/master/mobile/sensors/main.gd
# -------------------------------------------------------------------------------------
## Returns an orientation matrix using the magnetometer and gravity vector as inputs.
func orientate_by_mag_and_grav(p_mag: Vector3, p_grav: Vector3) -> Basis:
	var rotate := Basis()
	# As always, normalize!
	p_mag = p_mag.normalized()
	# Gravity points down, so - gravity points up!
	rotate.y = -p_grav.normalized()
	# Cross products with our magnetic north gives an aligned east (or west, I always forget).
	rotate.x = rotate.y.cross(p_mag)
	# And cross product again and we get our aligned north completing our matrix.
	rotate.z = rotate.x.cross(rotate.y)
	return rotate
## Takes our gyro input and updates an orientation matrix accordingly.
## The gyro is special as this vector does not contain a direction but rather a
## rotational velocity. This is why we multiply our values with delta.
func rotate_by_gyro(p_gyro: Vector3, p_basis: Basis, p_delta: float) -> Basis:
	var rotate := Basis()
	rotate = rotate.rotated(p_basis.x, p_gyro.x * p_delta)
	rotate = rotate.rotated(p_basis.y, p_gyro.y * p_delta)
	rotate = rotate.rotated(p_basis.z, p_gyro.z * p_delta)
	
	var label = get_node("../CenterContainer/Label")
	label.visible = true
	label.modulate.a = 1
	label.text = str(p_gyro);
	
	return rotate * p_basis
## Returns the basis corrected for drift by our gravity vector.
func drift_correction(p_basis: Basis, p_grav: Vector3) -> Basis:
	# As always, make sure our vector is normalized but also invert as our gravity points down.
	var real_up := -p_grav.normalized()
	# Start by calculating the dot product. This gives us the cosine angle between our two vectors.
	var dot := p_basis.y.dot(real_up)
	# If our dot is 1.0, we're good.
	if dot < 1.0:
		# The cross between our two vectors gives us a vector perpendicular to our two vectors.
		var axis := p_basis.y.cross(real_up).normalized()
		if axis == Vector3(0, 0, 0):
			return p_basis
		var correction := Basis(axis, acos(dot))
		p_basis = correction * p_basis
	return p_basis

# Code actually made by me lol
# ----------------------------
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var acc := Input.get_accelerometer()
	var grav := Input.get_gravity()
	var mag := Input.get_magnetometer()
	var gyro := Input.get_gyroscope()
	
	# Here we remove the gravity from the accelerometer and make it more sensitive to vertical force
	# The device's sensors give the vertical value as Z so to make it work properly we need to put the Z in the Y's place
	#var translation : Vector3 = (Input.get_accelerometer() - Input.get_gravity()) * Vector3(100, 100, 400) * multDelta
	#translation = Vector3(translation.x, translation.z, translation.y)
	
	#transform.origin += translation
	#transform.basis = orientate_by_mag_and_grav(mag, grav).orthonormalized()
	var newBasis := rotate_by_gyro(gyro, transform.basis, delta).orthonormalized()
	transform.basis = drift_correction(newBasis, grav)
