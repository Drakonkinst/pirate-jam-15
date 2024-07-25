extends Node2D

class_name FruitHarvestPoint

var has_fruit: bool = false

func grow_fruit():
    show()
    has_fruit = true

func hide_fruit():
    hide()
    has_fruit = false