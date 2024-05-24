extends Control

signal start_game()

var can_start = false

func _ready():
	$AnimationPlayer.play("RESET")

func _input(event):
	if event.is_action_pressed("ui_accept") and visible and not can_start:
		can_start = true
		$AnimationPlayer.play("idle")
		$AnimationText.play("idle")
	elif event.is_action_pressed("ui_accept") and visible and can_start:
		emit_signal("start_game")

func start_animation():
	$AnimationPlayer.play("start")

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "start":
		can_start = true
		$AnimationPlayer.play("idle")
		$AnimationText.play("idle")

