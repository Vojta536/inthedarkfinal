extends CharacterBody3D

var enemyInView = false

const SPEED = 2
const JUMP_VELOCITY = 4.5
var itemarr = [0,0,0,0]

var itemArrPoint = [null,null,null,null]
var itemsel = 0
var camuse = false
var placecam = false
var collider
signal viewcam
signal cam1
signal cam2
signal cam3
signal camhand
signal placecamtrue
signal placecamfalse
signal camvisible
signal caminvisible

signal setWin1Visible
signal setWin2Visible
signal setWin3Visible
signal setWin4Visible
signal setWin5Visible
signal setWin6Visible
signal setWin7Visible

var hour = 0


var SudokuView = false




var save_path = "user://variable.save"

signal openWindowRoomDoor

signal refreshLocationLabel

var FlashCharged = true
var LightVisible = true

var enteringPin = false


var generatorFull = false

var alarmFixed = false

var archivePcView = false

var windowsRoomKeycardInHand = false

var openedWindowsRoom = false

var lureFixed = false

var flashBatteries = [2,2,2,2]
var batteryChargers = [0,0,0,0]
#2 - znamena nabite, 1- znamena vybite, 0 znamena neni v inventari

signal openNightOneDoorPl

signal flashEnemy
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var noc = 1
var data = {
			"noc": noc,
			"windowRoomState": openedWindowsRoom,
			"alarmRoomState": alarmFixed,
			"lureRoomState": lureFixed,
			"stavOken": [1,1,1,1,1,1,1],
			"RadarState" : SimpletonScript.radarRepaired
		}

signal setWindowModels

signal openLabDoor
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	if FileAccess.file_exists(save_path) == false:
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		noc = 1
		file.store_var(data)
	if FileAccess.file_exists(save_path) == true:
		var file = FileAccess.open(save_path,FileAccess.READ)
		data = file.get_var()
		noc = data["noc"] 
		openedWindowsRoom = data["windowRoomState"] 
		alarmFixed = data["alarmRoomState"] 
		lureFixed = data["lureRoomState"]
		SimpletonScript.stavOken = data["stavOken"]
		SimpletonScript.radarRepaired = data["RadarState"] 
		if lureFixed == true:
			$ManagmentSystem/SoundSystem.visible = true
			$ManagmentSystem/NoSoundSys.visible = false
		if alarmFixed == true:
			$ManagmentSystem/NoDetectionSys.visible = false
			$ManagmentSystem/DetectionSystem.visible = true
		emit_signal("setWindowModels")
	if noc > 1:
		emit_signal("openLabDoor")
		emit_signal("openNightOneDoorPl")
	
	
func get_ray_location():
	return $Camera3D/RayCast3D.get_collision_point().x
	
	
func addToInventory(itemID,col):
	var foundSpace = false
	for i in range(1, itemarr.size()):
		if itemarr[i] == 0:
			itemarr[i] = itemID
			itemArrPoint[i] = col
			foundSpace = true
			$Thud.playing = true
			break
	update_items()
	if foundSpace == true:
		return true
	else:
		return false
	
func _placing_barricades(WindowID,colliderFun):
	if colliderFun.visible == false:
		if  SimpletonScript.stavOken[WindowID] == 0:
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			if Input.is_action_pressed("lclick"):
				if itemarr[itemsel] == 2:
					itemarr[itemsel] = 0
					colliderFun.visible = true
					SimpletonScript.stavBarikad[WindowID] = 1
					update_items()
					$Hammer.playing = true
		elif itemarr[itemsel] == 2:
			$TipTimeOut.start()
			$Camera3D/Control/Tips.visible = true
			$Camera3D/Control/Tips.text = "There is no need to barricade this window yet."

