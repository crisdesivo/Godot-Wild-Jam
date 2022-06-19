extends Node2D

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var beetleAsset = load("res://Assets/beetle.png")
var ghostieAsset = load("res://Assets/beetle.png")
var barqueAsset = load("res://Assets/barque.png")
var lastSummon = 100.0
var summonDelay = 1.0
var elapsed_time = 0.0
var difficulty = 0.0

var enemies = {
    "beetle": {
        "texture": beetleAsset,
        "speed": 0.7,
        "hp": 5,
        "scale": 3,
        "rotate": true,
        "flip": false,
        "movement": "attracted",
        "shooter": false,
        "orbName": "Orb of Power"
    },
    "ghostie": {
        "texture": ghostieAsset,
        "speed": 2,
        "hp": 3,
        "scale": 1.5,
        "rotate": true,
        "flip": false,
        "movement": "homing",
        "shooter": false,
        "orbName": "Orb of Power"
    },
    "barque": {
        "texture": barqueAsset,
        "speed": 0.5,
        "hp": 2,
        "scale": 1,
        "rotate": false,
        "flip": false,
        "movement": "attracted",
        "shooter": true,
        "orbName": "Crossbow Orb"
    }
}

var enemyWaves = [
    {
        "delay": 2.0,
        "enemies": {
            "beetle": 10
        },
        "difficulty": 0
    },
    {
        "delay": 3.0,
        "enemies": {"ghostie" : 3},
        "difficulty": 0.1
    },
    {
        "delay": 2,
        "enemies": {
            "barque": 5
        },
        "difficulty": 0.2
    },
    {
        "delay": 1.0,
        "enemies": {
            "beetle": 100,
            "ghostie": 50
        },
        "difficulty": 2
    },
]


func _ready():
    rng.randomize()
    randomize()
    for wave in enemyWaves:
        wave["lastSpawning"] = wave["delay"]
        if not "speedBonus" in wave:
            wave["speedBonus"] = 0.0
    
    while true:
        var appropiateWaves = []
        for wave in enemyWaves:
            if wave["difficulty"] <= difficulty:
                appropiateWaves.append(wave)
        var index = rng.randi() % len(appropiateWaves)
        var wave = appropiateWaves[index]
    # for wave in enemyWaves:
        yield(spawnWave(wave), "completed")
        yield(get_tree().create_timer(2, true), "timeout")
        difficulty += 1.0

# func _process(delta):
#     if len(enemyWaves) == 0:
#         lastSummon += delta
#         if lastSummon >= summonDelay:
#             lastSummon = 0.0
#             spawnFromWave({
#                 "start": 0,
#                 "amount": 1,
#                 "delay": 0.0,
#                 "enemy": "beetle",
#                 "speedBonus": elapsed_time/100.0
#             })
#             # spawnBeetle()
#     elapsed_time += delta
#     var removeWaves = []
#     var i = 0
#     while i < len(enemyWaves):
#         var wave = enemyWaves[i]
#         wave["lastSpawning"] += delta
#         if wave["start"] <= elapsed_time and wave["lastSpawning"] >= wave["delay"]:
#             wave["lastSpawning"] = 0.0
#             wave["amount"] -= 1
#             if wave["amount"] <= 0:
#                 removeWaves.append(i)

#             spawnFromWave(wave)
#         i += 1
#     for index in removeWaves:
#         enemyWaves.remove(index)

func spawnEnemy(enemyName):
    var enemy = Enemy.new(enemies[enemyName]["hp"], enemies[enemyName]["speed"], true, enemies[enemyName]["texture"], enemies[enemyName]["scale"], enemies[enemyName]["rotate"], enemies[enemyName]["flip"], enemies[enemyName]["movement"], enemies[enemyName]["shooter"], enemies[enemyName]["orbName"])
    var location = rng.randi_range(0, 3)
    if location == 0:
        enemy.position = Vector2(rng.randi_range(0, int(get_viewport_rect().size.x)), 0)
    elif location == 1:
        enemy.position = Vector2(rng.randi_range(0, int(get_viewport_rect().size.x)), int(get_viewport_rect().size.y))
    elif location == 2:
        enemy.position = Vector2(0, rng.randi_range(0, int(get_viewport_rect().size.y)))
    elif location == 3:
        enemy.position = Vector2(int(get_viewport_rect().size.x), rng.randi_range(0, int(get_viewport_rect().size.y)))
    add_child(enemy)


