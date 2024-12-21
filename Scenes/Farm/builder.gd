extends Node2D

var structureTileMap: TileMapLayer
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_parent().ready
	structureTileMap = get_parent()

var disabled = true:
	set(value):
		disabled = value
		visible = !disabled
@export var builderMoveSpeed = 5
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if disabled: return
	if Input.get_last_mouse_velocity().length() > 100:
		var sprite: Sprite2D = $"Sprite2D"
		#print(get_viewport_rect())
		#print(Vector2(DisplayServer.mouse_get_position())/Vector2(DisplayServer.screen_get_size()))
		
		sprite.material.set_shader_parameter("MousePosUV", get_viewport().get_mouse_position()/get_viewport_rect().size)
	var movement = Input.get_vector("moveLeft","moveRight","moveUp","moveDown") * builderMoveSpeed
	if Input.is_action_pressed("sprint"):
		movement *=3
	position += movement
	if Input.is_action_pressed("leftClick"):
		var mousePos = get_local_mouse_position()
		var tileMapPos = structureTileMap.local_to_map(mousePos)
		print("Test 25")
		structureTileMap.set_cells_terrain_connect([tileMapPos],0,0)
