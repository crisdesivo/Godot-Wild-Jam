extends Node2D

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    rng.randomize()
    while true:
        yield(get_tree().create_timer(1.0), "timeout")
        spawnGhost()
    pass # Replace with function body.


func spawnGhost():
    var ghost = Enemy.new(5, 0.5, true, load("res://Assets/ghostie.png"), 0.2)
    # var ghost = Enemy.new(10, 2, true, load("res://Assets/spot.png"))
    # ghost.visible = true
    var location = rng.randi_range(0, 3)
    if location == 0:
        ghost.position = Vector2(rng.randi_range(0, int(get_viewport_rect().size.x)), 0)
    elif location == 1:
        ghost.position = Vector2(rng.randi_range(0, int(get_viewport_rect().size.x)), int(get_viewport_rect().size.y))
    elif location == 2:
        ghost.position = Vector2(0, rng.randi_range(0, int(get_viewport_rect().size.y)))
    elif location == 3:
        ghost.position = Vector2(int(get_viewport_rect().size.x), rng.randi_range(0, int(get_viewport_rect().size.y)))
    # ghost.position = Vector2(get_viewport_rect().size.x, location)
    add_child(ghost)
# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#    pass

