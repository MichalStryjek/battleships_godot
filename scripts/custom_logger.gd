class_name logger_tool
extends Node

var log_level : int

func assign_log_level(lvl: int):
	log_level = lvl
	return

var log_source : String

func log10(_object, _text: String = ""):
	if log_level >= 10:
		print("LOG_1: ",log_source," ",_text, " ", _object)
func log20(_object, _text: String = ""):
	if log_level >= 20:
		print("LOG_2: ",log_source," ",_text, " ", _object)
	
func log30(_object, _text: String = ""):
	if log_level >= 30:
		print("LOG_3: ",log_source," ",_text, " ", _object)
	
func log40(_object, _text: String = ""):
	if log_level >= 40:
		print("LOG_4: ",log_source," ",_text, " ", _object)	
	
	
	
	return	
