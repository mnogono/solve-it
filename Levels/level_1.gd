extends Node2D

@onready var question = $Question as TextEdit
@onready var answer = $Answer as LineEdit
@onready var gold = $Gold as Label
@onready var bullet = $Bullet as Label

var gold_value: int = 0
var bullet_count: int = 3
var equation: Equation
var difficult : int = 1
var operator_difficult : int = 1
var solved_count : int = 0
var enemy_imp : PackedScene
enum Item {Freez, Bullet}
var item_cost = {Item.Freez: 10, Item.Bullet: 5}

func next_equation() -> void:
	equation = EquationInt.new()
	equation.difficult = difficult
	equation.operator_difficult = operator_difficult
	equation.generate()
	question.text = equation.question

func _create_enemy() -> Node:
	return enemy_imp.instantiate()

func _add_enemy() -> void:
	var enemy = _create_enemy()
	get_tree().get_first_node_in_group("enemies").add_child(enemy)

func _load_enemies() -> void:
	enemy_imp = preload("res://Enemies/imp/imp.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_equation()
	_load_enemies()

func inc_solved_count() -> void:
	solved_count += 1
	if solved_count % 2 == 0:
		operator_difficult += 1
		if operator_difficult > 4:
			operator_difficult = 1
			difficult += 1

func inc_gold() -> void:
	gold_value += 10 * difficult + 5 * operator_difficult
	_update_gold()
	
func _update_gold() -> void:
	gold.text = "Золото: %d" % gold_value
	
func _update_bullet() -> void:
	bullet.text = "Пули: %d" % bullet_count
	
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

func _on_freez_pressed() -> void:
	_buy_freez()

func _on_add_enemy_pressed() -> void:
	_add_enemy()

func _buy_item(item: Item) -> bool:
	var cost = item_cost[item]
	if gold_value < cost: return false
	gold_value -= cost
	_update_gold()
	return true

func _buy_freez() -> void:
	if _buy_item(Item.Freez):
		_freez()

func _freez() -> void:
	get_tree().paused = true
	await get_tree().create_timer(5.0).timeout
	get_tree().paused = false

func _add_bullet() -> void:
	bullet_count += 1
	_update_bullet()

func _buy_bullet() -> void:
	if _buy_item(Item.Bullet):
		_add_bullet()

func _on_bullet_pressed() -> void:
	_buy_bullet()
