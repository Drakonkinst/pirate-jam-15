extends Resource

class_name TransmutableEntry

enum Type {
    NONE, TREE, ROCK, TORCH, OIL_SPILL, SAPLING
}

@export var state: Obstacle.TransmutedState
@export var texture: Texture