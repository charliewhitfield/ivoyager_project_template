# gui_parent.gd
# This file is part of I, Voyager (https://ivoyager.dev)
# *****************************************************************************
# Copyright (c) 2017-2020 Charlie Whitfield
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************************
# This node is parent to our game template gui panels. You most likely want
# to replace these entirely with your own GUI. But see code and comments for
# how to interface with I, Voyager core systems and GUI widgets.

extends Control
class_name GUIParent

# SCENE path must be defined below for our ProjectBuilder to add it.
const SCENE := "res://replace_me/example_gui/gui_parent.tscn"

# A SelectionManager instance manages our current selection. To find this
# instanace, various GUI widgets search up their ancestor tree for the first
# node that has a "selection_manager" member.
var selection_manager: SelectionManager

onready var _SelectionManager_: Script = Global.script_classes._SelectionManager_

# This node has an object we want to persist through game save/loads. Presence
# of the first constant below tells SaverLoader that this node has something to
# save ("= false" because this node is added by ProjectBuilder, not
# procedurally). The second constant tells SaverLoader what to persist.
const PERSIST_AS_PROCEDURAL_OBJECT := false
const PERSIST_OBJ_PROPERTIES := ["selection_manager"]

# All objects added by ProjectBuilder need a "project_init" function.
func project_init() -> void:
	Global.connect("project_builder_finished", self, "_on_project_builder_finished")
	Global.connect("system_tree_built_or_loaded", self, "_on_system_tree_built_or_loaded")
	Global.connect("simulator_exited", self, "_on_simulator_exited")
	hide()

func _on_project_builder_finished() -> void:
	# We hook up to a theme managed by ThemeManager so that fonts can resize if
	# user changes GUI size in options
	theme = Global.themes.main

func _on_system_tree_built_or_loaded(is_new_game: bool) -> void:
	if !is_new_game:
		return
	selection_manager = _SelectionManager_.new()
	show()

func _on_simulator_exited() -> void:
	hide()
