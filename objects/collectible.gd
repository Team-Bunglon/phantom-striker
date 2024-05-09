extends Node2D

var identifier: String	# Specific identifier for uniqueness. It needs to be a string since godot has a terrible job at autoconverting value inside an array.

func _ready():
	if name != "Collectible": # The name MUST be "Collectible" to prevent more than one collectible per level. DO NOT DELETE!
		assert(false, "A level can only have one collectible")
	identifier = str(get_parent().get_number())
	if Global.collected.has(identifier):
		$Sprite2D.visible = false
		$CollectibleArea.disconnect("body_entered", _on_collectible_area_body_entered)

func _on_collectible_area_body_entered(body):
	if body.name == "Player":
		$Sprite2D.visible = false
		$CollectibleArea.disconnect("body_entered", _on_collectible_area_body_entered)
		Global.collected.append(identifier)  # collected must be before collectibles
		Global.collectibles += 1
