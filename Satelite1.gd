extends TextureRect

var gotshot = false
var gothit = false
var rx
var ry
var r
var atoplanet
var atoplanetx
var atoplanety
var ax
var ay
var vx = .5 
var vy = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gotshot or gothit:
			pass
	else:
		rx= get_node("/root/moonlander/Planet/Ground").position.x-self.rect_position.x
		ry= get_node("/root/moonlander/Planet/Ground").position.y-self.rect_position.y

		r = sqrt(rx*rx+ry*ry)
		atoplanet = get_node('/root/moonlander').Gm/(r*r)
		atoplanetx=0
		atoplanety=0
		if rx!=0:
			atoplanetx= -atoplanet / r*rx
		if ry!=0:
			atoplanety= -atoplanet / r*ry
		ax = atoplanetx
		ay = atoplanety
		vx += ax * delta *100000
		vy += ay * delta  *100000

		self.rect_position.x -=  vx*delta*get_node('/root/moonlander').speedconstant
		self.rect_position.y -=  vy*delta*get_node('/root/moonlander').speedconstant
#
		#$root/Planet/Ground.position.x += vx*delta*speedconstant
		#$root/Planet/Ground.position.y += vy*delta*speedconstant
		

func _blowup_satelite():
	$Flamecontrole.start()
	


func _on_Flamecontrole_timeout():
	if $FlameBurn1.visible == true:
		$FlameBurn1.visible = false
		$FlameBurn2.visible = true
	else:
		$FlameBurn1.visible = true
		$FlameBurn2.visible = false


func _on_Area2DSat_area_entered(area):
	_blowup_satelite()
