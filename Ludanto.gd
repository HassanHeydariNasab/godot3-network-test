extends KinematicBody2D

var tipo = "ludanto"

var rapido = 10
var d_angulo = deg2rad(3)

func _ready():
	set_process(true)


func _process(delta):
	if is_network_master():
		if Input.is_action_pressed("iri"):
			rpc_id(1, "movi", 1)
			move(Vector2(rapido*cos(get_rotation()), rapido*sin(get_rotation())))
		if Input.is_action_pressed("reveni"):
			rpc_id(1, "movi", -1)
			move(Vector2(-rapido*cos(get_rotation()), -rapido*sin(get_rotation())))
		if Input.is_action_pressed("turni_dekstre"):
			rpc_id(1, "turni", 1)
			rotate(d_angulo)
		if Input.is_action_pressed("turni_maldekstre"):
			rpc_id(1, "turni", -1)
			rotate(-d_angulo)
#		if Input.is_action_pressed("pafi"):
#			rpc_id(1, "pafi", angulo)
#			pafi(angulo)

# por servilo
remote func movi(flanko):
	move(Vector2(flanko*rapido*cos(get_rotation()),
				 flanko*rapido*sin(get_rotation()))
		)
	rpc("gxisdatigi_lokon", get_position())
	Ludstato.Ludantoj[get_name()]["loko"] = get_position()

# por ludantoj
remote func gxisdatigi_lokon(loko):
	#PORFARI esceptu la ludanton
	set_position(loko)

# por servilo
remote func turni(flanko):
	rotate(d_angulo*flanko)
	rpc("gxisdatigi_turnon", get_rotation())
	Ludstato.Ludantoj[get_name()]["turno"] = get_rotation()

# por ludantoj
remote func gxisdatigi_turnon(angulo):
	#PORFARI esceptu la ludanton
	set_rotation(angulo)