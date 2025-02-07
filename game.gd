extends Node2D

var peer = ENetMultiplayerPeer.new()
const ADDRESS = "127.0.0.1"
const PORT =  3333
@onready var log = $CanvasLayer/Log
@onready var ui = $MultiplayerUI
@onready var campoNick = $MultiplayerUI/Panel/CampoNick
@export var jogador_scene : PackedScene
var jogadores_nome = {}

#Exibir mensagem quando o servidor for criado e exibir mensagens sempre que
#um usuário se conectar
#Esconder menu de Multiplayer ao se conectar ou criar servidor com sucesso

#Na função de join, identificar se o jogador conseguiu se conectar. Se não conseguir
#exibir no log "Falha ao conectar ao servidor"
func _on_botao_join_pressed() -> void:
	var resultado = peer.create_client(ADDRESS, PORT)
	
	if resultado == OK:
		multiplayer.multiplayer_peer = peer
		multiplayer.connected_to_server.connect(sinal_criar_jogador)
		log.text += "Conectado ao servidor! \n"
		ui.visible = false
	else:
		log.text += "Não foi possivel se conectar! Erro: "+str(resultado)+"\n"


func _on_botao_host_pressed() -> void:
	var resultado = peer.create_server(PORT)
	
	if resultado == OK:
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(player_conectado)
		log.text += "Servidor criado na porta "+str(PORT)+"!\n"
		adicionar_jogador(multiplayer.get_unique_id(), campoNick.text)
		ui.visible = false
		#criar personagem
		
	
	else:
		log.text += "Erro ao criar servidor! Código do erro: "+str(resultado) +"\n"
		
	
#Na função player_conectado realizar uma chamada rpc, para a função atualizar_log
#Deve rodar o adicionar_jogador
#Colocar um label no player para exibir o seu número de id
func sinal_criar_jogador():
	rpc_id(1, "adicionar_jogador", multiplayer.get_unique_id(), campoNick.text)
	
func player_conectado(id_jogador):
	log.text += "Cliente "+str(id_jogador)+" conectado ao servidor!\n"
	#Chamada rpc aqui
	rpc("atualizar_log", log.text)
	
@rpc("any_peer","call_local","reliable")
func adicionar_jogador(id_jogador, nick_jogador):
	if multiplayer.is_server():
		var novo_jogador = jogador_scene.instantiate()
		novo_jogador.name = str(id_jogador) 
		novo_jogador.nome_jogador = nick_jogador
		add_child(novo_jogador)
		jogadores_nome[id_jogador] = nick_jogador
		rpc_id(id_jogador,"atualizar_nomes", jogadores_nome)
		
		
@rpc("any_peer", "call_local", "reliable")
func atualizar_nomes(jogadores):
	for id in jogadores:
		var novo_jogador = get_node_or_null(str(id))
		if novo_jogador:
			novo_jogador.mudar_nome(jogadores[id])
			
	print(jogadores)
	
#Criar a função atualizar_log em que recebe o log.text do servidor e modifica o próprio log
@rpc("any_peer", "call_local", "reliable")
func atualizar_log(novo_log):
	log.text = novo_log
