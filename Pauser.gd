extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var paused = false
var pauseDelay = 0.5
var pauseTimer = 0


# Called when the node enters the scene tree for the first time.
func _process(delta):
    pauseTimer += delta
    if Input.is_action_pressed("escape"):
        if pauseTimer > pauseDelay:
            pauseTimer = 0
            print("Accept pressed")
            if not paused:
                get_tree().paused = true
                print("space")
                paused = true
                $ExitButton.show()
            else:
                get_tree().paused = false
                print("space")
                paused = false
                $ExitButton.hide()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_ExitButton_pressed():
    get_tree().quit()