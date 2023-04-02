extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 200
const JUMP_VELOCITY = -350
#Animation names
const IDLE_A = "Idle"
const WALK_A = "Walk"
const ATTACK_A = "Attack"
const JUMP_START_A = "JumpStart"
const JUMP_TURN_A = "JumpTurn"
const JUMP_END_A = "JumpEnd"
const DEAD_A = "Dead"
var animationStateMachine

func _physics_process(delta):
	animationStateMachine = $AnimationTree.get('parameters/playback')
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, 200)
		
	# Handle Jump.
	if is_on_floor():
		if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")):
			velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Animation
	if velocity.x == 0:
		animationStateMachine.travel(IDLE_A)
	else: 
		animationStateMachine.travel(WALK_A)
		
	# Animation direction
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
		
	# Jump Animation
	if not is_on_floor():
		print(velocity.y)
		if (velocity.y == 0): 
			animationStateMachine.travel(JUMP_TURN_A)
		elif (velocity.y > 0):
			animationStateMachine.travel(JUMP_END_A)
		else:
			animationStateMachine.travel(JUMP_START_A)

	# Attack Animation
	if (Input.is_action_just_pressed("attack")):
		animationStateMachine.travel(ATTACK_A)
	move_and_slide()

