extends Character
var state_machine

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1))
	var onFloor = is_on_floor()
	var onWall = is_on_wall()
	var move = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	#Jump Height determined
	var gravity = Utils.jumpGravity(1.25*jumpHeight, jumpTime)

	#GRAVITY
	#falling speed cap included
	velocity.y += gravity*delta
	velocity.y = min(velocity.y, 1000)

	#ORIENTATION
	if(move < 0 && velocity.x < 0):
		sprite.flip_h = true
	elif(move > 0 && velocity.x > 0):
		sprite.flip_h = false

	#NODE CONTROL
	if(onFloor):
		if(!Input.is_action_pressed("ui_down")):
			if(abs(velocity.x) < 30):
					velocity.x = 0
					state_machine.travel("idle")
			if(abs(velocity.x) >= 30 && abs(velocity.x) < 270):
				state_machine.travel("run")
				#abs(velocity.x) >= 270&& - this was placed below changed so you run when you press run
			if(Input.is_action_pressed("Run")):
				if(move<0):
					velocity.x=-400
				if(move>0):
					velocity.x=400
				state_machine.travel("run2")
		else:
			if(abs(velocity.x) < 10):
				velocity.x = 0
				state_machine.travel("crouch")
			if(abs(velocity.x) >= 30):
				state_machine.travel("crouch walk")
	elif(onWall):
			state_machine.travel("wall slide")
	else:
		if(velocity.y > 10):
			state_machine.travel("fall")

	#IDLE-RUN-SPRINT
	#CAN: JUMP, ATTACK
	if(state_machine.get_current_node()=="idle"||state_machine.get_current_node()=="run"||state_machine.get_current_node()=="run2"):
		velocity.x = lerp(velocity.x,move*275,.2)
		if Input.is_action_just_pressed("jump"):
			velocity.y = Utils.jumpVelocity(gravity,1*jumpTime)
			state_machine.travel("jump")
		if(Input.is_action_just_pressed("attack")):
				state_machine.travel("attack_g_full")

	#IDLE-RUN
	#CAN: CROUCH
	if(state_machine.get_current_node()=="idle"||state_machine.get_current_node()=="run"):
		if Input.is_action_pressed("ui_down"):
			state_machine.travel("crouch")

	#SPRINT
	#CAN: SLIDE
	if(state_machine.get_current_node()=="run2"):
		if Input.is_action_pressed("ui_down"):
			state_machine.travel("ground slide")

	#CROUCH-CROUCH WALK
	#CAN: MOVE(HINDERED), JUMP
	if(state_machine.get_current_node()=="crouch"||state_machine.get_current_node()=="crouch walk"):
		velocity.x = lerp(velocity.x,move*100,.3)
		if Input.is_action_just_pressed("jump"):
			velocity.y = Utils.jumpVelocity(gravity,.8*jumpTime)
			state_machine.travel("jump")

	#GROUND SLIDE
	#CAN: FLIP
	if(state_machine.get_current_node()=="ground slide"):
		velocity.x = lerp(velocity.x, 0, .04)
		if Input.is_action_just_pressed("jump"):
			velocity.y = Utils.jumpVelocity(gravity,.7*jumpTime)
			state_machine.travel("flip")

	#ATTACK 
	#CAN: MOVE(HINDERED)
	if(state_machine.get_current_node() == "attack_g_full"):
		velocity.x = lerp(velocity.x,move*120,.25)

	#JUMP-FALL 
	#CAN: MOVE(HINDERED), fastfall
	if(state_machine.get_current_node() == "jump" || state_machine.get_current_node() == "fall"):
		velocity.x = lerp(velocity.x,move*250,.1)
		if Input.is_action_just_pressed("ui_down"):
			velocity.y = max(velocity.y,100)
#
	#WALL SLIDE
	#CAN: FLIP, fastslide
	if(state_machine.get_current_node() == "wall slide"):
		velocity.x = move*20
		if(Input.is_action_pressed("ui_down")):
			velocity.y = min(velocity .y, 175)
		else:
			velocity.y = min(velocity.y, 100)
		if Input.is_action_just_pressed("jump"):
			velocity.y = Utils.jumpVelocity(gravity,.8*jumpTime)
			state_machine.travel("flip")	

	#FLIP
	#CAN: MOVE(HINDERED)
	if(state_machine.get_current_node() == "flip"):
		velocity.x = lerp(velocity.x,move*250,.05)
	
	#RESTART
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	
	#QUIT
	if Input.is_action_pressed("quit"):
		get_tree().quit()