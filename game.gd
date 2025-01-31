extends Node2D

var peer = ENetMultiplayerPeer.new() 
const PORT = 3333
const ADDRESS = "127.0.0.1"

func _on_botao_join_pressed() -> void:
	peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer


func _on_botao_host_pressed() -> void:
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
