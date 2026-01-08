extends Equation

class_name EquationInt

var difficult : int = 1
var operator_difficult: int = 1
var rng: RandomNumberGenerator

func _init() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()

func generate_operator() -> String:
	var operator = rng.randi_range(0, operator_difficult - 1)
	if operator == 0: return "+"
	elif operator == 1: return "-"
	elif operator == 2: return "*"
	else: return "/"

func generate_argument() -> int:
	return rng.randi_range(0, 2 * difficult)

func generate() -> void:
	var a = generate_argument()
	var b = 1 + generate_argument()
	var operator = generate_operator()
	if operator == "/":
		a = rng.randi_range(1, 9) * b
	var expression = Expression.new()
	question = "%d %s %d" % [a, operator, b]
	var error = expression.parse(question)
	if error == OK:
		result = expression.execute()

func test(_result: float) -> bool:
	return true
