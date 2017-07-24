extends Node

var mia_ludanto_pretita = false

var Ludanto = preload("res://Ludanto.tscn")

var ludanto_nomo = ""

var Ludantoj = []
var Ludantoj_plenita = false

func _ready():
#	get_tree().connect("network_peer_connected", self, "_player_connected")
#	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
#	get_tree().connect("connection_failed", self, "_connected_fail")
#	get_tree().connect("server_disconnected", self, "_server_disconnected")
#	mia_Ludanto = get_node("/root/Elektejo/"+str(get_tree().get_network_unique_id()))
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
	get_node("/root/Elektejo/Servilo").queue_free()

func aligxi(nomo):
	var reto = NetworkedMultiplayerENet.new()
	reto.create_client("127.0.0.1", 7000)
	get_tree().set_network_peer(reto)
	ludanto_nomo = nomo
	get_node("/root/Elektejo/Kliento").queue_free()

# por servilo
remote func aldoni_Ludanton(id):
	Ludantoj.append(str(id))
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
	for ludanto_id in Ludantoj:
		if not get_node("/root/Elektejo").has_node(ludanto_id):
			var _Ludanto = Ludanto.instance()
			_Ludanto.set_name(ludanto_id)
			_Ludanto.get_node("Id").set_text(ludanto_id)
			_Ludanto.set_network_master(int(ludanto_id))
			get_node("/root/Elektejo").add_child(_Ludanto)

func _connected_ok():
	print("saluton! mi estas ", get_tree().get_network_unique_id())
	# diru al servilo ke aldonu min al Ludantoj
	rpc_id(1, "aldoni_Ludanton", get_tree().get_network_unique_id())
	#	emit_signal("connection_succeeded")