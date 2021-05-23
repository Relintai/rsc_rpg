extends Node2D

# Copyright (c) 2019 Péter Magyar
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

export(Array, NodePath) var level_paths : Array
var levels : Array
var current_level : int = -1

var _player_file_name : String
var _player : Entity

func _ready():
	for lp in level_paths:
		var l = get_node(lp)
		
		if l.visible:
			l.hide()
			
		levels.append(l)
		
func _unhandled_key_input(event):
	if event.scancode == KEY_M and event.pressed:
		var l : int = current_level + 1

		if l >= levels.size():
			l = 0
		
		switch_to_level(l)


func switch_to_level(level_index : int):
	_player.get_body().hide()
	
	if current_level != -1:
		levels[current_level].hide()
		
	current_level = level_index
	
	levels[current_level].show()
	
	if _player.get_parent():
		_player.get_parent().place_player(null)
		_player.get_parent().remove_child(_player)
	
	levels[current_level].add_child(_player)
	levels[current_level].place_player(_player)
#	_player.get_body().world = levels[current_level]
	_player.get_body().show()


func load_character(file_name: String) -> void:
	_player_file_name = file_name
	_player = ESS.entity_spawner.load_player(file_name, Vector3(5, 5, 0), 1) as Entity
	_player.get_body().hide()
	
	Server.sset_seed(_player.sseed)
	
	call_deferred("switch_to_level", 0)

func save() -> void:
	if _player == null or _player_file_name == "":
		return

	ESS.entity_spawner.save_player(_player, _player_file_name)

func place_player(player: Entity) -> void:
	return
