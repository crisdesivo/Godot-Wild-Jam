extends Sprite
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

var stepRotation = 1*2*3.14/180
# var shootRotationMultiplier = -15

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
    },
    "Water Gun": {
        "bulletMovement": "Gravity",
        "bulletsPerShot": 1,
        "spreadAngle": 25,
        "spreadDistribution": "Random",
        "damagePerBullet": 1,
        "bulletSpeed": 7,
        "pierce": 0,
        "bulletLifetime": 1.5,
        "reloadTime": 0.1,
        "bulletTexture": load("res://Assets/orb1.png"),
        "numberOfJumps": -1,
        "jumpReload": 0.5,
        "shootRotationMultiplier": -15
    },
    "Crossbow": {
        "bulletMovement": "Linear",
        "bulletsPerShot": 1,
        "spreadAngle": 0,
        "spreadDistribution": "Equidistant",
        "damagePerBullet": 10,
        "bulletSpeed": 12,
        "pierce": 5,
        "bulletLifetime": 0.5,
        "reloadTime": 2,
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

    texture = load("res://.import/Orb_Base.png-0279880cacbbd258f1af6653654c34fd.stex")
    self_modulate = Color(1, 1, 1, 62.0/255.0)
    player.add_child(self)
    var coloring = Sprite.new()
    coloring.texture = texture
    coloring.self_modulate = Color(1, 1, 0, 1)
    add_child(coloring)

    var hitbox = Area2D.new()
    var collisionShape = CollisionShape2D.new()
    collisionShape.shape = CircleShape2D.new()
    collisionShape.shape.radius = texture.get_width() / 2.0
    hitbox.add_child(collisionShape)
    self.add_child(hitbox)
    hitbox.connect("area_entered", self, "on_area_entered")
    add_child(hitbox)


func shoot():
    if self.timeSinceShot >= self.reloadTime:
        self.timeSinceShot = 0
        # static func shoot(parent: Node, position: Vector2, direction: Vector2, bulletMovement: String, bulletsPerShot: int, spreadAngle: float, spreadDistribution: String, damagePerBullet: int, bulletSpeed: float, pierce: int, bulletLifetime: float):
        
        var direction = (player_.get_viewport().get_mouse_position() ) - player_.position
        direction = direction.normalized()
        BulletAttack.shoot(self.bulletParent_, self.player_.position, direction, self.bulletMovement, self.bulletsPerShot, self.spreadAngle, self.spreadDistribution, self.damagePerBullet, self.bulletSpeed, self.pierce, self.bulletLifetime)
        rotate(shootRotationMultiplier*stepRotation)

func shootDirection(direction: Vector2):
    if self.timeSinceShot >= self.reloadTime:
        self.timeSinceShot = 0
        BulletAttack.shoot(self.bulletParent_, self.player_.position, direction, self.bulletMovement, self.bulletsPerShot, self.spreadAngle, self.spreadDistribution, self.damagePerBullet, self.bulletSpeed, self.pierce, self.bulletLifetime)

func _process(delta):
    rotate(stepRotation)
    timeSinceShot += delta
    if timeSinceShot < reloadTime:
        player_.get_node("ReloadBar").visible = true
        player_.get_node("ReloadBar/Progress").rect_size.x = min(40, 40*timeSinceShot / reloadTime)
    else:
        player_.get_node("ReloadBar").visible = false
func on_area_entered(area: Area2D):
    print(area.get_parent())
    # restart scene
    if area.get_parent().is_in_group("enemies"):
        get_tree().reload_current_scene()
