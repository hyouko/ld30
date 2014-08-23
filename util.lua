function dist(x1, y1, x2, y2)
	return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

function angle(x1, y1, x2, y2)
	return math.atan2((y1 - y2), (x1 - x2))
end

function to_screenspace(x, y)
	return (x - cam_x) * scale_factor, (y - cam_y) * scale_factor
end

function val_clamp(val, min, max)
	return math.min(max, math.max(min, val))
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