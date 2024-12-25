extends VBoxContainer

var topRibbon = ["Decor","Structure","Terrain","Remove","Exit"]
var secondaryRibbons = {
	"Decor" = {
		"list" = ["Wood Fence","Stone Wall"],
		"Wood Fence" = {
			name = "Wood Fence",
			length = 1,
			width = 1,
			cost = 5,
			type = "connecting",
			category = 0,
			id = 0
		},
		"Stone Wall" = {
			name = "Stone Wall",
			length = 1,
			width = 1,
			cost = 5,
			type = "connecting",
			category = 0,
			id = 1
		}
	},
	"Structure" = {
		list = ["Barn"],
		"Barn" = {
			name = "Barn",
			length = 2,
			width = 2,
			cost = 250,
			type = "structure",
			category = 2,
			id = Vector2i(0,0)
		},
	},
	"Terrain" = {
		list = ["Grass","Straw","Clay"],
		"Grass" = {
			name = "Grass",
			length = 1,
			width = 1,
			cost = 0,
			type = "terrainTile",
			category = 0,
			id = Vector2i(0,0)
		},
		"Straw" = {
			name = "Straw",
			length = 1,
			width = 1,
			cost = 0,
			type = "terrainTile",
			category = 0,
			id = Vector2i(2,0)
		},
		"Clay" = {
			name = "Clay",
			length = 1,
			width = 1,
			cost = 0,
			type = "terrainTile",
			category = 0,
			id = Vector2i(4,0)
		},
	}
}
var removeTileData = {
	name = "Remove",
	length = 1,
	width = 1,
	cost = 5,
	type = "remove",
	category = -1,
	id = Vector2i()
}

func _process(delta):
	$Stats/HBoxContainer/Money.text = "$"+str(FarmData.money)


@onready var buttonNode = preload("res://Scenes/Instanced Scenes/menu_button.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for button in topRibbon:
		var newButton = buttonNode.instantiate()
		newButton.name = button
		newButton.text = button
		newButton.pressed.connect(_on_top_ribbon_pressed.bind(newButton))
		$"First Ribbon/HBoxContainer".add_child(newButton)
		if secondaryRibbons.has(button):
			var secondRibbon = HBoxContainer.new()
			secondRibbon.name = button+"SecondRibbon"
			secondRibbon.add_to_group("Secondary Ribbons")
			$"Second Ribbon".add_child(secondRibbon)
			secondRibbon.visible = false
			for i in secondaryRibbons[button]["list"]:
				newButton = buttonNode.instantiate()
				newButton.name = i
				newButton.text = i
				newButton.pressed.connect(_on_second_ribbon_pressed.bind(button,newButton))
				secondRibbon.add_child(newButton)
			


func _on_top_ribbon_pressed(button:Button):
	print(button)
	if secondaryRibbons.has(button.name):
		for node in get_tree().get_nodes_in_group("Secondary Ribbons"):
			if node.name == button.name+"SecondRibbon":
				
				node.visible = true
			else:
				node.visible = false
	else:
		match button.name:
			"Remove": tileDataButton.emit(removeTileData)
			"Exit": pass
			_: push_error("Error: bad button name in Builder UI: "+button.name)
signal tileDataButton
func _on_second_ribbon_pressed(header:String, button:Button):
	print(header+" "+button.name)
	print(secondaryRibbons[header][button.name])
	tileDataButton.emit(secondaryRibbons[header][button.name])
