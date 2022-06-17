extends Sprite
class_name Orb


var bulletMovement = "Linear"
var bulletsPerShot = 1
var spreadAngle = 0
var spreadDistribution  = "Random"
var damagePerBullet = 1.5
var bulletSpeed = 10.0
var pierce = 0
var bulletLifetime = 10.0
var reloadTime = 0.7
var timeSinceShot = 1.0
var bulletTexture = load("res://Assets/Character/Character_Orb/character_orb.png")
var numberOfJumps = 2
var jumpReload = 0.5

var finalReloadTime = reloadTime

# TODO
# var passive = false
var fireRateBonus = 0
var damageBonus = 0
var speedBonus = 0
var pierceBonus = 0
var spreadBonus = 0

var fireBonus = 0
var iceBonus = 0

var shootRotationMultiplier: float
var bulletParent_: Node
var player_: Node
var selected = false
var duplicate: Sprite
var equipped = false

var stepRotation = 1*2*3.14/180

onready var orbs = Data.orbs

func _init(orbName: String, bulletsParent: Node, player: Node):
    visible = false
    if Data.orbs[orbName]["passive"]:
        if "fireRateBonus" in Data.orbs[orbName]:
            fireRateBonus = Data.orbs[orbName]["fireRateBonus"]
        if "damageBonus" in Data.orbs[orbName]:
            damageBonus = Data.orbs[orbName]["damageBonus"]
    else:
        self.bulletMovement = Data.orbs[orbName]["bulletMovement"]
        self.bulletsPerShot = Data.orbs[orbName]["bulletsPerShot"]
        self.spreadAngle = Data.orbs[orbName]["spreadAngle"]
        self.spreadDistribution = Data.orbs[orbName]["spreadDistribution"]
        self.damagePerBullet = Data.orbs[orbName]["damagePerBullet"]
        self.bulletSpeed = Data.orbs[orbName]["bulletSpeed"]
        self.pierce = Data.orbs[orbName]["pierce"]
        self.bulletLifetime = Data.orbs[orbName]["bulletLifetime"]
        self.reloadTime = Data.orbs[orbName]["reloadTime"]
        self.bulletTexture = Data.orbs[orbName]["bulletTexture"]
        self.numberOfJumps = Data.orbs[orbName]["numberOfJumps"]
        self.jumpReload = Data.orbs[orbName]["jumpReload"]
        self.shootRotationMultiplier = Data.orbs[orbName]["shootRotationMultiplier"]
        self.timeSinceShot = self.reloadTime
    self.player_ = player
    self.bulletParent_ = bulletsParent

    texture = load("res://.import/Orb_Base.png-0279880cacbbd258f1af6653654c34fd.stex")
    self_modulate = Color(1, 1, 1, 62.0/255.0)
    player.add_child(self)
    var coloring = Sprite.new()
    coloring.texture = texture
    coloring.self_modulate = Data.orbs[orbName]["color"] #Color(1, 1, 0, 1)
    add_child(coloring)
    # scale = Vector2(3, 3)

    duplicate = Sprite.new()
    duplicate.texture = texture
    duplicate.self_modulate = Color(1, 1, 1, 62.0/255.0)
    var coloring2 = Sprite.new()
    coloring2.texture = texture
    coloring2.self_modulate =  Data.orbs[orbName]["color"]
    coloring2.centered = false
    duplicate.add_child(coloring2)
    duplicate.centered = false
    var gui = player.get_parent().get_node("GUI")
    var orbsGUI = gui.get_node("Inventory/Orbs")
    var duplicateHolder = Control.new()
    duplicateHolder.rect_min_size = Vector2(texture.get_width(), texture.get_height())
    duplicateHolder.add_child(duplicate)
    # duplicateHolder.hide()
    orbsGUI.add_child(duplicateHolder)
    duplicate.scale = scale
    # orbsGUI.add_child(duplicate)

    var hitbox = Area2D.new()
    hitbox.collision_mask = 2
    var collisionShape = CollisionShape2D.new()
    collisionShape.shape = CircleShape2D.new()
    collisionShape.shape.radius = texture.get_width() / 2.0
    hitbox.add_child(collisionShape)
    self.add_child(hitbox)
    hitbox.connect("area_entered", self, "on_area_entered")
    add_child(hitbox)


func shoot():
    if self.timeSinceShot >= finalReloadTime:
        self.timeSinceShot = 0
        # static func shoot(parent: Node, position: Vector2, direction: Vector2, bulletMovement: String, bulletsPerShot: int, spreadAngle: float, spreadDistribution: String, damagePerBullet: int, bulletSpeed: float, pierce: int, bulletLifetime: float):
        
        var direction = (player_.get_viewport().get_mouse_position() ) - player_.position
        direction = direction.normalized()
        BulletAttack.shoot(self.bulletParent_, self.player_.position, direction, self.bulletMovement, self.bulletsPerShot, self.spreadAngle, self.spreadDistribution, self.damagePerBullet*(1+player_.damageBonus), self.bulletSpeed, self.pierce, self.bulletLifetime)
        # rotate(shootRotationMultiplier*stepRotation)
        rotate(-60*stepRotation)

func shootDirection(direction: Vector2):
    if self.timeSinceShot >= finalReloadTime:
        self.timeSinceShot = 0
        BulletAttack.shoot(self.bulletParent_, self.player_.position, direction, self.bulletMovement, self.bulletsPerShot, self.spreadAngle, self.spreadDistribution, self.damagePerBullet*(1+player_.damageBonus), self.bulletSpeed, self.pierce, self.bulletLifetime)

func deselect():
    # player_.remove_child(self)
    selected = false
    visible = false
    pass

func select():
    # player_.add_child(self)
    selected = true
    visible = true
    pass

func addBonus():
    player_.fireRateBonus += fireRateBonus
    player_.damageBonus += damageBonus

func removeBonus():
    player_.fireRateBonus -= fireRateBonus
    player_.damageBonus -= damageBonus

func equip():
    duplicate.get_parent().visible = true
    addBonus()

func unequip():
    duplicate.get_parent().visible = false
    removeBonus()

func _process(delta):
    rotate(stepRotation)
    timeSinceShot += delta
    finalReloadTime = reloadTime/(1+player_.fireRateBonus)
    if selected:
        if timeSinceShot < finalReloadTime:
            player_.get_node("ReloadBar").visible = true
            player_.get_node("ReloadBar/Progress").rect_size.x = min(40, 40*timeSinceShot / finalReloadTime)
        else:
            player_.get_node("ReloadBar").visible = false

func on_area_entered(area: Area2D):
    print(area.get_parent())
    # restart scene
    if area.get_parent().is_in_group("enemies"):
        get_tree().reload_current_scene()
