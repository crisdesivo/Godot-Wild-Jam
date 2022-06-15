extends Sprite

class_name Bullet

var initialPosition: Vector2
var velocity: Vector2
var direction: Vector2
var timeAlive = 0
var lifetime: float
var damage: float
var initialSpeed: float
var length: int
var width: int
var movementType: String
var pierce: int
var pierced = -1
var gravityMagnitude = 20


func _init(position_: Vector2, direction_: Vector2, speed_: float, lifetime_: float, damage_: float, movementType_: String, pierce_: int):
    name = "bullet"
    add_to_group("bullets")
    self.position = position_
    self.initialPosition = position_
    velocity = direction_ * speed_
    self.direction = direction_
    self.lifetime = lifetime_
    self.damage = damage_
    self.initialSpeed = speed_
    self.movementType = movementType_
    self.pierce = pierce_

    var rigidBody = Area2D.new()
    var collisionShape = CollisionShape2D.new()
    collisionShape.shape = CircleShape2D.new()
    rigidBody.add_child(collisionShape)
    rigidBody.collision_layer = 1
    rigidBody.collision_mask = 2
    add_child(rigidBody)

    texture = load("res://Assets/orb1.png")
    collisionShape.shape.radius = texture.get_size().x / 2
    scale = Vector2(0.05, 0.05)



# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _process(delta):
    timeAlive += delta
    if movementType == 'Gravity':
        velocity.y += delta * gravityMagnitude
    if movementType == 'Inverse gravity':
        velocity.y += delta * -gravityMagnitude
    if movementType == 'Back gravity':
        # add gravity in the opposite direction of the bullet
        velocity += delta * -9.8 * 0.01 * direction

    if movementType == 'Spiral':
        var angle = timeAlive * 10
        var radious = timeAlive * 100 + 100
        position = initialPosition + Vector2(radious * cos(angle), radious * sin(angle))
    else:
        translate(100*velocity * delta)
    
    if timeAlive > lifetime:
        queue_free()

func hit(enemy: Enemy):
    enemy.takeDamage(damage)
    # enemy.currentHP -= damage
    pierced += 1
    if pierced >= pierce:
        queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
