extends Node2D

var peer = ENetMultiplayerPeer.new()
const ADDRESS = "127.0.0.1"
const PORT =  3333
@onready var log = $Log

#Exibir mensagem quando o servidor for criado e exibir mensagens sempre que
#um usuário se conectar
#Esconder menu de Multiplayer ao se conectar ou criar servidor com sucesso
func _on_botao_join_pressed() -> void:
	peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer


func _on_botao_host_pressed() -> void:
	var resultado = peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
	if resultado == OK:
		multiplayer.peer_connected.connect(player_conectado)
		log.text += "Servidor criado na porta "+str(PORT)+"!\n"
	else:
		log.text += "Erro ao criar servidor! Código do erro: "+str(resultado) +"\n"
		
#Na função player_conectado realizar uma chamada rpc, para a função atualizar_log
func player_conectado(id_jogador):
	log.text += "Cliente "+str(id_jogador)+"conectado ao servidor!\n"
	#Chamada rpc aqui
	


#Criar a função atualizar_log em que recebe o log.text do servidor e modifica o próprio log
@rpc("any_peer", "call_local","reliable")
func atualizar_log(texto):
	pass
	
