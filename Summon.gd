extends Sprite

class_name Summon

var speed: float
var cspeed: float
var movementType: String
var velocity: Vector2
var timeSinceShot = 110.0
var reloadTime: float
var lifeTime: float
var timeAlive = 0

func _init(speed_: float, texture_: Texture, scale_: float, movementType_: String):
    name = "summon"
    centered = true
    add_to_group("ally")
    self.speed = speed_
    self.reloadTime = 0.5
    self.movementType = movementType_
    self.texture = texture_
    # scale = Vector2(0.2, 0.2)
    self.lifeTime = 10

    scale = Vector2(scale_, scale_)
    # if movementType == "attracted":
    velocity = Vector2(speed*2, 0)

func shoot():
    if timeSinceShot >= reloadTime:
        timeSinceShot = 0.0
        var direction = Vector2(0, 1)
        # direction = direction.normalized()
        BulletAttack.shoot(get_parent(), position, direction, "Gravity", 1, 180, "Random", 0.1, 2, 0, 10, "res://Assets/bullet.png", false)
        # var bullet = Bullet.new(position, direction, 2, 20, 1, "Gravity", 0, "res://Assets/bullet.png", false)
        # get_parent().add_child(bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    timeSinceShot += delta
    timeAlive += delta
    cspeed = min(speed, cspeed + 4*delta)

    if position.x > 1200:
        velocity.x = -1*speed*delta*100
    elif position.x < 0:
        velocity.x = 1*speed*delta*100
    # else:
    #     velocity.x = 1*speed*delta*100
    if position.y > 20:
        velocity.y = -1*speed*delta*100
    else:
        velocity.y = 0
    translate(velocity)
    shoot()
    # print(position)

    if timeAlive > lifeTime:
        queue_free()
