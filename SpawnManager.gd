extends Node2D

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var beetleAsset = load("res://Assets/beetle.png")
var ghostieAsset = load("res://Assets/ghostie.png")
var lastSummon = 100.0
var summonDelay = 1.0
var elapsed_time = 0.0

var enemies = {
    "beetle": {
        "texture": beetleAsset,
        "speed": 0.7,
        "hp": 5,
        "scale": 2,
        "rotate": true,
        "flip": false
    },
    "ghostie": {
        "texture": ghostieAsset,
        "speed": 2,
        "hp": 3,
        "scale": 0.2,
        "rotate": false,
        "flip": true
    }
}

var enemyWaves = [
    {
        "start": 0,
        "amount": 10,
        "delay": 1.0,
        "enemy": "beetle",
    },
    {
        "start": 15,
        "amount": 3,
        "delay": 3.0,
        "enemy": "ghostie",
    },
    {
        "start": 20,
        "amount": 100,
        "delay": 1.0,
        "enemy": "beetle",
    },
    {
        "start": 20,
        "amount": 50,
        "delay": 10.0,
        "enemy": "ghostie",
        "speedBonus": 0.5
    }
]

func _ready():
    for wave in enemyWaves:
        wave["lastSpawning"] = wave["delay"]
        if not "speedBonus" in wave:
            wave["speedBonus"] = 0.0
    enemyWaves = [] # TODO REMOVE

func _process(delta):
    if len(enemyWaves) == 0:
        lastSummon += delta
        if lastSummon >= summonDelay:
            lastSummon = 0.0
            spawnFromWave({
                "start": 0,
                "amount": 1,
                "delay": 0.0,
                "enemy": "beetle",
                "speedBonus": elapsed_time/100.0
            })
            # spawnBeetle()
    elapsed_time += delta
    var removeWaves = []
    var i = 0
    while i < len(enemyWaves):
        var wave = enemyWaves[i]
        wave["lastSpawning"] += delta
        if wave["start"] <= elapsed_time and wave["lastSpawning"] >= wave["delay"]:
            wave["lastSpawning"] = 0.0
            wave["amount"] -= 1
            if wave["amount"] <= 0:
                removeWaves.append(i)

            spawnFromWave(wave)
        i += 1
    for index in removeWaves:
        enemyWaves.remove(index)


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
    var enemy = Enemy.new(enemies[wave["enemy"]]["hp"], enemies[wave["enemy"]]["speed"]*(1.0+wave["speedBonus"]), true, enemies[wave["enemy"]]["texture"], enemies[wave["enemy"]]["scale"], enemies[wave["enemy"]]["rotate"], enemies[wave["enemy"]]["flip"])
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
