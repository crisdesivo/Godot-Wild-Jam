extends MarginContainer

signal orbSelected(orbName)
signal cancel

var selectedOrb: String

# Called when the node enters the scene tree for the first time.
func _ready():
    # initialize("Water Gun", "Fan", "Crossbow")

    # initialize("Crossbow" ,"Water Gun", "Water Gun")
    pass # Replace with function body.

func initialize(orbname1: String, orbname2: String, orbname3: String):
    selectedOrb = ""
    var orb1 = OrbSprite.new(orbname1)
    var orb2 = OrbSprite.new(orbname2)
    var orb3 = OrbSprite.new(orbname3)
    showOrb(orb1)
    # var orb1 = Orb.createVisualOrb(orbname1)
    # var orb2 = Orb.createVisualOrb(orbname2)
    # var orb3 = Orb.createVisualOrb(orbname3)
    orb1.centered = false
    orb2.centered = false
    orb3.centered = false
    
    var oldOrb = $VBoxContainer/Orbs/Orb1.get_child(0)
    $VBoxContainer/Orbs/Orb1.remove_child(oldOrb)
    $VBoxContainer/Orbs/Orb1.add_child(orb1)

    oldOrb = $VBoxContainer/Orbs/Orb2.get_child(0)
    $VBoxContainer/Orbs/Orb2.remove_child(oldOrb)
    $VBoxContainer/Orbs/Orb2.add_child(orb2)

    oldOrb = $VBoxContainer/Orbs/Orb3.get_child(0)
    $VBoxContainer/Orbs/Orb3.remove_child(oldOrb)
    $VBoxContainer/Orbs/Orb3.add_child(orb3)


func _on_Orb1_pressed():
    showOrb($VBoxContainer/Orbs/Orb1.get_child(0))

func _on_Orb2_pressed():
    showOrb($VBoxContainer/Orbs/Orb2.get_child(0))

func _on_Orb3_pressed():
    showOrb($VBoxContainer/Orbs/Orb3.get_child(0))

func showOrb(orb):
    # print(orb.orbName)
    $VBoxContainer/ColorRect/Name.text = orb.orbName
    selectedOrb = orb.orbName

func changePrompt(prompt: String):
    $VBoxContainer/Prompt.text = prompt

func _on_Button_pressed():
    if selectedOrb != "" and selectedOrb != null:
        emit_signal("orbSelected", selectedOrb)

func _on_Button2_pressed():
    emit_signal("cancel")
