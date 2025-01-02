extends CharacterBody3D
var enemyvec = Vector2(0,0)
var playervec = Vector3(0,0,0)

static var oknopreddole = Vector3(2.1,1.78,-8.3)
static var oknopreddole1 = Vector3(-5.4,1.9,-8.3)
static var oknoVpravodole = Vector3(-10.8,1.9,-0.852)
static var oknoVzaduDole = Vector3(-6.23,1.8,10.652)
static var oknoVzaduDole2 = Vector3(7.24,1.8,10.652)
static var oknoVlevoDole2 = Vector3(10.85,1.8,5.005)
static var oknoVlevoDole = Vector3(10.85,1.8,-4.8)

static var telpreddole = Vector3(2.2,0.5,-5)
static var telpreddole1 = Vector3(-5.2,0.5,-5.9)
static var telVpravodole = Vector3(-6.8,0.5,-0.1)
static var telVzaduDole = Vector3(-6.1,0.5,7.8)
static var telVzaduDole2 = Vector3(7.4,0.5,7.8)
static var telVlevoDole2 = Vector3(8,0.5,4.9)
static var telVlevoDole = Vector3(8.0,0.5,-5.0)

static var theForest = Vector3(-1,0.9,-34)

var nextCheck = [0,0,0,0,0,0,0]
var nextDesOkno = 0
var nextDesLoc = Vector3(0,0,0)


var nextDesIsWindow = false
var reachedWinndow = false
var isFlashed = false
var InterestChecksLeft = 3

var agression = 0

var PlayerHunt = false

@onready var nav_agent = $NavigationAgent3D
var SPEED = 2.0

func next_destination():
	if isFlashed == false and InterestChecksLeft > 0:
		var foundnextdes = false
		for i in range(nextCheck.size()):
			if nextCheck[i] == 0 and foundnextdes == false:
				nextCheck[i] = 1
				foundnextdes = true
				nextDesOkno = i
				
				
			print("next Window of enemy")
			print(nextDesOkno)
		match(nextDesOkno):
			0:
				nextDesLoc = oknopreddole
			1:
				nextDesLoc = oknopreddole1
			2:
				nextDesLoc = oknoVpravodole
			3:
				nextDesLoc = oknoVzaduDole
			4:
				nextDesLoc = oknoVzaduDole2
			5:
				nextDesLoc = oknoVlevoDole2
			6:
				nextDesLoc = oknoVlevoDole
			_:
				# Default case if no match
				nextDesLoc = Vector3(0, 0, 0)
		nav_agent.set_target_position(nextDesLoc)
		nextDesIsWindow = true
		InterestChecksLeft = InterestChecksLeft - 1
	else:
		nav_agent.set_target_position(theForest)
		isFlashed = false
		reachedWinndow = false
		nextDesIsWindow = false
		InterestChecksLeft = 3
		agression = 0




func _physics_process(delta):
	if reachedWinndow and SimpletonScript.playernoise > 40 and agression <1:
		agression = 1
		$AnnoyedGrowl.playing = true
		InterestChecksLeft += 1
	if reachedWinndow and SimpletonScript.playernoise > 60 and agression <2:
		agression = 2
		$AnnoyedGrowl.playing = true
		InterestChecksLeft +=1
	var current_location = global_transform.origin
	if PlayerHunt == true:
		nav_agent.set_target_position(playervec)
	var next_location = nav_agent.get_next_path_position()
	enemyvec.x = next_location.x - self.position.x
	enemyvec.y = next_location.z - self.position.z
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = velocity.move_toward(new_velocity,.25)
	move_and_slide()
	self.rotation.y = -enemyvec.angle() -1.5
	
	

func update_player_location(player_location):
	playervec = player_location



func _on_navigation_agent_3d_target_reached():
	pass


func _on_navigation_agent_3d_navigation_finished():
	print("NavigaceDokoncena")
	if nextDesIsWindow:
		reachedWinndow = true
		$WaitNearWindow.start()
	else:
		next_destination()



func _on_start_timer_timeout():
	next_destination()
	$Model/AnimationPlayer.play("walk")



func _on_wait_near_window_timeout():
	if InterestChecksLeft > 0:
		match(nextDesOkno):
			0:
				if SimpletonScript.barikadyOken[0] == 0 and isFlashed == false:
					self.position = telpreddole
					PlayerHunt = true
				else:
					isFlashed = false
					next_destination()
					print("next_des")
			1:
				if SimpletonScript.barikadyOken[1] == 0 and isFlashed == false:
					self.position = telpreddole1
					PlayerHunt = true
				else:
					isFlashed = false
					next_destination()
					print("next_des")
			2:
				if SimpletonScript.barikadyOken[2] == 0 and isFlashed == false:
					self.position = telVpravodole
					PlayerHunt = true
				else:
					isFlashed = false
					next_destination()
					print("next_des")
			3:
				if SimpletonScript.barikadyOken[3] == 0 and isFlashed == false:
					self.position = telVzaduDole
					PlayerHunt = true
				else:
					isFlashed = false
					next_destination()
					print("next_des")
			4:
				if SimpletonScript.barikadyOken[4] == 0 and isFlashed == false:
					self.position = telVzaduDole2
					PlayerHunt = true
				else:
					isFlashed = false
					next_destination()
					print("next_des")
			5:
				if SimpletonScript.barikadyOken[5] == 0 and isFlashed == false:
					self.position = telVlevoDole2
					PlayerHunt = true
				else:
					isFlashed = false
					next_destination()
					print("next_des")
			6:
				if SimpletonScript.barikadyOken[6] == 0 and isFlashed == false:
					self.position = telVlevoDole
					PlayerHunt = true
				else:
					isFlashed = false
					next_destination()
					print("next_des")
			_:
				# Default case if no match
				self.position = Vector3(0, 0, 0)
	else:
		next_destination()
		


func _on_player_flash_enemy():
	if reachedWinndow == true:
		isFlashed = true
