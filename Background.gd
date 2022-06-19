extends Node2D

var timeOn = 0
var maxTime = 1*60

func _ready():
    $Background.play()
    $Background2.play()

func _process(delta):
    if timeOn < maxTime:
        timeOn += delta
        var transparency = timeOn/maxTime

        $Background2.modulate = Color(1, 1, 1, transparency)
        $Pillars2.modulate = Color(1, 1, 1, transparency)
        $Foreground2.modulate = Color(1, 1, 1, transparency)
        

# func _ready():
#     var viewportWidth = get_viewport().size.x
#     var viewportHeight = get_viewport().size.y
    
#     var wscale = viewportWidth / frames.get_frame("default", 0).get_width()
#     var hscale = viewportHeight / frames.get_frame("default", 0).get_height()
#     scale = Vector2(wscale, hscale)
