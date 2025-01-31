extends CharacterBody2D


const SPEED = 300.0
@onready var nome_jogador = $Label

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
func _ready() -> void:
	nome_jogador.text = "Jogador" + self.name

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		var direction_x := Input.get_axis("ui_left", "ui_right")
		if direction_x:
			velocity.x = direction_x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		var direction_y := Input.get_axis("ui_up", "ui_down")
		if direction_y:
			velocity.y = direction_y * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
