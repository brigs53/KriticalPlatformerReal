#PATCH NOTES 1.0.1:
#Adjusted gravity settings to make gameplay more fluid
#Removed flip animation
#Improved wall jumping
#Controls changed to Hollow Knight controls (for now):
#Jump: Space --> Z
#Attack: V --> X

#Plans
#Add Timothy's Air Dash (8 directions?)
#Adjustable Jumping
#When air slash, make it so that you can still control movement
#Add sword collisions
#Make landing animation to make transition from fall to idle smoother
#Level design: Make black/gray tilesheet?
#How is Timothy doing the levels? Like Hollow Knight?
#Work on options menu
#Work on design of title screen
#Agree on layout of game

extends Character

var state_machine

#Checks if the player is close enough to the wall to be able to wall slide.
var ableWall = false

#Checks if the player is on the wall. If the player is close enough to the wall (ableWall = true) and is on the wall, then wasOnWall = true.
var wasOnWall = false

#Sets player's velocity to zero if changing into a wall sliding state.
var JumpZeroY = false

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	set_process_input(true)

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1))
	var onFloor = is_on_floor()
	
	#Checks if on wall. if on wall, onWall = true.
	var onWall = is_on_wall()
	var move = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	var wallJumpLaunch = 250
	
	
	#Jump Height determined
	var gravity = Utils.jumpGravity(1*jumpHeight, jumpTime)
	
	#DEBUG/TESTS
	#print(velocity.x)
	#print(ableWall)
	#print(wasOnWall)
	#print(is_on_wall())
	#print(state_machine)
	#print(sprite.flip_h)
	#print(JumpZeroY)
	#print(velocity.y)
	
	#GRAVITY
	#falling speed cap included
	velocity.y += 0.85*gravity*delta
	velocity.y = min(velocity.y, 500)

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
		if(velocity.y>-140):
			state_machine.travel("wall slide")
		
	#If not wall sliding and player is falling at 10 units/sec, then fall (animation).
	else:
		if(wasOnWall == false && velocity.y > 10):
			state_machine.travel("fall")
 	
	#STICK ON WALL IF WALL SLIDING 
	#If player is close enough to be on the wall (collisions colliding) and IS on the wall, then keep wall sliding (wasOnWall = true). 
	#If not close enough to wall (off the wall), then disabled sliding.
	if(ableWall == true && is_on_wall() == true):
		wasOnWall = true
	elif(ableWall == false):
		wasOnWall = false

	#WALL SLIDE
	#If on wall, set velocity.y = 0 for a tick.
	if(state_machine.get_current_node() != "wall slide"):
		JumpZeroY = false
	#IDLE-RUN-SPRINT
	#CAN: JUMP, GROUND ATTACK (NORMAL, UP)
	if(state_machine.get_current_node()=="idle"||state_machine.get_current_node()=="run"||state_machine.get_current_node()=="run2"):
		velocity.x = lerp(velocity.x,move*250,.2)
		if Input.is_action_just_pressed("jump"):
			velocity.y = Utils.jumpVelocity(gravity,1.2*jumpTime)
			state_machine.travel("jump")
		if(Input.is_action_just_pressed("attack")):
				if(Input.is_action_pressed("ui_up")):
					state_machine.travel("attack_g_up")
				else:
					state_machine.travel("attack_g_1")

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
			velocity.y = Utils.jumpVelocity(gravity,1*jumpTime)
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
	if(state_machine.get_current_node() == "attack_g_1" || state_machine.get_current_node() == "attack_g_up"):
		velocity.x = lerp(velocity.x,move*120,.25)

	#JUMP-FALL 
	#CAN: MOVE(HINDERED), fastfall
	if(state_machine.get_current_node() == "jump" || state_machine.get_current_node() == "fall"):
		velocity.x = lerp(velocity.x,move*250,.1)
#		if Input.is_action_just_pressed("ui_down"):
#			velocity.y = max(velocity.y,100)
		if Input.is_action_just_pressed("attack"):
			if Input.is_action_pressed("ui_up"):
				state_machine.travel("attack_a_up")
			elif Input.is_action_pressed("ui_down"):
				state_machine.travel("attack_a_down")
			else:
				state_machine.travel("attack_a_1")
#
	#WALL SLIDE
	#CAN: FLIP, fastslide, WALL JUMP
	if(state_machine.get_current_node() == "wall slide"):
		#If statement sets player's velocity.y to 0 for one tick
		if(JumpZeroY == false):
			velocity.y = 0
			JumpZeroY = true
			
		velocity.x = move*20
		if(Input.is_action_pressed("ui_down")):
			velocity.y = min(velocity .y, 175)
		else:
			velocity.y = min(velocity.y, 100)
		if Input.is_action_just_pressed("jump"):
			#velocity.y = Utils.jumpVelocity(gravity,.8*jumpTime)
			velocity.y = Utils.jumpVelocity(gravity,1.2*jumpTime)
			
			if sprite.flip_h == false:
				
				velocity.x = -wallJumpLaunch
				sprite.set_flip_h(true)
			else:
				
				velocity.x = wallJumpLaunch
				sprite.set_flip_h(false)
			wasOnWall = false
			state_machine.travel("jumpWall")	
			
		if sprite.flip_h == false:
			if Input.is_action_just_pressed("ui_left"):
				state_machine.travel("fall")
		else:
			if Input.is_action_just_pressed("ui_right"):
				state_machine.travel("fall")

	#FLIP
	#CAN: MOVE(HINDERED)
	if(state_machine.get_current_node() == "jumpWall"):
		velocity.x = lerp(velocity.x,move*250,.05)
	
	#RESTART
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	
	#QUIT
	if Input.is_action_pressed("quit"):
		get_tree().quit()



func _on_WallCollision_body_entered(body):
		ableWall = true
		print("Entered") # Replace with function body.


func _on_WallCollision_body_exited(body):
	ableWall = false
	print("Exited") # Replace with function body.
