extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("escape"):
        get_tree().change_scene("res://Main Menu.tscn")


func _on_AnimationPlayer_animation_finished(anim_name:String):
    if anim_name == "Fade in out":
        self.get_parent().visible = false
        get_tree().change_scene("res://Main Menu.tscn")

