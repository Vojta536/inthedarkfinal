extends CharacterBody3D
var enemyvec = Vector2(0,0)
var playervec = Vector2(0,0)

static var oknopreddole = Vector3(2.1,1.78,-8.3)
static var oknopreddole1 = Vector3(1.9,1.9,-8.3)
static var oknoVpravodole = Vector3(-10.8,1.9,-0.852)
static var oknoVzaduDole = Vector3(-6.23,1.8,10.652)
static var oknoVzaduDole2 = Vector3(7.24,1.8,10.652)
static var oknoVlevoDole2 = Vector3(10.85,1.8,5.005)
static var oknoVlevoDole = Vector3(10.85,1.8,-4.8)

@onready var nav_agent = $NavigationAgent3D
var SPEED = 2.0
func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	enemyvec.x = next_location.x - self.position.x
	enemyvec.y = next_location.z - self.position.z
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = velocity.move_toward(new_velocity,.25)
	nav_agent.set_target_position(oknopreddole)
	move_and_slide()
	self.rotation.y = -enemyvec.angle() -1.5
	
	

func update_player_location(player_location):
	playervec = player_location



func _on_navigation_agent_3d_target_reached():
	print("jeblizko")
