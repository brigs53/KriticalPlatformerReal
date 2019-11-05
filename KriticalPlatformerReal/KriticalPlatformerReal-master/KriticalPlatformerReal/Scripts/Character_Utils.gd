static func jumpGravity(jumpHeight:float,jumpTime:float):
	#kinematics equation for acceleration
	return 2*jumpHeight/(jumpTime*jumpTime)

static func jumpVelocity(gravity: float, jumpTime:float):
	return -gravity*jumpTime