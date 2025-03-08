extends CharacterBody3D

var enemyInView = false

const SPEED = 4
const JUMP_VELOCITY = 4.5
var itemarr = [0,0,0,0]

var itemArrPoint = [null,null,null,null]
var itemsel: int = 0
var camuse: bool = false
var placecam: bool = false
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


var SudokuView: bool = false




var save_path: String = "user://variable.save"

signal openWindowRoomDoor

signal refreshLocationLabel

var FlashCharged: bool  = true
var LightVisible: bool  = true

var enteringPin: bool  = false



var uiView: bool  = false

var windowsRoomKeycardInHand: bool  = false



var flashBatteries = [2,2,2,2]
var batteryChargers = [0,0,0,0]
#2 - znamena nabite, 1- znamena vybite, 0 znamena neni v inventari

signal openNightOneDoorPl

signal flashEnemy
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var noc: int = 1
var data = {
			"noc": noc,
			"windowRoomState": SimpletonScript.openedWindowsRoom,
			"alarmRoomState": SimpletonScript.alarmFixed,
			"lureRoomState": SimpletonScript.lureFixed,
			"stavOken": [1,1,1,1,1,1,1],
			"RadarState" : SimpletonScript.radarRepaired,
			"GeneratorState": SimpletonScript.generatorFull
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
		SimpletonScript.openedWindowsRoom = data["windowRoomState"] 
		SimpletonScript.alarmFixed = data["alarmRoomState"] 
		SimpletonScript.lureFixed = data["lureRoomState"]
		SimpletonScript.stavOken = data["stavOken"]
		SimpletonScript.radarRepaired = data["RadarState"] 
		SimpletonScript.generatorFull = data["GeneratorState"]
		if SimpletonScript.lureFixed == true:
			$ManagmentSystem/SoundSystem.visible = true
			$ManagmentSystem/NoSoundSys.visible = false
		if SimpletonScript.alarmFixed == true:
			$ManagmentSystem/NoDetectionSys.visible = false
			$ManagmentSystem/DetectionSystem.visible = true
		emit_signal("setWindowModels")
	if noc == 1:
		$Hour.start(20)
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
			$Beep.playing = true
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
							SimpletonScript.generatorFull = true
							collider.get_node("AudioStreamPlayer3D").playing = true
							update_items()
				else:
					$TipTimeOut.start()
					$Camera3D/Control/Tips.visible = true
					$Camera3D/Control/Tips.text = "I need some fuel."
							
		if collider.name == "ObnoveniDetekce":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			if SimpletonScript.generatorFull:
				SimpletonScript.alarmFixed = true
				update_items()
				collider.get_node("PcPropRed").visible = false
				collider.get_node("PcPropGreen").visible = true
				$ManagmentSystem/DetectionSystem.visible = true
				$ManagmentSystem/NoDetectionSys.visible = false
				$TipTimeOut.start()
				$Camera3D/Control/Tips.visible = true
				$Camera3D/Control/Tips.text = "Detection system is now actived."
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
			if SimpletonScript.generatorFull:
						$ManagmentSystem/SoundSystem.visible = true
						$ManagmentSystem/NoSoundSys.visible = false
						SimpletonScript.lureFixed = true
						collider.get_node("PcPropRed").visible = false
						collider.get_node("PcPropGreen").visible = true
						$TipTimeOut.start()
						$Camera3D/Control/Tips.visible = true
						$Camera3D/Control/Tips.text = "Lure system is up and running."
			else:
				$TipTimeOut.start()
				$Camera3D/Control/Tips.visible = true
				$Camera3D/Control/Tips.text = "I should get the generator running first."
		if collider.name == "Pc":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			if uiView == false:
				$Camera3D/Control/Pc.visible = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				uiView = true
				
		if collider.name == "AccRadarPuzzle":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			if uiView == false:
				$Camera3D/Control/SudokuPuzzle.visible = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				SudokuView = true
						
		if collider.name == "KeyCardWindowsRoom" and collider.visible == true:
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			windowsRoomKeycardInHand = true
			$Camera3D/KeycardIcon.visible = true
			collider.visible = false
			$TipTimeOut.start()
			$Camera3D/Control/Tips.visible = true
			$Camera3D/Control/Tips.text = "Spare windows...Room 15?..."
			
		if collider.name == "DoorForWindows":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			if  windowsRoomKeycardInHand == true:
				SimpletonScript.openedWindowsRoom = true
				emit_signal("openWindowRoomDoor")
				windowsRoomKeycardInHand = false
				$Camera3D/KeycardIcon.visible = false
				$TipTimeOut.start()
				$Camera3D/Control/Tips.visible = true
				$Camera3D/Control/Tips.text = "Spare windows? That will come in hand, but it would not be wise to repair anything right now."
			elif SimpletonScript.openedWindowsRoom == false:
				$TipTimeOut.start()
				$Camera3D/Control/Tips.visible = true
				$Camera3D/Control/Tips.text = "Keycard required..."
				
		if collider.name == "NoteOne":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			uiView = true
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "I know you've been busy, William. I know you have been stressed. But still, I was hoping you would remember. Just this one day. Why couldn't you? Do you even remember how old I am, and if not the date, at least the year I was born in? Maybe once you do, you can get the stupid Audio system working again. I do not care anymore, I just want to go home."
				
		if collider.name == "NoteTwo":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			uiView = true
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "H-172 is a large figure without a clear shape or form, but its mass tends to resemble that of most of the time. This appearance is unstable and often changes. Attempts at capture in the forest have proven unsuccessful. H-172 is sensitive to high intensity light. It is not yet understood how, but H-172 can sense when personnel is present in the site, and will attempt to make its way inside. For these reasons, a lure system and a nearby detection system have been constructed."
		if collider.name == "NoteThree":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			uiView = true
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "Operating instructions: The radar roughly estimates the position of any entities in the nearby area. To update the display, press the red button to your right side. The radar can become inaccurate over time. Any entity is guaranteed to be somewhere in the area marked by red. Our laboratory is marked by blue, in case the blue turns into a pink, the entity is nearby, so pay attention. In case you want to calibrate the radar to get better results, go to room 8."
		if collider.name == "NoteFour":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			uiView = true
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "I swear, I've seen it. I may be sleep deprived, but there is no way that I'm just seeing things. I saw the camera feed. How did it get inside undetected? How come it didn't kill anyone? And how did it disappear again? Maybe I'm just going crazy, that's what everyone's telling me. That I need to rest. There is no magic, there are no fairy tales. Everything in this world has to abide by the rules universe has set for us, right? I don't want to know anymore."
		if collider.name == "NoteFive":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			uiView = true
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "To anyone who is here, and should not be. The archiving system used to be locked behind a password, but after the last crash, that feature just is not working. I trust that you have enough respect not to snoop on others. We are all in this together. We all have bad days, but if we want to get out of here, we must cooperate. With regards, Maya Liams."
		if collider.name == "NoteSix":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			uiView = true
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "The lab is closed on Mondays. Important! After 9:00, the laboratory goes through a routine disinfection. If anyone stays when the clock hits that hour, they are as well as dead. No one will be coming to save you."
		if collider.name == "NoteSeven":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			uiView = true
			$Camera3D/Control/Notes.visible = true
			$Camera3D/Control/Notes/Label.text = "Hey, whoever it is that has a shift up here, after me. Trust me, it is not so bad. That thing out there is loud, you will notice if its near. The people down there will also notice its here. You will not die. Just remember to keep your Flash charged, and if you see it near a window, flash it. Everything will be fine. And make yourself a coffee, now would not be the best time to fall asleep."
		if collider.name == "Mapa":
			$Camera3D/Control/Point.modulate = Color(1,1,1,1)
			uiView = true
			$Camera3D/Control/Mapa.visible = true
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
	if event is InputEventMouseMotion and camuse == false and enteringPin == false and uiView == false and SudokuView == false:
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
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.8)
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
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.8)
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
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.8)


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
			itemArrPoint[itemsel].position.y = itemArrPoint[itemsel].position.y + 0.2
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
	
	if $Camera3D/SpotLight3D.light_energy > 0.5:
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
		uiView = false
		SudokuView = false
		$Camera3D/Control/PinCode.visible = false
		$Camera3D/Control/Pc.visible = false
		$Camera3D/Control/Notes.visible = false
		$Camera3D/Control/SudokuPuzzle.visible = false
		$Camera3D/Control/Mapa.visible = false
		#camuse = false
		#$Camera3D.make_current()
		#$Camera3D/Control/EscapeLabel.visible = false
		#$Camera3D/Control/Bila.visible = false
	var input_dir = Vector2(0,0)
	if enteringPin == false and uiView == false and SudokuView == false:
		input_dir = Input.get_vector("a", "d", "w", "s")
	else:
		input_dir = Vector2(0,0)
	if input_dir != Vector2(0,0) and $step1.playing == false:
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
	pass


