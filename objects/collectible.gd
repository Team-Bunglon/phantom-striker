extends Node2D

@export var identifier: int = 0

func _ready():
	if Global.collected.has(float(identifier)):
		$Sprite2D.visible = false
		$CollectibleArea.disconnect("body_entered", _on_collectible_area_body_entered)

func _on_collectible_area_body_entered(body):
	if body.name == "Player":
		print("got collectible no." + str(identifier))
		$Sprite2D.visible = false
		$CollectibleArea.disconnect("body_entered", _on_collectible_area_body_entered)
		Global.collected.append(identifier)  # collected must be before collectibles
		Global.collectibles += 1
		print("collect list " + str(Global.collected))