func on_leftClick():
	print("ran")
	collider = $Camera3D/RayCast3D.get_collider()
	if $Camera3D/RayCast3D.is_colliding():
		if collider.name == "ButtonMonsterRefresh":
			emit_signal("refreshLocationLabel")
		if collider.name == "Cam" and placecam == false:
			if collider.visible == true:
				$Camera3D/Control/Point.modulate = Color(1,1,1,1)
				if itemsel !=0:
					itemarr[itemsel] = 1
				update_items()


		if collider.get_parent().name == "BarikadyPickUps":
			if collider.visible == true:
				$Camera3D/Control/Point.modulate = Color(1,1,1,1)
				if addToInventory(2,collider) == true:
					collider.visible = false
					
		if collider.name == "Benzin":
			if collider.visible == true:
				$Camera3D/Control/Point.modulate = Color(1,1,1,1)
				if addToInventory(3,collider) == true:
					collider.visible = false
					
					
		if collider.name == "Generator":
			if collider.visible == true:
				$Camera3D/Control/Point.modulate = Color(1,1,1,1)
				if itemsel !=0:
						if itemarr[itemsel] == 3:
							itemarr[itemsel] = 0
							generatorFull = true
							update_items()
				else:
					$TipTimeOut.start()
					$Camera3D/Control/Tips.visible = true
					$Camera3D/Control/Tips.text = "I need some fuel."
							
		if collider.name == "ObnoveniDetekce":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			if generatorFull:
				alarmFixed = true
				update_items()
				collider.get_node("PcPropRed").visible = false
				collider.get_node("PcPropGreen").visible = true
				$ManagmentSystem/DetectionSystem.visible = true
				$ManagmentSystem/NoDetectionSys.visible = false
			else:
				$TipTimeOut.start()
				$Camera3D/Control/Tips.visible = true
				$Camera3D/Control/Tips.text = "I should get the generator running first."
		if collider.name == "PinCode":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			$Camera3D/Control/PinCode.visible = true
			enteringPin = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$TipTimeOut.start()
			$Camera3D/Control/Tips.visible = true
			$Camera3D/Control/Tips.text = "Its locked."
				
		if collider.name == "ObnoveniZvuku":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			if generatorFull:
						$ManagmentSystem/SoundSystem.visible = true
						$ManagmentSystem/NoSoundSys.visible = false
						lureFixed = true
						collider.get_node("PcPropRed").visible = false
						collider.get_node("PcPropGreen").visible = true
			else:
				$TipTimeOut.start()
				$Camera3D/Control/Tips.visible = true
				$Camera3D/Control/Tips.text = "I should get the generator running first."
		if collider.name == "Pc":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			if archivePcView == false:
				$Camera3D/Control/Pc.visible = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				archivePcView = true
				
		if collider.name == "AccRadarPuzzle":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			if archivePcView == false:
				$Camera3D/Control/SudokuPuzzle.visible = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				SudokuView = true
						
		if collider.name == "KeyCardWindowsRoom" and collider.visible == true:
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			windowsRoomKeycardInHand = true
			collider.visible = false
			$TipTimeOut.start()
			$Camera3D/Control/Tips.visible = true
			$Camera3D/Control/Tips.text = "This could be useful"
			
		if collider.name == "DoorForWindows":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			if  windowsRoomKeycardInHand == true:
				openedWindowsRoom = true
				emit_signal("openWindowRoomDoor")
				windowsRoomKeycardInHand = false
				$TipTimeOut.start()
				$Camera3D/Control/Tips.visible = true
				$Camera3D/Control/Tips.text = "Spare windows? Nice."
			else:
				$TipTimeOut.start()
				$Camera3D/Control/Tips.visible = true
				$Camera3D/Control/Tips.text = "A keycard would be nice."
				
		if collider.name == "NoteOne":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			archivePcView = true
			#nechce se mi delat nova promena, tohle poslouzi pro muj ucel
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "I know you've been busy, William. I know you've been stressed. But still, I was hoping you'd remember. Just this one day. Why couldn't you? Do you even remember how old I am, the year I was born in? Do you know how many year's I've been alive on this planet today? Maybe once you do, you can get the stupid Audio system working again. I don't care anymore. I'm going for a walk in the forest, whatever is out there is still better than what's waiting for us at home. I love you, you stupid bastard."
				
		if collider.name == "NoteTwo":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			archivePcView = true
			#nechce se mi delat nova promena, tohle poslouzi pro muj ucel
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "H-172 is a large figure without a clear shape nor form, but it's mass tends to resemble that of a human majority of the times. This appearance is unstable, and often changes.  Attempts at capture in the forest have proven unsuccessful. The house on ground level remains mostly untouched, H-172 reacts negatively to any changes. For security reasons, an improvised lab has been constructed in the large basement complex. H-172 is sensitive to high intensity of light. It is not yet understood how, but H-172 can sense when personnel is present in the site, and H-172 will attempt to make it's way inside at any cost. For these reasons, a lure system and a nearby detection system have been constructed. These along with the long distance radar prove sufficient to provide protection. Cameras are not effective. H-172 is aggressive, and not to be interacted with."
		if collider.name == "NoteThree":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			archivePcView = true
			#nechce se mi delat nova promena, tohle poslouzi pro muj ucel
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "Before anything! Pick up the keycard and open room 15, so you can ge the windows fixed by the end of the night. For the unfortunote soul whose next shift is with this radar: The radar tries to estimate the position of the monster. In case it gets to 6:6, get off your ass and alert someone. That means its here. Its a little innacurace, in case you want to calibrate it, go to room 8. I cannot be bothered."
		if collider.name == "NoteFour":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			archivePcView = true
			#nechce se mi delat nova promena, tohle poslouzi pro muj ucel
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "I swear, I've seen it. I may be sleep deprived, but there is no way that I'm just seeing things. I saw the camera feed. How did it get inside undetected? How come it didn't kill anyone? And how did it disappear again? Maybe I'm just going crazy, that's what everyone's telling me. That I need to rest. There is no magic, there are no fairy tales. Everything in this world has to abide by the rules universe has set for us, so how did it...I don't want to know anymore."
		if collider.name == "NoteFive":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			archivePcView = true
			#nechce se mi delat nova promena, tohle poslouzi pro muj ucel
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "I can't stand it here anymore. The other's are scientists, they at least have some ACTUAL reason to be here. But me? I'm just a corrupt politician! Was taking a few birpes really that bad enough to get me sent here? Whenever I ask William if we'll ever be able to go home, he says when we capture that thing. Over my dead body, literally! I've seen 4 teams come and die already, why would this one be any different? I want to die, I want to die, I'd rather rot in jail."
		if collider.name == "NoteSix":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			archivePcView = true
			#nechce se mi delat nova promena, tohle poslouzi pro muj ucel
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "Important! In case any staff forgets, the lab gets flooded with gas after 9:00, we cant have any infection spreading like last time. If you are down below when the clock hits 9, you are on your own."
		if collider.is_in_group("metal_doors"):
			collider._openClose()
		match(collider.name):
			"WinDown1":
				_placing_barricades(0,collider)
			"WinDown2":
				_placing_barricades(1,collider)
			"WinDown3":
				_placing_barricades(2,collider)
			"WinDown4":
				_placing_barricades(3,collider)
			"WinDown5":
				_placing_barricades(4,collider)
			"WinDown6":
				_placing_barricades(5,collider)
			"WinDown7":
				_placing_barricades(6,collider)
		if collider.is_in_group("rechargers"):
			$TipTimeOut.start()
			$Camera3D/Control/Tips.visible = true
			$Camera3D/Control/Tips.text = "A battery charger."
			if collider.batteryState() == 2:
				for i in range(flashBatteries.size()):
					if flashBatteries[i] == 0 and collider.batteryState() == 2:
						flashBatteries[i] = 2
						collider.takeChargedBattery()
						update_items()
						break
			else:
				for i in range(flashBatteries.size()):
					if flashBatteries[i] == 1 and collider.batteryState() == 0:
						flashBatteries[i] = 0
						collider.startCharging()
						update_items()
		if collider.name == "ViewCam":
				emit_signal("viewcam")
				camuse = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _input(event):
	if event.is_action_pressed("lclick"):
		on_leftClick()


