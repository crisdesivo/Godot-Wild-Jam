extends ColorRect


var time = 0


# Called when the node enters the scene tree for the first time.
func _ready():
    setScore(Variables.lastScore)
    pass # Replace with function body.

func _input(event: InputEvent):
    if time > 2:
        if event.is_action_type():
            get_tree().change_scene("res://Main Menu.tscn")

func setScore(score: int):
    $VBoxContainer/Score.text = "Score: " + str(score)

func _process(delta):
    time += delta