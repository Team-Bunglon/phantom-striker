extends Node2D
class_name Collectible

## The text that appears when the collectible is obtained.
## Feel free to edit this for your own level with your own text.
@export var obtain_text: Array[String] = [
	"awesome!",
	"obtain!",
	"yippe!",
	"great!",
	"nice!",
	"good!",
	"yes!",
	"1000"
	]

## Specific identifier for uniqueness. It needs to be a string since godot is terrible at autoconverting value from a json save.
var identifier: String	

func _ready():
	if name != "Collectible": # The name MUST be "Collectible" to prevent more than one collectible per level. DO NOT DELETE!
		assert(false, "A level can only have one collectible")
	identifier = str(get_parent().get_number())
	if Global.collected.has(identifier):
		$Sprite2D.visible = false
		$CollectibleArea.disconnect("body_entered", _on_collectible_area_body_entered)
	else:
		$AnimationPlayer.play("idle")

func _on_collectible_area_body_entered(body):
	if body.name == "Player":
		Audio.play("Obtain")
		$Obtain.text = obtain_text[randi() % len(obtain_text)]
		$AnimationPlayer.play("obtained")
		$CollectibleArea.disconnect("body_entered", _on_collectible_area_body_entered)
		Global.collected.append(identifier)
		Global.collectibles += 1
