function dist(x1, y1, x2, y2)
	return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

function angle(x1, y1, x2, y2)
	return math.atan2((y1 - y2), (x1 - x2))
end

function to_screenspace(x, y)
	return (x - cam_x) * scale_factor, (y - cam_y) * scale_factor
end