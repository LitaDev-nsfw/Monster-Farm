extends Node2D

@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var Builder = $"Map/Player Structures/Builder"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("buildMode"):
		buildModeSwap()
	if Input.is_action_just_pressed("pause"):
		pass

func _ready():
	Player.get_node("Player Camera").make_current()

var buildMode = false
func buildModeSwap():
	buildMode = !buildMode
	if buildMode:
		Builder.get_node("Builder Camera").make_current()
	else:
		Player.get_node("Player Camera").make_current()
	Player.disabled = buildMode
	Builder.disabled = !buildMode
