extends Node

var orbs = {
    # "Linear", 5, 45, "Equidistant", 1, 10, 0, 0.5
    "Fan Orb": {
        "passive": false,
        "bulletMovement": "Linear",
        "bulletsPerShot": 5,
        "spreadAngle": 45,
        "spreadDistribution": "Equidistant",
        "damagePerBullet": 1,
        "bulletSpeed": 10,
        "pierce": 0,
        "bulletLifetime": 0.5,
        "reloadTime": 1,
        "bulletTexture": "res://Assets/orb1.png",
        "numberOfJumps": -1,
        "jumpReload": 0.5,
        "shootRotationMultiplier": -15,
        "color": Color(0.5, 0.5, 0.5),
        "description": "A basic orb that does damage to enemies in the shape of a fan."
    },
    "Water Gun Orb": {
        "passive": false,
        "bulletMovement": "Gravity",
        "bulletsPerShot": 1,
        "spreadAngle": 45,
        "spreadDistribution": "Random",
        "damagePerBullet": 0.5,
        "bulletSpeed": 7,
        "pierce": 0,
        "bulletLifetime": 1.5,
        "reloadTime": 0.05,
        "bulletTexture": "res://Assets/orb1.png",
        "numberOfJumps": -1,
        "jumpReload": 0.5,
        "shootRotationMultiplier": -15,
        "color": Color(0, 0.5, 1),
        "description": "Attacks with pressurised water."
    },
    "Crossbow Orb": {
        "passive": false,
        "bulletMovement": "Linear",
        "bulletsPerShot": 1,
        "spreadAngle": 0,
        "spreadDistribution": "Equidistant",
        "damagePerBullet": 10,
        "bulletSpeed": 12,
        "pierce": 5,
        "bulletLifetime": 0.5,
        "reloadTime": 2,
        "bulletTexture": "res://Assets/orb1.png",
        "numberOfJumps": -1,
        "jumpReload": 0.5,
        "shootRotationMultiplier": -15,
        "color": Color(0.7, 0, 0),
        "description": "Shoots in a straight line, high damage and pierce, low reload rate."
    },
    "Orb of Rapid Fire": {
        "passive": true,
        "fireRateBonus": 0.25,
        "bulletTexture": "res://Assets/orb1.png",
        "numberOfJumps": -1,
        "jumpReload": 0.5,
        "shootRotationMultiplier": -15,
        "color": Color(0.7, 0.3, 0.1),
        "description": "Passive orb. Increases fire rate of all your orbs."
    },
    "Orb of Power": {
        "passive": true,
        "damageBonus": 0.25,
        "bulletTexture": "res://Assets/orb1.png",
        "numberOfJumps": -1,
        "jumpReload": 0.5,
        "shootRotationMultiplier": -15,
        "color": Color(0.3, 0.35, 0.4),
        "description": "Passive orb. Increases damage of all your orbs."
    }
}
