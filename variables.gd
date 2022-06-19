extends Node

var maxScore = 0
var lastScore = 0

var initialOrbs = ["Rain Summoner Orb", "Crossbow Orb", "Water Gun Orb"]

func _ready():
    var file = File.new()

    if file.file_exists("user://MaxScore.save"):
        file.open("user://MaxScore.save", File.READ)
        maxScore = file.get_var()
    file.close()