func _unhandled_input(event):
	if event is InputEventMouseMotion and camuse == false and enteringPin == false and archivePcView == false and SudokuView == false:
		self.rotate_y(-event.relative.x * 0.01)
		if $Camera3D.rotation.x > 1.5 and -event.relative.y < 0 :
			$Camera3D.rotate_x(-event.relative.y * 0.005)
		if $Camera3D.rotation.x < -1.5 and -event.relative.y > 0 :
			$Camera3D.rotate_x(-event.relative.y * 0.005)
		if $Camera3D.rotation.x <= 1.5 and $Camera3D.rotation.x >= -1.5:
			$Camera3D.rotate_x(-event.relative.y * 0.005)
		get_viewport().warp_mouse(get_viewport().size / 2.0)
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_1:
			if itemsel == 1:
				itemsel = 0
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)
			else:
				itemsel = 1
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.5)
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)
		if event.pressed and event.keycode == KEY_2:
			if itemsel == 2:
				itemsel = 0
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)
			else:
				itemsel = 2
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.5)
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)
		if event.pressed and event.keycode == KEY_3:
			if itemsel == 3:
				itemsel = 0
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)
			else:
				itemsel = 3
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.5)


func update_items():
	var ItemSelString = ""
	for i in range(1,4):
		match i:
			1:
				ItemSelString = "Camera3D/Control/Item1-AnS"
			2:
				ItemSelString = "Camera3D/Control/Item1-AnS2"
			3:
				ItemSelString = "Camera3D/Control/Item1-AnS3"
		if itemarr[i] == 0:
			get_node(ItemSelString).play("empty")
		if itemarr[i] == 1:
			get_node(ItemSelString).play("cam")
		if itemarr[i] == 2:
			get_node(ItemSelString).play("baricade")
		if itemarr[i] == 3:
			get_node(ItemSelString).play("benzin")

	match flashBatteries[0]:
		0:
			$Camera3D/Control/FlashBatterySprite.modulate = Color(1,1,1,0.1)
		1:
			$Camera3D/Control/FlashBatterySprite.modulate = Color(1,0.5,0,0.25)
		2:
			$Camera3D/Control/FlashBatterySprite.modulate = Color(1,1,1,1)
	match flashBatteries[1]:
		0:
			$Camera3D/Control/FlashBatterySprite2.modulate = Color(1,1,1,0.1)
		1:
			$Camera3D/Control/FlashBatterySprite2.modulate = Color(1,0.5,0,0.25)
		2:
			$Camera3D/Control/FlashBatterySprite2.modulate = Color(1,1,1,1)
	match flashBatteries[2]:
		0:
			$Camera3D/Control/FlashBatterySprite3.modulate = Color(1,1,1,0.1)
		1:
			$Camera3D/Control/FlashBatterySprite3.modulate = Color(1,0.5,0,0.25)
		2:
			$Camera3D/Control/FlashBatterySprite3.modulate = Color(1,1,1,1)
	match flashBatteries[3]:
		0:
			$Camera3D/Control/FlashBatterySprite4.modulate = Color(1,1,1,0.1)
		1:
			$Camera3D/Control/FlashBatterySprite4.modulate = Color(1,0.5,0,0.25)
		2:
			$Camera3D/Control/FlashBatterySprite4.modulate = Color(1,1,1,1)

