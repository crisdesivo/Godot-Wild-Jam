extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    while true:
        yield(get_tree().create_timer(1.0), "timeout")
        spawnGhost()
    pass # Replace with function body.


func spawnGhost():
    var ghost = Enemy.new(5, 2, true, load("res://Assets/ghostie.png"), 0.2)
    # var ghost = Enemy.new(10, 2, true, load("res://Assets/spot.png"))
    # ghost.visible = true
    ghost.position = Vector2(get_viewport_rect().size.x, 0)
    add_child(ghost)
# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#    pass

