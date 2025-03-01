extends CharacterBody3D
var enemyvec = Vector2(0,0)
var playervec = Vector3(0,0,0)

static var winFrontDown = Vector3(2.1,1.78,-8.3)
static var winFrontDown1 = Vector3(-5.4,1.9,-8.3)
static var winRightDown = Vector3(-10.8,1.9,-0.852)
static var winBackDown = Vector3(-6.23,1.8,10.652)
static var winBackDown2 = Vector3(7.24,1.8,10.652)
static var winLeftDown2 = Vector3(10.85,1.8,5.005)
static var winLeftDown = Vector3(10.85,1.8,-4.8)

var inJumpscare = false

var firstNight = false
var waiting = false

signal openNightOneDoor

signal jumpscare

signal hunt

func _window_location_match(WindowID):
	match WindowID:
		0:
			return winFrontDown
		1:
			return winFrontDown1
		2:
			return winRightDown
		3:
			return winBackDown
		4:
			return winBackDown2
		5:
			return winLeftDown2
		6:
			return winLeftDown
		_:
			return Vector3.ZERO



static var telpreddole = Vector3(2.2,0.5,-5)
static var telpreddole1 = Vector3(-5.2,0.5,-5.9)
static var telVpravodole = Vector3(-6.8,0.5,-0.1)
static var telVzaduDole = Vector3(-6.1,0.5,7.8)
static var telVzaduDole2 = Vector3(7.4,0.5,7.8)
static var telVlevoDole2 = Vector3(8,0.5,4.9)
static var telVlevoDole = Vector3(8.0,0.5,-5.0)

var distraction = 0

func _tel_location_match(WindowID):
	match WindowID:
		0:
			return telpreddole
		1:
			return telpreddole1
		2:
			return telVpravodole
		3:
			return telVzaduDole
		4:
			return telVzaduDole2
		5:
			return telVlevoDole2
		6:
			return telVlevoDole
		_:
			return Vector3.ZERO

static var theForest = Vector3(-71,0.9,-36.4)

var nextCheck = [0,0,0,0,0,0,0]
var nextDesOkno = 0
var nextDesLoc = Vector3(0,0,0)


var nextDesIsWindow = false
var reachedWinndow = false
var isFlashed = false
var InterestChecksLeft = 3

var agression = 0

var PlayerHunt = false

var playerJumpscare = false

var roaming = true

signal visualiseBreaking1
signal visualiseBreaking2
signal visualiseBreaking3
signal visualiseBreaking4
signal visualiseBreaking5
signal visualiseBreaking6
signal visualiseBreaking7

var save_path = "user://variable.save"
var noc = 1

var data = {
			"noc": noc,
			"windowRoomState": false,
			"alarmRoomState": false,
			"lureRoomState": false,
			"stavOken": [1,1,1,1,1,1,1],
			"RadarState" : SimpletonScript.radarRepaired
		}
		


func _ready():
	if FileAccess.file_exists(save_path) == true:
		var file = FileAccess.open(save_path,FileAccess.READ)
		data = file.get_var()
		noc = data["noc"] 
	match(noc):
		1:
			$MonsterRoamStep.start(1)
			firstNight = true
			InterestChecksLeft = 1
			nextCheck = [1,1,1,0,1,1,1]
		2:
			$MonsterRoamStep.start(20)
		3:
			$MonsterRoamStep.start(15)
		4:
			$MonsterRoamStep.start(11)
		5:
			$MonsterRoamStep.start(8)


@onready var nav_agent = $NavigationAgent3D
var SPEED = 5