func _physics_process(delta):
	$Camera3D/Control/Point.modulate = Color(1,1,1,0.2)
	if Input.is_action_just_pressed("e"):
		if itemsel != 0 and itemarr[itemsel] > 0:
			itemArrPoint[itemsel].visible = true
			itemArrPoint[itemsel].position = $GroundRayCast.get_collision_point()
			itemArrPoint[itemsel].position.y + 0.4
			itemarr[itemsel] = 0
			itemArrPoint[itemsel] = null
			update_items()
	
	if Input.is_action_just_pressed("q"):
		for i in range(flashBatteries.size()):
			if flashBatteries[i] == 2:
				flashBatteries[i] = 1
				if enemyInView == true:
					emit_signal("flashEnemy")
				$Camera3D/SpotLight3D.light_energy = 4
				$FLash.playing = true
				break
		update_items()
		LightVisible = false
	
	if $Camera3D/SpotLight3D.light_energy > 0.3:
		$Camera3D/SpotLight3D.light_energy -= 0.05 
	
	collider = $Camera3D/RayCast3D.get_collider()
	if $Camera3D/RayCast3D.is_colliding():
		if collider.is_in_group("interactable") and collider.visible == true:
			$Camera3D/Control/Point.modulate = Color(1,1,1,0.8)
	

	
	if Input.is_action_just_pressed("r"):
		if LightVisible == true:
			LightVisible = false
			$Camera3D/SpotLight3D.light_energy = 0
		else:
			LightVisible = true
			$Camera3D/SpotLight3D.light_energy = 1
			

	
	if itemarr[itemsel] == 1:
		if placecam == false:
			placecam = true
			emit_signal("camvisible")
			emit_signal("placecamtrue")
	if itemarr[itemsel] != 1:
		if placecam == true:
			placecam = false
			emit_signal("caminvisible")
			emit_signal("placecamfalse")
	
	if placecam == true and Input.is_action_pressed("e"):
		placecam = false
		emit_signal("placecamfalse")
		itemarr[itemsel] = 0
		update_items()
	 
			

