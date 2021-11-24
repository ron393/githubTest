extends Node2D

var atoplanet
var atoplanetx
var atoplanety
var arocketblast= 0
export var Gm = 6 #gravitätskonstante
var r
var rx
var ry
var ax
var ay
var vx = 0
var vy = 0
export var speedconstant = 500
var rotationspeed = 1
var burn = false
var leftfootonflor = false
var rightfootonflor = false
var win = false
var lasersize = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_lazer_controle()
	if burn or win:
		$Rocket/FlameUp/FlameSoundLoud.stream_paused = true
		$Rocket/FlameRight/FlameSound.stream_paused = true
		$Rocket/FlameLeft/FlameSound.stream_paused = true
		if Input.is_action_pressed("ui_accept"):
			
			
			print("restart game")
	else:
		if Input.is_action_pressed("ui_up"):
			arocketblast =  0.00002
			$Rocket/FlameUp.visible = true
			$Rocket/FlameUp/FlameSoundLoud.stream_paused = false
						
		else:
			arocketblast =  0
			$Rocket/FlameUp.visible = false
			$Rocket/FlameUp/FlameSoundLoud.stream_paused = true
		if Input.is_action_pressed("ui_right"):
			rotationspeed = rotationspeed - 3
			$Rocket/FlameRight.visible=true
			$Rocket/FlameRight/FlameSound.stream_paused = false
		else:
			$Rocket/FlameRight.visible=false
			$Rocket/FlameRight/FlameSound.stream_paused = true
		if Input.is_action_pressed("ui_left"):
			rotationspeed = rotationspeed + 3
			$Rocket/FlameLeft.visible=true
			$Rocket/FlameLeft/FlameSound.stream_paused = false
		else:
			$Rocket/FlameLeft.visible=false
			$Rocket/FlameLeft/FlameSound.stream_paused = true
		
		rx= $Planet/Ground.position.x-$Rocket/Rocket.position.x
		ry= $Planet/Ground.position.y-$Rocket/Rocket.position.y
		
		r = sqrt(rx*rx+ry*ry)
		atoplanet = Gm/(r*r)
		atoplanetx=0
		atoplanety=0
		if rx!=0:
			atoplanetx= -atoplanet / r*rx
		if ry!=0:
			atoplanety= -atoplanet / r*ry
		ay = arocketblast*cos(deg2rad($Planet.rect_rotation)) +atoplanety
		ax = arocketblast*sin(deg2rad($Planet.rect_rotation)) +atoplanetx
		vx += ax * delta *100000
		vy += ay * delta  *100000
		
		$Planet/Ground.position.x += vx*delta*speedconstant
		$Planet/Ground.position.y += vy*delta*speedconstant
		$Planet.rect_rotation = $Planet.rect_rotation + rotationspeed*delta
		pass


func _on_Area2D_area_entered(area):
	if win:
		print("clean landing")
	else:
		print("crash")
		burn=true
		$Rocket/FlameBurn2/BoomSound.play()
		$Rocket/Flamecontrole.start()


func _on_Flamecontrole_timeout():
	if $Rocket/FlameBurn1.visible == true:
		$Rocket/FlameBurn1.visible = false
		$Rocket/FlameBurn2.visible = true
	else:
		$Rocket/FlameBurn1.visible = true
		$Rocket/FlameBurn2.visible = false



func _on_LeftFoot_area_entered(area):
	if !burn:
		leftfootonflor=true
		if rightfootonflor == true:
			win = true
			print("you win")
			$Rocket/GG.visible=true


func _on_RightFoot2_area_entered(area):
	if !burn:
		rightfootonflor=true
		if leftfootonflor == true:
			win = true
			print("you win")
			$Rocket/GG.visible=true

func _on_RightFoot2_area_exited(area):
	rightfootonflor=false


func _on_LeftFoot_area_exited(area):
	leftfootonflor=false




func _on_LazerTimer_timeout():
	$Rocket/Lazer.visible = false
	$Rocket/Lazer/Area2D.monitorable = false
	$Rocket/Lazer/AudioStreamPlayer.stop()


func _on_Timer_timeout():
	if lasersize < 5:
		lasersize = lasersize+1
	else:
		lasersize = 0
	$Rocket/Lazer.scale.x = lasersize*.02

func _lazer_controle():
	if Input.is_action_pressed("ui_shoot"):
		$Rocket/Lazer/LazerTimer.start()
		$Rocket/Lazer.visible = true
		$Rocket/Lazer/Area2D.monitorable = true
		$Rocket/Lazer/AudioStreamPlayer.play()



func _on_Area2DSat_area_entered(area):
	$Rocket/GG.text = 'GG, YOU WIN\n + SATSHOT'
