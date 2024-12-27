extends CharacterBody3D


const SPEED = 2.5
const JUMP_VELOCITY = 4.5
var itemarr = [0,0,0,0]
var itemsel = 1
var camuse = false
var placecam = false
signal viewcam
signal cam1
signal cam2
signal cam3
signal camhand
signal placecamtrue
signal placecamfalse
signal camvisible
signal caminvisible
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func get_ray_location():
	return $Camera3D/RayCast3D.get_collision_point().x

func _unhandled_input(event):
	if event is InputEventMouseMotion and camuse == false:
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
			if itemsel == 0:
				itemsel = 3
			else:
				itemsel = 0
			$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.5)
			$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
			$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)
		if event.pressed and event.keycode == KEY_2:
			if itemsel == 1:
				itemsel = 3
			else:
				itemsel = 1
			$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
			$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.5)
			$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)
		if event.pressed and event.keycode == KEY_3:
			if itemsel == 2:
				itemsel = 3
			else:
				itemsel = 2
			$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
			$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
			$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.5)
		if itemsel == 3:
			$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
			$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
			$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)

func update_items():
	match itemsel:
		0:
			if itemarr[itemsel] == 0:
				$"Camera3D/Control/Item1-AnS".play("empty")
			if itemarr[itemsel] == 1:
				$"Camera3D/Control/Item1-AnS".play("cam")
			if itemarr[itemsel] == 2:
				$"Camera3D/Control/Item1-AnS".play("baricade")
		1:
			if itemarr[itemsel] == 0:
				$"Camera3D/Control/Item1-AnS2".play("empty")
			if itemarr[itemsel] == 1:
				$"Camera3D/Control/Item1-AnS2".play("cam")
			if itemarr[itemsel] == 2:
				$"Camera3D/Control/Item1-AnS".play("baricade")
		2:
			if itemarr[itemsel] == 0:
				$"Camera3D/Control/Item1-AnS3".play("empty")
			if itemarr[itemsel] == 1:
				$"Camera3D/Control/Item1-AnS3".play("cam")
			if itemarr[itemsel] == 2:
				$"Camera3D/Control/Item1-AnS".play("baricade")



func _physics_process(delta):
	print(SimpletonScript.playernoise)
	#print(itemsel)
	#print(placecam)
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
	 
	
	$Camera3D/Control/Point.modulate = Color(1,1,1,0.3)
	if $Camera3D/RayCast3D.is_colliding():
		if $Camera3D/RayCast3D.get_collider().name == "Cam":
			print("Cam")
		if $Camera3D/RayCast3D.get_collider().name == "WinDown1":
			print("WinDown1")
		if $Camera3D/RayCast3D.get_collider().name == "Zatarasy1":
			if Input.is_action_pressed("lclick"):
				$Camera3D/RayCast3D.get_collider().visible = true

		if $Camera3D/RayCast3D.get_collider().name == "Cam" and placecam == false:
			if $Camera3D/RayCast3D.get_collider().visible == true:
				$Camera3D/Control/Point.modulate = Color(1,1,1,1)
				if Input.is_action_pressed("lclick"):
					if itemsel !=3:
						itemarr[itemsel] = 1
					update_items()

		if $Camera3D/RayCast3D.get_collider().name == "PickUpBar":
			if $Camera3D/RayCast3D.get_collider().visible == true:
				$Camera3D/Control/Point.modulate = Color(1,1,1,1)
				if Input.is_action_pressed("lclick"):
					if itemsel !=3:
						itemarr[itemsel] = 2
						$Camera3D/RayCast3D.get_collider().visible = false
					update_items()
					
		if $Camera3D/RayCast3D.get_collider().name == "WinDown1":
			if $Camera3D/RayCast3D.get_collider().visible == false:
				$Camera3D/Control/Point.modulate = Color(1,1,1,1)
				if Input.is_action_pressed("lclick"):
					if itemarr[itemsel] == 2:
						itemarr[itemsel] = 0
						$Camera3D/RayCast3D.get_collider().visible = true
						SimpletonScript.barikadyOken[0] = 1
					update_items()

		if $Camera3D/RayCast3D.get_collider().name == "Cam1":
			if itemarr[itemsel] == 1:
				$Camera3D/Control/Point.modulate = Color(1,1,1,1)
				if Input.is_action_pressed("lclick"):
					emit_signal("cam1")
					if itemsel != 3:
						itemarr[itemsel] = 0
					update_items()

		if $Camera3D/RayCast3D.get_collider().name == "ViewCam":
			if Input.is_action_pressed("lclick"):
				emit_signal("viewcam")
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_key_pressed(KEY_ESCAPE):
		camuse = false
		$Camera3D.make_current()
		$Camera3D/Control/EscapeLabel.visible = false
		$Camera3D/Control/Bila.visible = false
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and camuse == false:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")
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
