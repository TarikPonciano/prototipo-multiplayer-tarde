extends Node2D

var peer = ENetMultiplayerPeer.new()
const ADDRESS = "127.0.0.1"
const PORT =  3333

#Exibir mensagem quando o servidor for criado e exibir mensagens sempre que
#um usuário se conectar
#Esconder menu de Multiplayer ao se conectar ou criar servidor com sucesso
func _on_botao_join_pressed() -> void:
	peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer


func _on_botao_host_pressed() -> void:
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