#		match(collider.name):
#			"Bordel1":
#				if collider.visible == true:
#					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
#					if Input.is_action_pressed("lclick"):
#						collider.visible = false
#						SimpletonScript.barikadyOken[0] = 1
#						emit_signal("setWin1Visible")
#			"Bordel2":
#				if collider.visible == true:
#					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
#					if Input.is_action_pressed("lclick"):
#						collider.visible = false
#						SimpletonScript.barikadyOken[1] = 1
#						emit_signal("setWin2Visible")
#			"Bordel3":
#				if collider.visible == true:
#					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
#					if Input.is_action_pressed("lclick"):
#						collider.visible = false
#						SimpletonScript.barikadyOken[2] = 1
#						emit_signal("setWin3Visible")
#			"Bordel4":
#				if collider.visible == true:
#					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
#					if Input.is_action_pressed("lclick"):
#						collider.visible = false
#						SimpletonScript.barikadyOken[3] = 1
#						emit_signal("setWin4Visible")
#			"Bordel5":
#				if collider.visible == true:
#					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
#					if Input.is_action_pressed("lclick"):
#						collider.visible = false
#						SimpletonScript.barikadyOken[4] = 1
#						emit_signal("setWin5Visible")
#			"Bordel6":
#				if collider.visible == true:
#					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
#					if Input.is_action_pressed("lclick"):
#						collider.visible = false
#						SimpletonScript.barikadyOken[5] = 1
#						emit_signal("setWin6Visible")
#			"Bordel7":
#				if collider.visible == true:
#					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
#					if Input.is_action_pressed("lclick"):
#						collider.visible = false
#						SimpletonScript.barikadyOken[6] = 1
#						emit_signal("setWin7Visible")






	
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_key_pressed(KEY_ESCAPE):
		$ManagmentSystem.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		camuse = false
		enteringPin = false
		archivePcView = false
		SudokuView = false
		$Camera3D/Control/PinCode.visible = false
		$Camera3D/Control/Pc.visible = false
		$Camera3D/Control/Notes.visible = false
		$Camera3D/Control/SudokuPuzzle.visible = false
		#camuse = false
		#$Camera3D.make_current()
		#$Camera3D/Control/EscapeLabel.visible = false
		#$Camera3D/Control/Bila.visible = false
	# Handle Jump.


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Vector2(0,0)
	if enteringPin == false and archivePcView == false and SudokuView == false:
		input_dir = Input.get_vector("a", "d", "w", "s")
	else:
		input_dir = Vector2(0,0)

	if input_dir != Vector2(0,0) and $step1.playing == false and $step2.playing == false and $step3.playing == false:
		$step1.playing = true


	if camuse == false:
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	else:
		velocity.x = 0
		velocity.z = 0
	move_and_slide()











	


func _on_node_3d_usingcamera():
	camuse = true
	$Camera3D/Control/EscapeLabel.visible = true
	$Camera3D/Control/Bila.visible = true


func _on_enemy_detector_area_entered(area):
	if area.name == "EnemyArea":
		enemyInView = true
		print("enemakSpatren")


func _on_enemy_area_area_exited(area):
	if area.name == "EnemyArea":
		enemyInView = false
		print("enemakOdesel")





func _on_audio_stream_player_finished() -> void:
	if Input.get_vector("a", "d", "w", "s") != Vector2(0,0):
		if randi() % 2 == 0:
			$step3.playing = true
		else:
			$step2.playing = true


func _on_audio_stream_player_2_finished() -> void:
	if Input.get_vector("a", "d", "w", "s") != Vector2(0,0):
		if randi() % 2 == 0:
			$step1.playing = true
		else:
			$step3.playing = true


func _on_audio_stream_player_3_finished() -> void:
	if Input.get_vector("a", "d", "w", "s") != Vector2(0,0):
		if randi() % 2 == 0:
			$step2.playing = true
		else:
			$step1.playing = true



func _on_battery_charger_1_timeout() -> void:
	batteryChargers[0] = 2


func _on_timer_timeout() -> void:
	print("hour")
	print(hour)
	if noc == 1 and hour == 0:
		emit_signal("openLabDoor")
		
	if hour < 10:
		hour = hour + 1
		$Camera3D/Control/Time.text = str(hour)+":00"
	else:
		if FileAccess.file_exists(save_path) == true:
			var file = FileAccess.open(save_path, FileAccess.WRITE)
			data["noc"] = noc + 1
			data["windowRoomState"] = openedWindowsRoom 
			data["alarmRoomState"] = alarmFixed 
			data["lureRoomState"] = lureFixed 
			data["RadarState"] = SimpletonScript.radarRepaired
			if openedWindowsRoom == false:
				data["stavOken"] = SimpletonScript.stavOken 
			else:
				data["stavOken"] = [1,1,1,1,1,1,1]
			file.store_var(data)
			get_tree().change_scene_to_file("res://Menu.tscn")
	if hour == 9 and self.position.y < -4.2:
		$Cough.playing = true
		$Camera3D/Control/JumpscareDark.visible = true
	if hour == 8 and self.position.y < -4.2:
		$LabWarning.playing = true



func _on_tip_time_out_timeout() -> void:
	$Camera3D/Control/Tips.visible = false


func _on_sudoku_puzzle_sudoku_solved() -> void:
	SimpletonScript.radarRepaired = true


func _on_enemy_jumpscare() -> void:
	$Camera3D/Control/JumpscareDark.visible= true


func _on_cough_finished() -> void:
	get_tree().change_scene_to_file("res://Menu.tscn")
