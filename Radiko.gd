extends Node2D

onready var Nomo = get_node("Nomo")
onready var Testilo = get_node("Testilo")

func _ready():
	pass

func _on_Servilo_pressed():
	Ludstato.servi(Nomo.get_text())

func _on_Kliento_pressed():
	Ludstato.aligxi(Nomo.get_text())

func _on_Testilo_body_entered( korpo ):
	if korpo.tipo == "ludanto":
		Testilo.position.x += 200
