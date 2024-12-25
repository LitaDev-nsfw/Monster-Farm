extends Node2D

var structureTileMap: TileMapLayer
var terrainTileMap: TileMapLayer
var overlayTileMap: TileMapLayer
var overlayTileMapModulate: Color
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_parent().get_parent().ready
	for tilemap in get_tree().get_nodes_in_group("tilemaps"):
		match tilemap.name: 
			"Terrain": terrainTileMap = tilemap
			"Structures": structureTileMap = tilemap
			"Overlay": overlayTileMap = tilemap; overlayTileMapModulate = tilemap.modulate

var disabled = true:
	set(value):
		disabled = value
		visible = !disabled
		overlayTileMap.visible = !disabled
@export var builderMoveSpeed = 5
# Called every frame. 'delta' is the elapsed time since the previous frame.
var currentTileData: Dictionary

func _on_button_pressed(tileData):
	print("Builder "+str(tileData))
	currentTileData = tileData


var preventPlacement = false
var overlayTilePos = Vector2i()
var justPlaced = false
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
	
	 
	var mousePos = get_local_mouse_position()
	if overlayTilePos != overlayTileMap.local_to_map(mousePos) or justPlaced:
		justPlaced = false
		overlayTileMap.set_cell(overlayTilePos)
		overlayTilePos = overlayTileMap.local_to_map(mousePos)
		if currentTileData and currentTileData["name"] != "Remove":
			if currentTileData.type == "structure":
				overlayTileMap.set_cell(overlayTilePos,currentTileData.category,currentTileData.id)
			elif currentTileData.type == "connecting":
				overlayTileMap.set_cells_terrain_connect([overlayTilePos],currentTileData.category,currentTileData.id)
			preventPlacement = false
			overlayTileMap.modulate = overlayTileMapModulate
			var fullDimensions = Vector2i(currentTileData.length,currentTileData.width)
			
			for x in fullDimensions.x:
				for y in fullDimensions.y:
					print(Vector2i(x,y))
					var newOverlayTilePos = Vector2i(overlayTilePos.x, overlayTilePos.y)
					if structureTileMap.get_cell_tile_data(Vector2i(newOverlayTilePos.x-x, newOverlayTilePos.y+y)):
						#print(Vector2i(newOverlayTilePos.x+x, newOverlayTilePos.y+y))
						preventPlacement = true
						overlayTileMap.modulate = Color(.8,.2,.2,.5)
				
				

	if Input.is_action_pressed("leftClick"):
		if !currentTileData or (preventPlacement and currentTileData["name"] != "Remove"):
			return
		var tileMapPos 
		print("Test 25")
		print(mousePos.y)
		if mousePos.y > -104:
			match currentTileData["type"]:
				"connecting": 
					tileMapPos = structureTileMap.local_to_map(mousePos); 
					structureTileMap.set_cells_terrain_connect([tileMapPos],currentTileData["category"],currentTileData["id"])
					structureTileMap.get_cell_tile_data(tileMapPos).set_custom_data("name",currentTileData.name)
					structureTileMap.get_cell_tile_data(tileMapPos).set_custom_data("cost",currentTileData.cost)
					structureTileMap.get_cell_tile_data(tileMapPos).set_custom_data("size",Vector2i(currentTileData.length,currentTileData.width))
					FarmData.money -= currentTileData.cost
					justPlaced = true
				"structure": 
					tileMapPos = structureTileMap.local_to_map(mousePos)
					structureTileMap.set_cell(tileMapPos,currentTileData.category,currentTileData.id)
					structureTileMap.get_cell_tile_data(tileMapPos).set_custom_data("name",currentTileData.name)
					structureTileMap.get_cell_tile_data(tileMapPos).set_custom_data("cost",currentTileData.cost)
					structureTileMap.get_cell_tile_data(tileMapPos).set_custom_data("size",Vector2i(currentTileData.length,currentTileData.width))
					FarmData.money -= currentTileData.cost
					justPlaced = true
				"remove":
					tileMapPos = structureTileMap.local_to_map(mousePos)
					print(structureTileMap.get_cell_tile_data(tileMapPos))
					if structureTileMap.get_cell_tile_data(tileMapPos):
						print(structureTileMap.get_cell_tile_data(tileMapPos).get_custom_data("cost"))
						FarmData.money += structureTileMap.get_cell_tile_data(tileMapPos).get_custom_data("cost")/2
					structureTileMap.set_cell(tileMapPos,currentTileData["category"],currentTileData["id"])
					for i in structureTileMap.get_surrounding_cells(tileMapPos):
						structureTileMap.get_cell_tile_data(i)
				"terrainTile": tileMapPos = terrainTileMap.local_to_map(mousePos); terrainTileMap.set_cell(tileMapPos,currentTileData["category"],currentTileData["id"])
				_: push_error("invalid tile type in builder currentTileData: "+str(currentTileData["type"]))
				
		
