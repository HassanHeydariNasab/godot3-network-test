extends Node

var mia_ludanto_pretita = false

var Ludanto = preload("res://Ludanto.tscn")

var ludanto_nomo = ""

var Ludantoj = {}

func _ready():
#	get_tree().connect("network_peer_connected", self, "_player_connected")
#	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
#	get_tree().connect("connection_failed", self, "_connected_fail")
#	get_tree().connect("server_disconnected", self, "_server_disconnected")
#	mia_Ludanto = get_node("/root/Radiko/"+str(get_tree().get_network_unique_id()))
	set_fixed_process(true)

func _fixed_process(delta):
	if mia_ludanto_pretita:
		if Input.is_action_pressed("iri"):
			pass
#			mia_Ludanto.set_position(mia_Ludanto.get_position()+Vector2(50,50))

func servi(nomo):
	var reto = NetworkedMultiplayerENet.new()
	reto.create_server(7000, 8)
	get_tree().set_network_peer(reto)
	ludanto_nomo = nomo
	get_node("/root/Radiko/Servilo").queue_free()

func aligxi(nomo):
	var reto = NetworkedMultiplayerENet.new()
	reto.create_client("127.0.0.1", 7000)
	get_tree().set_network_peer(reto)
	ludanto_nomo = nomo
	get_node("/root/Radiko/Kliento").queue_free()

func _connected_ok():
	# diru al servilo ke aldonu min al Ludantoj
	rpc_id(1, "aldoni_Ludanton", get_tree().get_network_unique_id(), ludanto_nomo)
	#	emit_signal("connection_succeeded")

func malplena_loko():
	var loko = get_node("/root/Radiko/Testilo").get_position()
	get_node("/root/Radiko/Testilo").set_position(Vector2(0,0))
	return loko

# por servilo
remote func aldoni_Ludanton(id, nomo):
	Ludantoj[nomo] = {"id":id,
	 "loko":malplena_loko(), "turno":0
	}
	aldoni_la_ludantojn()
	# diru al cxiuj ke prenu Ludantojn
	rpc("preni_Ludantojn", Ludantoj)

# por ludantoj
remote func preni_Ludantojn(nova_Ludantoj):
	Ludantoj = nova_Ludantoj
	print(Ludantoj)
	aldoni_la_ludantojn()

# post preni_Ludantojn
func aldoni_la_ludantojn():
	#aldoni ludantojn se ili ne antauxe aldonigxis
	for ludanto_nomo in Ludantoj.keys():
		if not get_node("/root/Radiko").has_node(ludanto_nomo):
			var _Ludanto = Ludanto.instance()
			_Ludanto.set_name(ludanto_nomo)
			_Ludanto.get_node("Id").set_text(ludanto_nomo)
			_Ludanto.set_network_master(int(Ludantoj[ludanto_nomo]["id"]))
			_Ludanto.set_position(Ludantoj[ludanto_nomo]["loko"])
			_Ludanto.set_rotation(Ludantoj[ludanto_nomo]["turno"])
			get_node("/root/Radiko").add_child(_Ludanto)