func next_destination():
	if isFlashed == false and InterestChecksLeft > 0 and roaming == false:
		var foundnextdes = false
		var randomNumber = 0
		if distraction == 0:
			for i in range(nextCheck.size()):
				randomNumber = randi() % 7
				#print("randomnumber")
				#print(randomNumber)
				if nextCheck[randomNumber] == 0 and foundnextdes == false:
					nextCheck[randomNumber] = 1
					foundnextdes = true
					nextDesOkno = randomNumber
				if nextCheck[i] == 0 and foundnextdes == false:
					nextCheck[i] = 1
					foundnextdes = true
					nextDesOkno = i
		else:
			if distraction == 1:
				nextCheck[0] = 1
				foundnextdes = true
				nextDesOkno = 0
			if distraction == 2:
				nextCheck[2] = 1
				foundnextdes = true
				nextDesOkno = 2
			if distraction == 3:
				nextCheck[3] = 1
				foundnextdes = true
				nextDesOkno = 3
			if distraction == 4:
				nextCheck[5] = 1
				foundnextdes = true
				nextDesOkno = 5
			distraction = 0
		print("next Window of enemy")
		print(nextDesOkno)
		if nextDesOkno < 2:
			SimpletonScript.monsterWall = 1
		elif nextDesOkno < 3:
			SimpletonScript.monsterWall = 2
		elif nextDesOkno < 5:
			SimpletonScript.monsterWall = 3
		elif nextDesOkno < 6:
			SimpletonScript.monsterWall = 4
		match(nextDesOkno):
			0:
				nextDesLoc = winFrontDown
			1:
				nextDesLoc = winFrontDown1
			2:
				nextDesLoc = winRightDown
			3:
				nextDesLoc = winBackDown
			4:
				nextDesLoc = winBackDown2
			5:
				nextDesLoc = winLeftDown2
			6:
				nextDesLoc = winLeftDown
			_:
				# Default case if no match
				nextDesLoc = Vector3(0, 0, 0)
		nav_agent.set_target_position(nextDesLoc)
		nextDesIsWindow = true
		InterestChecksLeft = InterestChecksLeft - 1
	else:
		roaming = true
		SimpletonScript.MonsterLoc[0] = 0
		SimpletonScript.MonsterLoc[1] = 0
		nav_agent.set_target_position(theForest)
		SimpletonScript.monsterWall = 0
		SimpletonScript.MonsterLoc[0] = 9
		SimpletonScript.MonsterLoc[1] = 1
		roaming = true
		for i in range(nextCheck.size()):
			nextCheck[i] = 0
		if firstNight == true:
			$MonsterRoamStep.start(15)
			firstNight = false
			emit_signal("openNightOneDoor")
		else:
			$MonsterRoamStep.start()
		isFlashed = false
		reachedWinndow = false
		nextDesIsWindow = false
		InterestChecksLeft = 3
		agression = 0




func _physics_process(delta):
	if roaming == false  and waiting == false and $step1.playing == false:
		$step1.playing = true
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
	if reachedWinndow == false:
		self.rotation.y = -enemyvec.angle() -1.5
	
	

func update_player_location(player_location):
	playervec = player_location



func _on_navigation_agent_3d_target_reached():
	pass


func _on_navigation_agent_3d_navigation_finished():
	print("NavigaceDokoncena")
	if nextDesIsWindow and PlayerHunt == false:
		reachedWinndow = true
		$WaitNearWindow.start()
		waiting = true
		if nextDesOkno < 2:
			self.rotation.y = deg_to_rad(180)
		elif nextDesOkno < 3:
			self.rotation.y = deg_to_rad(-90)
		elif nextDesOkno < 5:
			self.rotation.y = deg_to_rad(0)
		elif nextDesOkno < 7:
			self.rotation.y = deg_to_rad(90)
	elif roaming == false and PlayerHunt == false:
		next_destination()



func _on_start_timer_timeout():
	pass
	#next_destination()
	#$Model/AnimationPlayer.play("walk")

func _near_window(WindowID):
	if (SimpletonScript.stavBarikad[WindowID] == 0 and SimpletonScript.stavOken[WindowID] == 0) and isFlashed == false:
		self.position = _tel_location_match(WindowID)
		emit_signal("hunt")
		PlayerHunt = true
	else:
		if (SimpletonScript.stavOken[WindowID] == 1 or SimpletonScript.stavBarikad[WindowID] == 1) and isFlashed == false:
			if SimpletonScript.stavOken[WindowID] == 1:
				SimpletonScript.stavOken[WindowID] = 0
				match(WindowID):
					0:
						emit_signal("visualiseBreaking1")
					1:
						emit_signal("visualiseBreaking2")
					2:
						emit_signal("visualiseBreaking3")
					3:
						emit_signal("visualiseBreaking4")
					4:
						emit_signal("visualiseBreaking5")
					5:
						emit_signal("visualiseBreaking6")
					6:
						emit_signal("visualiseBreaking7")
			if SimpletonScript.stavBarikad[WindowID] == 1:
				SimpletonScript.stavBarikad[WindowID] = 0
				match(WindowID):
					0:
						emit_signal("visualiseBreaking1")
					1:
						emit_signal("visualiseBreaking2")
					2:
						emit_signal("visualiseBreaking3")
					3:
						emit_signal("visualiseBreaking4")
					4:
						emit_signal("visualiseBreaking5")
					5:
						emit_signal("visualiseBreaking6")
					6:
						emit_signal("visualiseBreaking7")
		isFlashed = false
		next_destination()
		print("next_des")

