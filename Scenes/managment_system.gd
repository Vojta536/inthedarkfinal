extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.visible == true and $DetectionSystem.visible == true:
		if SimpletonScript.monsterWall == 0:
			$DetectionSystem/Front2.text = "No Detection"
			$DetectionSystem/Left2.text = "No Detection"
			$DetectionSystem/Back2.text = "No Detection"
			$DetectionSystem/Right2.text = "No Detection"
		elif SimpletonScript.monsterWall == 1:
			$DetectionSystem/Front2.text = "Warning"
			$DetectionSystem/Left2.text = "No Detection"
			$DetectionSystem/Back2.text = "No Detection"
			$DetectionSystem/Right2.text = "No Detection"
		elif SimpletonScript.monsterWall == 2:
			$DetectionSystem/Left2.text = "Warning"
			$DetectionSystem/Back2.text = "No Detection"
			$DetectionSystem/Right2.text = "No Detection"
			$DetectionSystem/Front2.text = "No Detection"
		elif SimpletonScript.monsterWall == 3:
			$DetectionSystem/Right2.text = "No Detection"
			$DetectionSystem/Front2.text = "No Detection"
			$DetectionSystem/Back2.text = "Warning"
			$DetectionSystem/Left2.text = "No Detection"
		elif SimpletonScript.monsterWall == 4:
			$DetectionSystem/Right2.text = "Warning"
			$DetectionSystem/Front2.text = "No Detection"
			$DetectionSystem/Left2.text = "No Detection"
			$DetectionSystem/Back2.text = "No Detection"
