class_name BulletAttack

static func angle2radian(angle: float):
    return angle * PI / 180

static func shoot(parent: Node, position: Vector2, direction: Vector2, bulletMovement: String, bulletsPerShot: int, spreadAngle: float, spreadDistribution: String, damagePerBullet: float, bulletSpeed: float, pierce: int, bulletLifetime: float, bulletTexture, enemy=false):
    # bullet.new(position_: Vector2, direction_: Vector2, speed_: float, lifetime_: float, damage_: float, movementType_: String, pierce_: int):
    var minAngle = direction.angle() - angle2radian(spreadAngle / 2)
    var maxAngle = direction.angle() + angle2radian(spreadAngle / 2)
    # print(minAngle, maxAngle)
    var i = 0
    while i < bulletsPerShot:
        var angle
        if spreadDistribution == "Equidistant":
            angle = minAngle + (maxAngle - minAngle) * i / (bulletsPerShot)
        elif spreadDistribution == "Random":
            angle = minAngle + (maxAngle - minAngle) * randf()
        else:
            angle = direction.angle()
        var bulletDirection = Vector2(cos(angle), sin(angle))
        var bullet = Bullet.new(position, bulletDirection, bulletSpeed, bulletLifetime, damagePerBullet, bulletMovement, pierce, bulletTexture, enemy)
        parent.add_child(bullet)
        i+=1
    
    # var bullet = Bullet.new(position, direction, bulletSpeed, bulletLifetime, damagePerBullet, bulletMovement, pierce)
    
    # parent.add_child(bullet)
