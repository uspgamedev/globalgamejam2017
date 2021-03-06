
extends Node

const DIR = preload("res://utility/directions.gd")
const ACT = preload("res://utility/actions.gd")

signal hold_direction (dir)
signal hold_action (act)
signal press_direction (dir)
signal press_action (act)
signal press_quit

func _ready():
    set_process(true)
    set_process_input(true)

func _input(event):
    var dir = self._get_direction(event)
    var act = self._get_action(event)
    if dir != -1: emit_signal("press_direction", dir)
    if act != ACT.NONE: emit_signal("press_action", act)
    if _get_quit(event): emit_signal("press_quit")

func _process(delta):
    var dir = self._get_direction(Input)
    var act = self._get_action(Input)
    if dir != -1: emit_signal("hold_direction", dir)
    if act != ACT.NONE: emit_signal("hold_action", act)

func _get_quit(e):
    if e.is_action_pressed("ui_quit"):
        return true

func _get_action(e):
    var act = ACT.NONE
    if e.is_action_pressed("ui_accept"):
        act = ACT.ACCEPT
    elif e.is_action_pressed("ui_cancel"):
        act = ACT.CANCEL
    elif e.is_action_pressed("game_dash"):
        act = ACT.DASH
    elif e.is_action_pressed("game_interact"):
        act = ACT.INTERACT
    elif e.is_action_pressed("game_panic"):
        act = ACT.PANIC
    return act

func _get_direction(e):
    var dir = -1
    if e.is_action_pressed("ui_up") and not e.is_action_pressed("ui_down") \
        and not e.is_action_pressed("ui_left") and not e.is_action_pressed("ui_right"):
        dir = DIR.UP
    elif e.is_action_pressed("ui_down") and not e.is_action_pressed("ui_up") \
        and not e.is_action_pressed("ui_left") and not e.is_action_pressed("ui_right"):
        dir = DIR.DOWN
    if e.is_action_pressed("ui_right") and not e.is_action_pressed("ui_left") \
        and not e.is_action_pressed("ui_down") and not e.is_action_pressed("ui_up"):
        dir = DIR.RIGHT
    elif e.is_action_pressed("ui_left") and not e.is_action_pressed("ui_right") \
        and not e.is_action_pressed("ui_down") and not e.is_action_pressed("ui_up"):
        dir = DIR.LEFT
    if e.is_action_pressed("ui_up") and e.is_action_pressed("ui_right") \
        and not e.is_action_pressed("ui_down") and not e.is_action_pressed("ui_left"):
        dir = DIR.UP_RIGHT
    elif e.is_action_pressed("ui_down") and e.is_action_pressed("ui_left") \
        and not e.is_action_pressed("ui_up") and not e.is_action_pressed("ui_right"):
        dir = DIR.DOWN_LEFT
    if e.is_action_pressed("ui_down") and e.is_action_pressed("ui_right") \
        and not e.is_action_pressed("ui_up") and not e.is_action_pressed("ui_left"):
        dir = DIR.DOWN_RIGHT
    elif e.is_action_pressed("ui_up") and e.is_action_pressed("ui_left") \
        and not e.is_action_pressed("ui_down") and not e.is_action_pressed("ui_right"):
        dir = DIR.UP_LEFT
    return dir