func spawnWave(wave):
    var delay = wave["delay"]/(1+difficulty*0.1)
    var enemies_ = wave["enemies"].duplicate()
    var totalAmount = 0
    for enemy in enemies_:
        totalAmount += wave["enemies"][enemy]

    var i = 0
    while i < totalAmount:
        var enemyIndex = rng.randi_range(0, len(enemies_)-1)
        var enemy = enemies_.keys()[enemyIndex]
        enemies_[enemy] -= 1
        if wave["enemies"][enemy] <= 0:
            enemies_.erase(enemy)
            
        spawnEnemy(enemy)
        yield(get_tree().create_timer(delay, true), "timeout")
        i+=1
    yield(get_tree(), "idle_frame")
    # emit_signal("finished")
    
# func spawnGhost():
#     var ghost = Enemy.new(5, 0.7, true, load("res://Assets/ghostie.png"), 0.2)
#     # var ghost = Enemy.new(10, 2, true, load("res://Assets/spot.png"))
#     # ghost.visible = true
#     var location = rng.randi_range(0, 3)
#     if location == 0:
#         ghost.position = Vector2(rng.randi_range(0, int(get_viewport_rect().size.x)), 0)
#     elif location == 1:
#         ghost.position = Vector2(rng.randi_range(0, int(get_viewport_rect().size.x)), int(get_viewport_rect().size.y))
#     elif location == 2:
#         ghost.position = Vector2(0, rng.randi_range(0, int(get_viewport_rect().size.y)))
#     elif location == 3:
#         ghost.position = Vector2(int(get_viewport_rect().size.x), rng.randi_range(0, int(get_viewport_rect().size.y)))
#     # ghost.position = Vector2(get_viewport_rect().size.x, location)
#     add_child(ghost)
# # Called every frame. 'delta' is the elapsed time since the previous frame.
# # func _process(delta):
# #    pass

# func spawnBeetle():
#     var beetle = Enemy.new(5, 0.7, true, beetleAsset, 2)
#     var location = rng.randi_range(0, 3)
#     if location == 0:
#         beetle.position = Vector2(rng.randi_range(0, int(get_viewport_rect().size.x)), 0)
#     elif location == 1:
#         beetle.position = Vector2(rng.randi_range(0, int(get_viewport_rect().size.x)), int(get_viewport_rect().size.y))
#     elif location == 2:
#         beetle.position = Vector2(0, rng.randi_range(0, int(get_viewport_rect().size.y)))
#     elif location == 3:
#         beetle.position = Vector2(int(get_viewport_rect().size.x), rng.randi_range(0, int(get_viewport_rect().size.y)))
#     add_child(beetle)

func spawnFromWave(wave):
    var enemy = Enemy.new(enemies[wave["enemy"]]["hp"], enemies[wave["enemy"]]["speed"]*(1.0+wave["speedBonus"]), true, enemies[wave["enemy"]]["texture"], enemies[wave["enemy"]]["scale"], enemies[wave["enemy"]]["rotate"], enemies[wave["enemy"]]["flip"], enemies[wave["enemy"]]["movement"])
    var location = rng.randi_range(0, 3)
    if location == 0:
        enemy.position = Vector2(rng.randi_range(0, int(get_viewport_rect().size.x)), 0)
    elif location == 1:
        enemy.position = Vector2(rng.randi_range(0, int(get_viewport_rect().size.x)), int(get_viewport_rect().size.y))
    elif location == 2:
        enemy.position = Vector2(0, rng.randi_range(0, int(get_viewport_rect().size.y)))
    elif location == 3:
        enemy.position = Vector2(int(get_viewport_rect().size.x), rng.randi_range(0, int(get_viewport_rect().size.y)))
    add_child(enemy)
