extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var chargeState = 0

func takeChargedBattery():
	chargeState = 0
	$NoBattery.visible = true
	$Charging.visible = false
	$Charged.visible = false

func batteryState():
	return chargeState
	
func startCharging():
	chargeState = 1
	$ChargingTimer.start()
	$NoBattery.visible = false
	$Charging.visible = true
	$Charged.visible = false




func _on_charging_timer_timeout() -> void:
	chargeState = 2
	$NoBattery.visible = false
	$Charging.visible = false
	$Charged.visible = true
