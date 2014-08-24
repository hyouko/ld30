require "util"

function addRope(list, a, b, length)
	list = {next = list,
					a = a,
					b = b,
					str = 1.0,
					length = length
				}
	
	list = {next = list,
					a = b,
					b = a,
					str = 0.2,
					length = length
					}
	
	return list
end