func _on_wait_near_window_timeout():
	if InterestChecksLeft >= 0:
		_near_window(nextDesOkno)
	else:
		next_destination()
	waiting = false


func _on_player_flash_enemy():
	if reachedWinndow == true:
		isFlashed = true
		$WaitNearWindow.stop()
		_on_wait_near_window_timeout()


func _on_jumpscare_detector_area_entered(area: Area3D) -> void:
	if inJumpscare == false:
		inJumpscare = true
		$Jumpscare.playing = true
		emit_signal("jumpscare")

func _on_jumpscare_detector_area_exited(area: Area3D) -> void:
	pass # Replace with function body.


func _on_audio_stream_player_3d_finished() -> void:
	get_tree().change_scene_to_file("res://Menu.tscn")


func _on_monster_roam_step_timeout() -> void:
	if roaming == true:
		var randomNumber1 = randi() % 10
		var randomNumber2 = randi() % 10
		
		if randomNumber1 < 8 and SimpletonScript.MonsterLoc[0] < 5 and SimpletonScript.MonsterLoc[0] < 10:
			SimpletonScript.MonsterLoc[0] = SimpletonScript.MonsterLoc[0] + 1
		elif randomNumber1 > 8 and SimpletonScript.MonsterLoc[0] < 5 and SimpletonScript.MonsterLoc[0] > 0:
			SimpletonScript.MonsterLoc[0] = SimpletonScript.MonsterLoc[0] -1
		elif randomNumber1 < 8 and SimpletonScript.MonsterLoc[0] > 5 and SimpletonScript.MonsterLoc[0] > 0:
			SimpletonScript.MonsterLoc[0] = SimpletonScript.MonsterLoc[0] -1
		elif randomNumber1 > 8 and SimpletonScript.MonsterLoc[0] < 5 and SimpletonScript.MonsterLoc[0] < 10:
			SimpletonScript.MonsterLoc[0] = SimpletonScript.MonsterLoc[0] +1
			
		if randomNumber2 < 8 and SimpletonScript.MonsterLoc[1] < 5 and SimpletonScript.MonsterLoc[1] < 10:
			SimpletonScript.MonsterLoc[1] = SimpletonScript.MonsterLoc[1] + 1
		elif randomNumber2 > 8 and SimpletonScript.MonsterLoc[1] < 5 and SimpletonScript.MonsterLoc[1] > 0:
			SimpletonScript.MonsterLoc[1] = SimpletonScript.MonsterLoc[1] -1
		elif randomNumber2 < 8 and SimpletonScript.MonsterLoc[1] > 5 and SimpletonScript.MonsterLoc[1] > 0:
			SimpletonScript.MonsterLoc[1] = SimpletonScript.MonsterLoc[1] -1
		elif randomNumber2 > 8 and SimpletonScript.MonsterLoc[1] < 5 and SimpletonScript.MonsterLoc[1] < 10:
			SimpletonScript.MonsterLoc[1] = SimpletonScript.MonsterLoc[1] +1
		print(SimpletonScript.MonsterLoc[0])
		print(SimpletonScript.MonsterLoc[1])
		if SimpletonScript.MonsterLoc[1] == 5 and SimpletonScript.MonsterLoc[0] == 5:
			roaming = false
			$MonsterRoamStep.stop()
			next_destination()
			$Model/AnimationPlayer.play("walk")
			$ModelNew/AnimationPlayer.play("walk")


func _on_button_front_pressed() -> void:
	distraction = 1


func _on_button_left_pressed() -> void:
	distraction = 2


func _on_button_back_pressed() -> void:
	distraction = 3


func _on_button_rightd_pressed() -> void:
	distraction = 4


func _on_step_1_finished() -> void:
	if roaming == false and waiting == false:
		$step1.playing = true


func _on_step_2_finished() -> void:
	pass


func _on_step_3_finished() -> void:
	pass
