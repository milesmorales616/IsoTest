extends KinematicBody2D

var anim_direction = "S"
var anim_mode = "Idle"
var animation

var max_speed = 200 #Maximum speed of player
var speed = 0 #Current speed of player
var acceleration = 600 #Acceleration with which the speed approached max_speed
var move_direction #Movement direction as input for the animation player
var moving = false #Boolean that will activate movement and reset speed to 0 if we stood still
var destination = Vector2() #Location where the mouse click happened
var movement = Vector2() #The movement that we will push to the engine


func _unhandled_input(event): #Function that will take any unhandled input
	if event.is_action_pressed('Click'):
		moving = true
		destination = get_global_mouse_position()
		
		
func _process( delta):
	AnimationLoop()
	
	
func _physics_process(delta):
	MovementLoop(delta)
	

func MovementLoop(delta):
	if moving == false:
		speed = 0
	else:
		speed += acceleration * delta
		if speed > max_speed:
			speed = max_speed
	movement = position.direction_to(destination) * speed
	move_direction = rad2deg(destination.angle_to_point(position))
	if position.distance_to(destination) > 10:
		movement = move_and_slide(movement)
	else:
		moving = false
		
		
func AnimationLoop():
	if move_direction <= 15 and move_direction >= -15:
		anim_direction = "E"
	elif move_direction <= 60 and move_direction >= 15:
		anim_direction = "SE"
	elif move_direction <= 120 and move_direction >= 60:
		anim_direction = "S"
	elif move_direction <= 165 and move_direction >= 120:
		anim_direction = "SW"
	elif move_direction <= -60 and move_direction >= -15:
		anim_direction = "NE"
	elif move_direction <= -120 and move_direction >= -60:
		anim_direction = "N"
	elif move_direction <= -165 and move_direction >= -120:
		anim_direction = "NW"
	elif move_direction <= -165 and move_direction >= 165:
		anim_direction = "W"
					
	if moving == true:
		anim_mode = "Walking"
	elif moving == false:
		anim_mode = "Idle"
	
		
	animation = anim_mode + "_" + anim_direction
	get_node("AnimationPlayer").play(animation)
