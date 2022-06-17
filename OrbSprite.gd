extends Sprite

class_name OrbSprite
var orbName

func _init(orbName_: String):
    centered = false
    texture = load("res://.import/Orb_Base.png-0279880cacbbd258f1af6653654c34fd.stex")
    self_modulate = Color(1, 1, 1, 62.0/255.0)
    var coloring = Sprite.new()
    coloring.texture = texture
    coloring.self_modulate = Data.orbs[orbName_]["color"] #Color(1, 1, 0, 1)
    coloring.centered = false
    add_child(coloring)
    scale = Vector2(3, 3)
    orbName = orbName_
