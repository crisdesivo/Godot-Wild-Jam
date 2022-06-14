class_name Orb

var bulletMovement: String
var bulletsPerShot: int
var spreadAngle: float
var spreadDistribution: String
var damagePerBullet: int
var bulletSpeed: float
var pierce: int
var bulletLifetime: float
var reloadTime: float
var timeSinceShot: float
var bulletTexture: Texture
var numberOfJumps: int
var jumpReload: float
var shootRotationMultiplier: float
var bulletParent_: Node
var player_: Node

var orbs = {
    # "Linear", 5, 45, "Equidistant", 1, 10, 0, 0.5
    "Fan": {
        "bulletMovement": "Linear",
        "bulletsPerShot": 5,
        "spreadAngle": 45,
        "spreadDistribution": "Equidistant",
        "damagePerBullet": 1,
        "bulletSpeed": 10,
        "pierce": 0,
        "bulletLifetime": 0.5,
        "reloadTime": 1,
        "bulletTexture": load("res://Assets/orb1.png"),
        "numberOfJumps": -1,
        "jumpReload": 0.5,
        "shootRotationMultiplier": -15
    }

}

func _init(orbName: String, bulletsParent: Node, player: Node):
    self.bulletMovement = orbs[orbName]["bulletMovement"]
    self.bulletsPerShot = orbs[orbName]["bulletsPerShot"]
    self.spreadAngle = orbs[orbName]["spreadAngle"]
    self.spreadDistribution = orbs[orbName]["spreadDistribution"]
    self.damagePerBullet = orbs[orbName]["damagePerBullet"]
    self.bulletSpeed = orbs[orbName]["bulletSpeed"]
    self.pierce = orbs[orbName]["pierce"]
    self.bulletLifetime = orbs[orbName]["bulletLifetime"]
    self.reloadTime = orbs[orbName]["reloadTime"]
    self.bulletTexture = orbs[orbName]["bulletTexture"]
    self.numberOfJumps = orbs[orbName]["numberOfJumps"]
    self.jumpReload = orbs[orbName]["jumpReload"]
    self.shootRotationMultiplier = orbs[orbName]["shootRotationMultiplier"]
    self.bulletParent_ = bulletsParent
    self.timeSinceShot = self.reloadTime
    self.player_ = player

func shoot():
    if self.timeSinceShot >= self.reloadTime:
        self.timeSinceShot = 0
        # static func shoot(parent: Node, position: Vector2, direction: Vector2, bulletMovement: String, bulletsPerShot: int, spreadAngle: float, spreadDistribution: String, damagePerBullet: int, bulletSpeed: float, pierce: int, bulletLifetime: float):
        
        var direction = (player_.get_viewport().get_mouse_position() ) - self.position
        direction = direction.normalized()
        BulletAttack.shoot(self.bulletParent_, self.player_.position, direction, self.bulletMovement, self.bulletsPerShot, self.spreadAngle, self.spreadDistribution, self.damagePerBullet, self.bulletSpeed, self.pierce, self.bulletLifetime)