extends Node2D

var mapaCiselNaZnaky = {
	0: "a",
	1: "x",
	2: "y",
	3: "z",
	4: "i",
	5: "q",
	6: "p",
	7: "l",
	8: "b",
	9: "e"
}


var values = [1,9,8,2,7,3,4,2,1]

var SumRight = 0
var SumRight2 = 0
var SumRight3 = 0

var SumDown = 0
var SumDown2 = 0
var SumDown3 = 0

var Hintvalues = [1,1,1,1,1,1,1,1,1]

signal sudokuSolved

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateGui()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func updateGui():
	$SudBut.text = mapaCiselNaZnaky[values[0]]
	$SudBut2.text = mapaCiselNaZnaky[values[1]]
	$SudBut3.text = mapaCiselNaZnaky[values[2]]
	$SudBut4.text = mapaCiselNaZnaky[values[3]]
	$SudBut5.text = str(values[4])
	$SudBut6.text = mapaCiselNaZnaky[values[5]]
	$SudBut7.text = mapaCiselNaZnaky[values[6]]
	$SudBut8.text = str(values[7])
	$SudBut9.text = mapaCiselNaZnaky[values[8]]
	
	SumRight = values[0] + values[1] + values[2]
	SumRight2 = values[3] + values[4] + values[5]
	SumRight3 = values[6] + values[7] + values[8]
	SumDown = values[0] + values[3] + values[6]
	SumDown2 = values[1] + values[4] + values[7]
	SumDown3 = values[2] + values[5] + values[8]
	
	
	$SoucetRight.text = str(SumRight)
	$SoucetRight2.text = str(SumRight2)
	$SoucetRight3.text = str(SumRight3)
	$SoucetDown.text = str(SumDown)
	$SoucetDown2.text = str(SumDown2)
	$SoucetDown3.text = str(SumDown3)
	
	var check1 = true
	for i in range(values.size()):
		for z in range(values.size()):
			if values[i] == values[z] and i != z:
				check1 = false
	if check1 == true:
		$NoRepeatItemsLabel.modulate = Color(0,1,0,1)
	else:
		$NoRepeatItemsLabel.modulate = Color(1,1,1,1)
		
	if SumRight == 15:
		$SoucetRight.modulate = Color(0,1,0,1)
	else:
		$SoucetRight.modulate = Color(1,1,1,1)
		
	if SumRight2 == 15:
		$SoucetRight2.modulate = Color(0,1,0,1)
	else:
		$SoucetRight2.modulate = Color(1,1,1,1)
	
	if SumRight3 == 15:
		$SoucetRight3.modulate = Color(0,1,0,1)
	else:
		$SoucetRight3.modulate = Color(1,1,1,1)
		
	if SumDown == 15:
		$SoucetDown.modulate = Color(0,1,0,1)
	else:
		$SoucetDown.modulate = Color(1,1,1,1)
		
	if SumDown2 == 15:
		$SoucetDown2.modulate = Color(0,1,0,1)
	else:
		$SoucetDown2.modulate = Color(1,1,1,1)
		
	if SumDown3 == 15:
		$SoucetDown3.modulate = Color(0,1,0,1)
	else:
		$SoucetDown3.modulate = Color(1,1,1,1)
	
	if SumDown == 15 and SumDown2 == 15 and SumDown3 == 15 and SumRight == 15 and SumRight2 == 15 and SumRight3 == 15:
		var check = true
		for i in range(values.size()):
			for z in range(values.size()):
				if values[i] == values[z] and i != z:
					check = false
		if check == true:
			emit_signal("sudokuSolved")
	
func valuesFuncton(Id):
	if values[Id] == 9:
		values[Id] = 1
	else:
		values[Id] = values[Id] + 1
		
func HintvaluesFuncton(Id):
	if Hintvalues[Id] == 9:
		Hintvalues[Id] = 1
	else:
		Hintvalues[Id] = Hintvalues[Id] + 1
func _on_sud_but_pressed() -> void:
	valuesFuncton(0)
	updateGui()


func _on_sud_but_2_pressed() -> void:
	valuesFuncton(1)
	updateGui()


func _on_sud_but_3_pressed() -> void:
	valuesFuncton(2)
	updateGui()


func _on_sud_but_4_pressed() -> void:
	valuesFuncton(3)
	updateGui()


func _on_sud_but_5_pressed() -> void:
	valuesFuncton(4)
	updateGui()


func _on_sud_but_6_pressed() -> void:
	valuesFuncton(5)
	updateGui()


func _on_sud_but_7_pressed() -> void:
	valuesFuncton(6)
	updateGui()


func _on_sud_but_8_pressed() -> void:
	valuesFuncton(7)
	updateGui()


func _on_sud_but_9_pressed() -> void:
	valuesFuncton(8)
	updateGui()


func _on_hint_button_pressed() -> void:
	HintvaluesFuncton(0)
	$HintButton.text = str(Hintvalues[0])


func _on_hint_button_2_pressed() -> void:
	HintvaluesFuncton(1)
	$HintButton2.text = str(Hintvalues[1])


func _on_hint_button_3_pressed() -> void:
	HintvaluesFuncton(2)
	$HintButton3.text = str(Hintvalues[2])

func _on_hint_button_4_pressed() -> void:
	HintvaluesFuncton(3)
	$HintButton4.text = str(Hintvalues[3])

func _on_hint_button_5_pressed() -> void:
	HintvaluesFuncton(4)
	$HintButton5.text = str(Hintvalues[4])

func _on_hint_button_6_pressed() -> void:
	HintvaluesFuncton(5)
	$HintButton6.text = str(Hintvalues[5])

func _on_hint_button_7_pressed() -> void:
	HintvaluesFuncton(6)
	$HintButton7.text = str(Hintvalues[6])

func _on_hint_button_8_pressed() -> void:
	HintvaluesFuncton(7)
	$HintButton8.text = str(Hintvalues[7])

func _on_hint_button_9_pressed() -> void:
	HintvaluesFuncton(8)
	$HintButton9.text = str(Hintvalues[8])
