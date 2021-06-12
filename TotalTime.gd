extends Node


var total_playtime = 0
var level_playtime_minutes=0
var level_playtime_seconds=0
var final_level_playtime
var collectibles = 0

func _process(delta):
	if level_playtime_seconds == 60:
		level_playtime_seconds = 0
		level_playtime_minutes+=1
		
	final_level_playtime = str("0",level_playtime_minutes,":", level_playtime_seconds) if level_playtime_minutes <=10 else str(level_playtime_minutes,": 0", level_playtime_seconds)
	
