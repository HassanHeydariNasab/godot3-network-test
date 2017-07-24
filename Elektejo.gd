extends Control

onready var Nomo = get_node("Nomo")

func _ready():
	pass

func _on_Servilo_pressed():
	Ludstato.servi(Nomo.get_text())

func _on_Kliento_pressed():
	Ludstato.aligxi(Nomo.get_text())