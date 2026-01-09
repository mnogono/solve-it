extends Node

signal level_lost
signal level_won(level_path : String)
@warning_ignore("unused_signal")
signal level_changed(level_path : String)

## Optional path to the next level if using an open world level system.
@export_file("*.tscn") var next_level_path : String

func _on_lose_button_pressed() -> void:
	level_lost.emit()

func _on_win_button_pressed() -> void:
	level_won.emit(next_level_path)

func open_tutorials() -> void:
	%TutorialManager.open_tutorials()

func _ready() -> void:
	open_tutorials()

func _on_tutorial_button_pressed() -> void:
	open_tutorials()

var idx: int = 1
func _process(delta: float) -> void:
	idx += 1
	print("delta %d" % idx)
	pass
