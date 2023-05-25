package game


//= Imports
import  "core:fmt"


//= Procedures
check_variable :: proc{
	check_variable_simple,
	check_variable_conditionalevent,
}
check_variable_simple :: proc(
	name : string,
	value : bool,
) -> bool {
	if name != "" {
		var, res := eventmanager.eventVariables[name]
		if res && var != value do return true
		else do return false
	} else {
		return true
	}
}
check_variable_conditionalevent :: proc(
	event : ConditionalEvent,
) -> bool {
	if event.varName != "" {
		var, res := eventmanager.eventVariables[event.varName]
		fmt.printf("%v:%v=%v",var,event.varValue,res && var == event.varValue)
		if res && var == event.varValue do return true
		else do return false
	} else {
		return true
	}
}