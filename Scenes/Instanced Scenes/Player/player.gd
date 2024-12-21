extends CharacterBody2D


const SPEED = 100.0
@export var disabled = false

func _ready():
	add_to_group("Player")
var facing = 2
func _physics_process(delta):
	if disabled: return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("moveLeft", "moveRight","moveUp","moveDown")
	if direction:
		facing = round(direction.angle()*2/PI)+1
		if $AnimatedSprite2D.animation == "Idle":
			print("test 32")
			match facing:
				0: $AnimatedSprite2D.play("Move Up") 
				1: $AnimatedSprite2D.play("Move Right") 
				2: $AnimatedSprite2D.play("Move Down") 
				3: $AnimatedSprite2D.play("Move Left") 
		velocity = direction * SPEED
		if Input.is_action_pressed("sprint"):
			velocity *= 2
	else:
		if "Move" in $AnimatedSprite2D.animation:
			$AnimatedSprite2D.animation = "Idle"
			$AnimatedSprite2D.frame = facing
		velocity = Vector2()
	
	move_and_slide()
