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

## When [param shadow_flower] is set, the petal on the sprite will turn darker. If the player strikes anywhere within the level for the first time, this form of collectible will disappear, 
## requiring the player to restart the level. [br][br]
## This is great if the way on getting the collectible or your whole level happen to be achievable without striking once.
@export var shadow_flower: bool = false

## Specific identifier for uniqueness. It needs to be a string since godot is terrible at autoconverting value from a json save.
var identifier: String	
var is_collected: bool = false

func _ready():
	if name != "Collectible": # The name MUST be "Collectible" to prevent more than one collectible per level. DO NOT DELETE!
		assert(false, "A level can only have one collectible")
	identifier = str(get_parent().get_number())
	if Global.collected.has(identifier):
		$AnimationPlayer.play("empty")
		is_collected = true
		$CollectibleArea.disconnect("body_entered", _on_collectible_area_body_entered)
	else:
		if shadow_flower:
			$Sprite2Dark.visible = true
			$AnimationPlayer.play("idle_dark")
		else:
			$Sprite2D.visible = true
			$AnimationPlayer.play("idle")

func _input(event):
	if shadow_flower and not is_collected:
		if event.is_action_pressed("strike_up") or \
			event.is_action_pressed("strike_down") or \
			event.is_action_pressed("strike_left") or \
			event.is_action_pressed("strike_right"):
			Audio.play("Fail")
			is_collected = true
			$Fail.emitting = true
			$AnimationPlayer.play("empty")
			$CollectibleArea.disconnect("body_entered", _on_collectible_area_body_entered)

func _on_collectible_area_body_entered(body):
	if body.name == "Player" and not is_collected:
		Audio.play("Obtain")
		is_collected = true
		$Obtain.text = obtain_text[randi() % len(obtain_text)]
		if shadow_flower:
			$AnimationPlayer.play("obtained_dark")
		else:
			$AnimationPlayer.play("obtained")
		$CollectibleArea.disconnect("body_entered", _on_collectible_area_body_entered)
		Global.collected[identifier] = "0"
		Global.collectibles += 1
