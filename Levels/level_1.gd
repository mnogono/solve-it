extends Node2D

@onready var question = $Question as TextEdit
@onready var answer = $Answer as LineEdit
@onready var gold = $Gold as Label

var gold_value: int = 0
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

func inc_gold() -> void:
	gold_value += 10 * difficult + 5 * operator_difficult
	update_gold()
	
func update_gold() -> void:
	gold.text = "Золото: %d" % gold_value
	
func clear_answer_and_test() -> void:
	var test = int(answer.text)
	answer.text = ""
	if equation.answer == test:
		inc_gold()
		inc_solved_count()
		next_equation()

func _unhandled_input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		# Prevent input if modifiers like Ctrl or Alt are held
		if event.ctrl_pressed or event.alt_pressed: 
			return
			
		# Handle printable characters (Unicode)
		if event.unicode != 0:
			answer.text += char(event.unicode)
			
		# Handle Backspace
		elif event.keycode == KEY_BACKSPACE:
			answer.text = answer.text.left(-1)
		elif event.keycode == KEY_ENTER or KEY_KP_ENTER:
			clear_answer_and_test()
