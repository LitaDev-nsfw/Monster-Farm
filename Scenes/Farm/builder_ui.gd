extends VBoxContainer

var topRibbon = ["Decor","Structure","Terrain","Remove","Exit"]
var secondaryRibbons = {
	"Decor" = {
		"list": ["Wood Fence","Stone Wall"],
		"Wood Fence": {
			length = 1,
			width = 1,
			cost = 5,
			category = 0,
			id = 0
		},
		"Stone Wall": {
			length = 1,
			width = 1,
			cost = 5,
			category = 0,
			id = 1
		}
	},
	"Structure" = ["Placeholder"],
	"Terrain" = ["Grass","Straw","Clay"]
}
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
				newButton.pressed.connect(_on_second_ribbon_pressed.bind(i,newButton))
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
			"Exit": pass
			_: push_error("Error: bad button name in Builder UI: "+button.name)

func _on_second_ribbon_pressed(header:String, button:Button):
	print(secondaryRibbons[header][button.name])
