extends KinematicBody2D

const Bullet = preload("res://enemies/bullet.gd")

export(int, "Fire", "Ice") var type = 0
export(float) var wave_delay = 4
export(float) var bullet_speed = 50
export(float) var bullet_time = 7
export(int) var bullet_quantity = 120
export(bool) var auto_start = true

onready var timer   = get_node("Timer")
onready var view    = get_node("Sprite")
onready var anim    = get_node("Sprite/AnimationPlayer")
onready var shine   = get_node("shiny")
onready var wavesfx = get_node("WaveSFX")
onready var destroyed = false
onready var counter = 0

var dead_bullets = []
var all_bullets = []

signal destroyed

func _ready():
  timer.set_wait_time(wave_delay)
  if auto_start:
    timer.start()
  set_process(true)

  for bcount in range(bullet_quantity):
    var bullet = Bullet.create()
    bullet.connect("on_death",self,"on_bullet_death")
    dead_bullets.push_back(bullet)
    all_bullets.push_back(bullet)

func start_waves():
  timer.start()

func stop_waves():
  timer.stop()

func fire_wave():
  for bcount in range(bullet_quantity):
    var degree = ( 360.0 / bullet_quantity ) * bcount
    var bullet = null
    if dead_bullets.empty():
      bullet = Bullet.create()
      bullet.connect("on_death",self,"on_bullet_death")
      all_bullets.push_back(bullet)
    else:
      bullet = dead_bullets[-1]
      dead_bullets.pop_back()
    get_parent().add_child(bullet)
    bullet.set_pos(get_pos())
    bullet.setup(false, self, bullet_time, degree, bullet_speed)

func on_bullet_death(bullet):
  get_parent().call_deferred("remove_child",bullet)
  dead_bullets.push_back(bullet)

func kill_all_bullets():
  printt("kill all: size: ", all_bullets.size())
  while all_bullets.size() > 0:
    var bullet = all_bullets[all_bullets.size() - 1]
    if not bullet.died:
      bullet.auto_kill()
    all_bullets.pop_back()

func destroy():
  if not destroyed:
    kill_all_bullets()
    destroyed = true
    timer.disconnect("timeout", self, "_on_Timer_timeout")
    timer.disconnect("timeout", wavesfx, "play")
    timer.stop()
    anim.play("dying")
    emit_signal("destroyed")
    yield(anim, "finished")
    set_layer_mask(0)
    set_collision_mask(0)
    shine.queue_free()
    anim.play("dead")

func _process(delta):
  var left = timer.get_time_left() / timer.get_wait_time()
  if left > 0:
    counter += delta
    var freq = 1.0 - 4 * min(0.25, left)
    freq *= freq
    var osc = 2 * sin(counter * freq * 200)
    view.set_pos(Vector2(osc, 0))
  else:
    counter = 0
    view.set_pos(Vector2(0, 0))
