extends MarginContainer

signal orbSelected(index)
signal cancel

# Called when the node enters the scene tree for the first time.
func _ready():
    # initialize("Water Gun", "Fan", "Crossbow")

    # initialize("Crossbow" ,"Water Gun", "Water Gun")
    pass # Replace with function body.

func initialize(orbs):
    show()
    var orb1 = OrbSprite.new(orbs[0].orbName_)
    var orb2 = OrbSprite.new(orbs[1].orbName_)
    var orb3 = OrbSprite.new(orbs[2].orbName_)

    orb1.name = "Sprite"
    orb2.name = "Sprite"
    orb3.name = "Sprite"
    # showOrb(orb1)
    # var orb1 = Orb.createVisualOrb(orbname1)
    # var orb2 = Orb.createVisualOrb(orbname2)
    # var orb3 = Orb.createVisualOrb(orbname3)
    orb1.centered = false
    orb2.centered = false
    orb3.centered = false
    
    # var oldOrb = $VBoxContainer/Orbs/Orb1.get_child(0)
    # $VBoxContainer/Orbs/Orb1.remove_child(oldOrb)
    $VBoxContainer/Orbs/Orb1/Sprite.replace_by(orb1)
    var textL = ""
    for i in orbs[0].level:
        textL += "+"
    $VBoxContainer/Orbs/Orb1/Level.text = textL

    # oldOrb = $VBoxContainer/Orbs/Orb2.get_child(0)
    # $VBoxContainer/Orbs/Orb2.remove_child(oldOrb)
    $VBoxContainer/Orbs/Orb2/Sprite.replace_by(orb2)
    textL = ""
    for i in orbs[1].level:
        textL += "+"
    $VBoxContainer/Orbs/Orb2/Level.text = textL

    # oldOrb = $VBoxContainer/Orbs/Orb3.get_child(0)
    # $VBoxContainer/Orbs/Orb3.remove_child(oldOrb)
    $VBoxContainer/Orbs/Orb3/Sprite.replace_by(orb3)
    textL = ""
    for i in orbs[2].level:
        textL += "+"
    $VBoxContainer/Orbs/Orb3/Level.text = textL

func _on_Orb1_pressed():
    emit_signal("orbSelected", 0)

func _on_Orb2_pressed():
    emit_signal("orbSelected", 1)

func _on_Orb3_pressed():
    emit_signal("orbSelected", 2)

func changePrompt(prompt: String):
    $VBoxContainer/Prompt.text = prompt

# func _on_Button_pressed():
#     if selectedOrb != "" and selectedOrb != null:
#         emit_signal("orbSelected", selectedOrb)

func _on_Button2_pressed():
    emit_signal("cancel")
