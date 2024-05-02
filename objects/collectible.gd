extends Node2D

func _ready():
	pass
	#var signals = $CollectibleArea.get_signal_list();
	#for cur_signal in signals:
		#var conns = $CollectibleArea.get_signal_connection_list(cur_signal.name);
		#print(conns)
		#for cur_conn in conns:
			#print(cur_conn.signal);
			#print(cur_conn.callable);

func _on_collectible_area_body_entered(body):
	if body.name == "Player":
		print("got collectible")
		$Sprite2D.visible = false
		$CollectibleArea.disconnect("body_entered", _on_collectible_area_body_entered)
		Global.collectibles += 1
