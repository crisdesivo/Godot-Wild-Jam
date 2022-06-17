extends ColorRect

signal orbSelected(orb)
signal orbsSelected(orbs)

var orbs = []

func _on_OrbSelection_orbSelected(orbName):
    # emit_signal("orbSelected", orbName)
    orbs.append(orbName)
    if len(orbs) == 3:
        emit_signal("orbsSelected", orbs)
        Variables.initialOrbs = orbs
        # hide()
        get_tree().change_scene("res://Orb.tscn")
        # orbs = []
    else:
        randomizeSelection()
        var selectedOrbsHolder = $OrbSelection/VBoxContainer/Orbs2
        var orbSprite = OrbSprite.new(orbName)
        if len(orbs) == 1:
            selectedOrbsHolder.get_node("Orb1").add_child(orbSprite)
        elif len(orbs) == 2:
            selectedOrbsHolder.get_node("Orb2").add_child(orbSprite)
        elif len(orbs) == 3:
            selectedOrbsHolder.get_node("Orb3").add_child(orbSprite)
    print(orbs)

func randomizeSelection():
    var orbs = Data.orbs.keys()
    var index = randi() % orbs.size()
    var selected1 = orbs[index]
    orbs.remove(index)

    index = randi() % orbs.size()
    var selected2 = orbs[index]
    orbs.remove(index)

    index = randi() % orbs.size()
    var selected3 = orbs[index]
    print(selected1+" "+selected2+" "+selected3)
    $OrbSelection.initialize(selected1, selected2, selected3)

func _ready():
    randomize()
    randomizeSelection()
