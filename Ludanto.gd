extends Node2D

func _ready():
	set_process(true)
	Ludstato.mia_ludanto_pretita = true

func _process(delta):
	if is_network_master():
		if Input.is_action_pressed("iri"):
			
			position.x+=10