func _on_audio_stream_player_2_finished() -> void:
	pass


func _on_audio_stream_player_3_finished() -> void:
	pass



func _on_battery_charger_1_timeout() -> void:
	batteryChargers[0] = 2


func _on_timer_timeout() -> void:
	print("hour")
	print(hour)
		
	if hour < 9:
		hour = hour + 1
		$Camera3D/Control/Time.text = str(hour)+":00"
	else:
		if FileAccess.file_exists(save_path) == true:
			var file = FileAccess.open(save_path, FileAccess.WRITE)
			if noc < 5:
				data["noc"] = noc + 1
			if noc == 5:
				data["noc"] = 5
				noc = 6
			data["windowRoomState"] = SimpletonScript.openedWindowsRoom 
			data["alarmRoomState"] = SimpletonScript.alarmFixed 
			data["lureRoomState"] = SimpletonScript.lureFixed 
			data["RadarState"] = SimpletonScript.radarRepaired
			data["GeneratorState"] = SimpletonScript.generatorFull
			if SimpletonScript.openedWindowsRoom == false:
				data["stavOken"] = SimpletonScript.stavOken 
			else:
				data["stavOken"] = [1,1,1,1,1,1,1]
			file.store_var(data)
			if noc == 6:
				get_tree().change_scene_to_file("res://TheEnd.tscn")
			else:
				get_tree().change_scene_to_file("res://after_night.tscn")
			




func _on_tip_time_out_timeout() -> void:
	$Camera3D/Control/Tips.visible = false


func _on_sudoku_puzzle_sudoku_solved() -> void:
	SimpletonScript.radarRepaired = true


func _on_enemy_jumpscare() -> void:
	$Camera3D/Control/JumpscareDark.visible= true


func _on_cough_finished() -> void:
	pass


func _on_step_4_finished() -> void:
	pass


func _on_step_5_finished() -> void:
	pass
