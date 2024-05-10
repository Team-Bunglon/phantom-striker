extends Area2D


func _on_body_entered(body):
	if (body.name == "Player"):
		var message_box = get_message_box()
		if message_box:
			message_box.get_node("MessageBoxContainer").show()

func _on_body_exited(body):
	if (body.name == "Player"):
		var message_box = get_message_box()
		if message_box:
			message_box.get_node("MessageBoxContainer").hide()

func get_message_box():
	for child in get_tree().root.get_children():
		var message_box = child.get_node_or_null("MessageBox")
		if message_box:
			return message_box
	return null
