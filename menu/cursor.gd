# Source: Pefeper - https://youtu.be/AkhPfCF_2Vg
# I recommend you watch his video and slowly understand everything what he has written before copying his code.

extends TextureRect
class_name CursorClass

@export var menu_object: NodePath ## The container the label menu are located in. It should only be a VBoxContainer.
@export var cursor_offset: Vector2 ## The offset of which the cursor's sprite is located by its central point.

@onready var menu_parent := get_node(menu_object)
@onready var cursor_parent := get_parent()

var cursor_index: int = 0

func _process(_delta):
	if not cursor_parent.visible:
		return 

	var input := Vector2.ZERO

	if Input.is_action_just_pressed("ui_up"):
		input.y -= 1
	elif Input.is_action_just_pressed("ui_down"):
		input.y += 1

	if menu_parent is VBoxContainer:
		set_cursor(cursor_index + int(input.y))
	else:
		assert(false, "The menu_object must be a VBoxContainer")

	if Input.is_action_just_pressed("ui_select"):
		var menu_item_current := get_menu_item(cursor_index)
		if menu_item_current != null:
			if menu_item_current.has_method("select"):
				menu_item_current.select()

func get_menu_item(index: int) -> Control:
	if menu_parent == null:
		return null

	if index >= menu_parent.get_child_count() or index < 0:
		return null

	return menu_parent.get_child(index) as Control

func set_cursor(index: int) -> void:
	var menu_item := get_menu_item(index)

	if menu_item == null:
		return

	var menu_post = menu_item.global_position
	var menu_size = menu_item.size

	global_position = Vector2(menu_post.x, menu_post.y + menu_size.y / 2.0) - (size / 2.0) - cursor_offset

	cursor_index = index

