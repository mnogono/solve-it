extends Node2D

@onready var question = $TextEdit as TextEdit
@onready var result = $LineEdit as LineEdit
@onready var score = $Label as Label

var score_value: int = 0
var equation: Equation
var difficult : int = 1
var operator_difficult : int = 1
var solved_count : int = 0

func next_equation() -> void:
	equation = EquationInt.new()
	equation.difficult = difficult
	equation.operator_difficult = operator_difficult
	equation.generate()
	question.text = equation.question

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_equation()

func inc_solved_count() -> void:
	solved_count += 1
	if solved_count % 2 == 0:
		operator_difficult += 1
		if operator_difficult > 4:
			operator_difficult = 1
			difficult += 1

func inc_score() -> void:
	score_value += 10 * difficult + 5 * operator_difficult
	update_score()
	
func update_score() -> void:
	score.text = "Очки: %d" % score_value
	
func clear_result_and_test() -> void:
	var test = int(result.text)
	result.text = ""
	if equation.result == test:
		inc_score()
		inc_solved_count()
		next_equation()

func _unhandled_input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		# Prevent input if modifiers like Ctrl or Alt are held
		if event.ctrl_pressed or event.alt_pressed: 
			return
			
		# Handle printable characters (Unicode)
		if event.unicode != 0:
			result.text += char(event.unicode)
			
		# Handle Backspace
		elif event.keycode == KEY_BACKSPACE:
			result.text = result.text.left(-1)
		elif event.keycode == KEY_ENTER or KEY_KP_ENTER:
			clear_result_and_test()
