function dist(x1, y1, x2, y2)
	return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

function sprite_dist(a, b)
	return dist(a.x, a.y, b.x, b.y)
end

function angle(x1, y1, x2, y2)
	return math.atan2((y1 - y2), (x1 - x2))
end

function angle_avg(a1, a2, a1_weight)
	return math.atan2(math.sin(a1) * a1_weight + math.sin(a2) * (1 - a1_weight), math.cos(a1) * a1_weight + math.cos(a2) * (1 - a1_weight))
end

function to_screenspace(x, y)
	return (x - cam_x) * scale_factor, (y - cam_y) * scale_factor
end

function to_worldspace(x, y)
	return x / scale_factor + cam_x, y / scale_factor + cam_y
end

function val_clamp(val, min, max)
	return math.min(max, math.max(min, val))
end

function normalize(x, y)
	length = dist(0, 0, x, y)
	return x / length, y / length
end

function dot_prod(x1, y1, x2, y2)
	return x1 * x2 + y1 * y2
end

-- merge sort, for z-ordering
function mergeSort(list, compare_func)
	insize = 1

	if list == nil then return nil end

	while 1 do
		p = list
		nmerges = 0
		tail = nil
		list = nil

		while p ~= nil do
			nmerges = nmerges + 1
			q = p
			psize = 0
			for i = 1, insize, 1 do
				psize = psize + 1
				q = q.next
				if not(q) then break end
			end 
			qsize = insize
			while (psize > 0 or (qsize > 0 and q)) do
				
				if psize == 0 then
					e = q
					q = q.next
					qsize  = qsize - 1
				elseif (qsize == 0 or not(q)) then
					e = p
					p = p.next
					psize = psize- 1
				elseif compare_func(p, q) then
					e = p
					p = p.next
					psize = psize - 1
				else
					e = q
					q = q.next
					qsize = qsize - 1
				end
				if (tail) then
					tail.next = e
				else
					list = e
				end
				tail = e
			end
			p = q
		end

		tail.next = nil

		if nmerges <= 1 then
			return list
		end
		
		insize = insize * 2
	end
end

function sprite_compare(p, q)
	return (p.y <= q.y and p.layer == q.layer) or (p.layer < q.layer)
end

function rope_exists(ropes, a, b)
	rope = ropes
	exists = false
	while rope do
		if (rope.a == a and rope.b == b) or (rope.b == a and rope.a == b) then
			return true
		end
		
		rope = rope.next
	end
	
	return false
end

function get_rope_forces(rope)
	a_ax = 0
	a_ay = 0
	b_ax = 0
	b_ay = 0
	
	if dist(rope.a.x, rope.a.y, rope.b.x, rope.b.y) > rope.length then			
		
			rope_dir = angle(rope.a.x, rope.a.y, rope.b.x, rope.b.y)
			rope_dist = dist(rope.a.x, rope.a.y, rope.b.x, rope.b.y)
			
			dp = dot_prod(rope.b.vx, rope.b.vy, math.cos(rope_dir), math.sin(rope_dir))
				
			if dp > 0 then
				b_ax = math.cos(rope_dir) * math.exp((rope_dist - rope.length) / 64.0) * 0.1
				b_ay = math.sin(rope_dir) * math.exp((rope_dist - rope.length) / 64.0) * 0.1
			else
				b_ax = math.cos(rope_dir) * math.exp((rope_dist - rope.length) / 64.0) * 0.1 * 0.2
				b_ay = math.sin(rope_dir) * math.exp((rope_dist - rope.length) / 64.0) * 0.1 * 0.2
			end
			
		end
		
	return a_ax, a_ay, b_ax, b_ay
end
