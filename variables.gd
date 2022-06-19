extends Node

var maxScore = 0
var lastScore = 0

var initialOrbs = ["Shockwave Orb", "Orb of Power", "Orb of Rapid Fire"]

func _ready():
    var file = File.new()

    if file.file_exists("user://MaxScore.save"):
        file.open("user://MaxScore.save", File.READ)
        maxScore = file.get_var()
    file.close()