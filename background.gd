extends AnimatedSprite


func _ready():
    var viewportWidth = get_viewport().size.x
    var viewportHeight = get_viewport().size.y
    
    var wscale = viewportWidth / frames.get_frame("default", 0).get_width()
    var hscale = viewportHeight / frames.get_frame("default", 0).get_height()
    scale = Vector2(wscale, hscale)
