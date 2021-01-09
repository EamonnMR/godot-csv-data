# Basic use: Inherit from DataRow to make a class for your row, add type hints for any variables that appear in the CSV, make your CSV file,
# simlink it to .csv.txt to make export work, use DataRow.load_csv to load the CSV into dictionaries, then pass each dictionary into your class
# like YourClass.new(dict) to instantiate a row object.


class_name DataRow

func init(data: Dictionary):
	var props = get_property_list()
	for prop in props:
		var prop_name = prop["name"]
		if prop_name in data:
			var type: int = prop["type"]
			var string_val = data[prop_name]
			set(prop_name, convert_column_value(
				data[prop_name],
				prop["type"],
				prop["class_name"]
			))

func convert_column_value(string_val: String, type: int, type_class: String):
	if type == TYPE_INT:
		return int(string_val)
	elif type == TYPE_BOOL:
		return parse_bool(string_val)
	elif type == TYPE_REAL:
		return float(string_val)
	elif type == TYPE_STRING:
		return string_val
	elif type == TYPE_OBJECT:
		if type_class in ["PackedScene", "Texture"]:
			return load(string_val)
		elif type_class == "Color":
			return parse_color(string_val)
		# elif type_class == "AudioStream":
		# 	return GdScriptAudioImport.loadfile(string_val)
    # To enable audiostream handling, uncomment and include this project: https://github.com/Gianclgar/GDScriptAudioImport
			
	return null
	
func parse_color(color_text) -> Color:
	"""
	"1 3 4" -> Color(1,3,4)
	"""
	var color_parsed = color_text.split(" ")
	return Color(color_parsed[0], color_parsed[1], color_parsed[2])

func parse_bool(caps_true_or_false: String) -> bool:
	return caps_true_or_false == "TRUE"
	
func parse_x_dict(x_dict: String) -> Dictionary:
	""" Looks like: '1x4 0x3' and translates to:
		{
			"1": 4,
			"0": 3
		}
		
		Useful if you want a compact dictionary representation
	"""
	var dict = {}
	for i in x_dict.split(" "):
		var key_count = i.split("x")
		dict[key_count[0]] = int(key_count[1])
	return dict
	
func parse_int_array(text: String) -> Array:
	var int_array = []
	for i in text.split(" "):
		int_array.append(int(i))
	return int_array

static func load_csv(csv):
	var file = File.new()
	var directory = Directory.new();
	if not directory.file_exists(csv):
		# Simlink *csv.txt this to your *.csv to dodge export badness
		# Windows does not seem to correctly use simlinks, so for windows dev to work, we need to handle both
		csv = csv + ".txt"
	file.open(csv, File.READ)
	var headers = file.get_csv_line()
	var parsed_file = {}
	while true:
		var parsed_line = {}
		var line = file.get_csv_line()
		if line.size() <= 1:
			break
		for column in range(line.size()):
			parsed_line[headers[column]] = line[column]
		parsed_file[line[0]] = parsed_line
	print("Parsed ", csv + ".txt ", "got ", parsed_file.size(), " rows")
	return parsed_file
	
# Copyright (c) 2021, Eamonn McHugh-Roohr
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
