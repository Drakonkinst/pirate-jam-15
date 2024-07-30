extends ProjectileBehavior

class_name PotionBehavior

func on_land(pos: Vector2):
    var projectile_manager: ProjectileManager = GlobalVariables.get_projectile_manager()
    projectile_manager.place_explosion(pos).set_color(tint_color)
    projectile_manager.place_splat(pos).set_color(tint_color)
