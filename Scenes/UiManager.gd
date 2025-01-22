extends Control


var digitOne = 0
var digitTwo = 0
var digitThree = 0
var digitFour = 0

signal passcodeEntered

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func displayCode():
	$PinCode/Code.text = str(digitOne) + " " + str(digitTwo) + " " + str(digitThree) + " " + str(digitFour)

func _on_button_down_digit_pressed() -> void:
	if digitOne > 0:
		digitOne = digitOne - 1
		displayCode()


func _on_button_down_digit_2_pressed() -> void:
	if digitTwo > 0:
		digitTwo = digitTwo - 1
		displayCode()


func _on_button_down_digit_3_pressed() -> void:
	if digitThree > 0:
		digitThree = digitThree - 1
		displayCode()


func _on_button_down_digit_4_pressed() -> void:
	if digitFour > 0:
		digitFour = digitFour - 1
		displayCode()


func _on_button_up_digit_pressed() -> void:
	if digitOne < 9:
		digitOne = digitOne + 1
		displayCode()


func _on_button_up_digit_2_pressed() -> void:
	if digitTwo < 9:
		digitTwo = digitTwo + 1
		displayCode()


func _on_button_up_digit_3_pressed() -> void:
	if digitThree < 9:
		digitThree = digitThree + 1
		displayCode()

func _on_button_up_digit_4_pressed() -> void:
	if digitFour < 9:
		digitFour = digitFour + 1
		displayCode()


func _on_enter_pressed() -> void:
	if digitOne == 1 and digitTwo == 9 and digitThree == 7 and digitFour == 3:
		emit_signal("passcodeEntered")
