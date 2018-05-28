--список всех функций
--начальное заполнение поля
function init()
	sizeTable = 9; -- размер игрового поля
	-- Создание игрового поля 10х10
	tablePole = { }
	tableRemove = { } -- таблица для выполнения удаления цепочек (так как при любом перемещении горизонтальные и вертикальные линии могут одновременно удаляться). 1 - значит удалить.
	for i=0,sizeTable do
		tablePole[i] = {}
		tableRemove[i] = {}
		for j=0,sizeTable do
			tableRemove[i][j] = 0
			tablePole[i][j] = math.random (0 , 5) 
			if(tablePole[i][j] == 0) then tablePole[i][j] = "A"
			elseif (tablePole[i][j] == 1) then tablePole[i][j] = "B"
			elseif (tablePole[i][j] == 2) then tablePole[i][j] = "C"
			elseif (tablePole[i][j] == 3) then tablePole[i][j] = "D"
			elseif (tablePole[i][j] == 4) then tablePole[i][j] = "E"
			elseif (tablePole[i][j] == 5) then tablePole[i][j] = "F"
			end
		end
	end
	
	-- для проверки работы mix
	--[[for i=0,sizeTable do
		for j=0,sizeTable do
			tablePole[i][j] = (i + j)%6
			if(tablePole[i][j] == 0) then tablePole[i][j] = "A"
			elseif (tablePole[i][j] == 1) then tablePole[i][j] = "B"
			elseif (tablePole[i][j] == 2) then tablePole[i][j] = "C"
			elseif (tablePole[i][j] == 3) then tablePole[i][j] = "D"
			elseif (tablePole[i][j] == 4) then tablePole[i][j] = "E"
			elseif (tablePole[i][j] == 5) then tablePole[i][j] = "F"
			end
		end
	end]]

	endgame = false --для выхода из игры и цикла
	answer = "" -- получение данных, введенных с клавиатуры
	removing = false -- было ли хоть какое-нибудь удаление
end

function CheckRemoveRow(  )
	-- проверяем сначала в строках
	for i=0,sizeTable do
		local sumstr = 1
		for j=0,(sizeTable - 1) do
			if(tablePole[i][j] == tablePole[i][j+1]) then 
				sumstr = sumstr + 1
			else
				if(sumstr > 2) then
					for k = j, j - (sumstr - 1), -1 do
						tableRemove[i][k] = 1
					end
				end
				sumstr = 1
			end
		end
		if(sumstr > 2) then
			for k = sizeTable, sizeTable - (sumstr - 1), -1 do
				tableRemove[i][k] = 1
			end
		end
	end
	-- проверяем столбцы
	for j=0,sizeTable do
		local sumstr = 1
		for i=0,(sizeTable - 1) do
			if(tablePole[i][j] == tablePole[i+1][j]) then 
				sumstr = sumstr + 1
			else
				if(sumstr > 2) then
					for k = i, i - (sumstr - 1), -1 do
						tableRemove[k][j] = 1
					end
				end
				sumstr = 1
			end
		end
		if(sumstr > 2) then
			for k = sizeTable, sizeTable - (sumstr - 1), -1 do
				tableRemove[k][j] = 1
			end
		end
	end

	removing = false -- было ли хоть какое-нибудь удаление
	for i=0,sizeTable do
		for j=0,sizeTable do
			if(tableRemove[i][j] == 1) then 
				removing = true
			end
		end
	end
end

function RemoveRow( )
	--CheckRemoveRow()
	--Удаляем все комбинации
	if(removing == true) then
		for i=0,sizeTable do
			for j=0,sizeTable do
				if(tableRemove[i][j] == 1) then 
					tablePole[i][j] = 0 
					tableRemove[i][j] = 0 
				end
			end
		end
	end
end

function addNewElements()
	for i=sizeTable,0,-1 do
		for j=0,sizeTable do
			if(tablePole[i][j] == 0) then 
				--Надо просмотреть все поля выше, если выше нет или предел поля, то рандомно добавляем элемент
				if(i ~= 0) then
					for k=(i-1),0,-1 do
						if(tablePole[k][j] ~= 0) then
							tablePole[i][j] = tablePole[k][j]
							tablePole[k][j] = 0
							break
						end
					end
				end
				--Рандом
				if(tablePole[i][j] == 0) then
					tablePole[i][j] = math.random (0 , 5) 
					if(tablePole[i][j] == 0) then tablePole[i][j] = "A"
					elseif (tablePole[i][j] == 1) then tablePole[i][j] = "B"
					elseif (tablePole[i][j] == 2) then tablePole[i][j] = "C"
					elseif (tablePole[i][j] == 3) then tablePole[i][j] = "D"
					elseif (tablePole[i][j] == 4) then tablePole[i][j] = "E"
					elseif (tablePole[i][j] == 5) then tablePole[i][j] = "F"
					end
				end
			end
		end
	end
end

function tick()
	--отрисовка
	dump()
	--ввод команд с клавиатуры
	io.write("\nSelect:")
	io.write("\n1) m x y d\n")
	io.write("2) q\n")
	io.flush()
    answer=io.read()
    --выход из игры
	if(answer == "q") then endgame = true end
	--если введена команда движения (должно быть 7 сиволов)
	if(string.len(answer) == 7) then
		if (string.byte(answer, 1) == 109 and string.byte(answer, 2) == 32
		    and (string.byte(answer, 3) >= 48 and string.byte(answer, 3) <= 57) and
			string.byte(answer, 4) == 32 and
			(string.byte(answer, 5) >= 48 and string.byte(answer, 5) <= 57) and 
			string.byte(answer, 6) == 32 and
			(string.byte(answer, 7) == 108 or string.byte(answer, 7) == 114 or string.byte(answer, 7) == 117 or string.byte(answer, 7) == 100)) 
		then 
			--переместить "кресталлы", если возможен ход
			move(tonumber(string.sub(answer, 3, 3)), tonumber(string.sub(answer, 5, 5)), string.sub(answer, 7, 7))
			mix()
		end 
	end
end

function move(x, y, d)
	--Если движение невозможно, т.к. движение уходит за границы игрвоого поля
	if (d == "u" and x == 0) then print ("ERROR MOVE") return
	elseif (d == "d" and x == sizeTable) then print ("ERROR MOVE") return 
	elseif (d == "l" and y == 0) then print ("ERROR MOVE") return 
	elseif (d == "r" and y == sizeTable) then print ("ERROR MOVE") return end
	--Если движение возможно
	local buf
	--Движение налево 
	if (d == "l") then 
		buf = tablePole[x][y]
		tablePole[x][y] = tablePole[x][y-1]
		tablePole[x][y-1] = buf
		CheckRemoveRow( )
		if(removing == false) then
			tablePole[x][y-1] = tablePole[x][y]
			tablePole[x][y] = buf
			print ("ERROR MOVE")
		else
			repeat
				CheckRemoveRow( )
				RemoveRow( )
				if(removing == true) then dump() end 
				addNewElements()
				if(removing == true) then dump() end 
			until removing == false
		end
	end
	--Движение направо
	if (d == "r") then 
		buf = tablePole[x][y]
		tablePole[x][y] = tablePole[x][y+1]
		tablePole[x][y+1] = buf
		CheckRemoveRow( )
		if(removing == false) then
			tablePole[x][y+1] = tablePole[x][y]
			tablePole[x][y] = buf
			print ("ERROR MOVE")
		else
			repeat
				CheckRemoveRow( )
				RemoveRow( )
				if(removing == true) then dump() end 
				addNewElements()
				if(removing == true) then dump() end 
			until removing == false
		end
	end
	--Движение вверх
	if (d == "u") then 
		buf = tablePole[x][y]
		tablePole[x][y] = tablePole[x-1][y]
		tablePole[x-1][y] = buf
		CheckRemoveRow( )
		if(removing == false) then
			tablePole[x-1][y] = tablePole[x][y]
			tablePole[x][y] = buf
			print ("ERROR MOVE")
		else
			repeat
				CheckRemoveRow( )
				RemoveRow( )
				if(removing == true) then dump() end 
				addNewElements()
				if(removing == true) then dump() end 
			until removing == false
		end
	end
	--движение вниз
	if (d == "d") then 
		buf = tablePole[x][y]
		tablePole[x][y] = tablePole[x+1][y]
		tablePole[x+1][y] = buf
		CheckRemoveRow( )
		if(removing == false) then
			tablePole[x+1][y] = tablePole[x][y]
			tablePole[x][y] = buf
			print ("ERROR MOVE")
		else
			repeat
				CheckRemoveRow( )
				RemoveRow( )
				if(removing == true) then dump() end 
				addNewElements()
				if(removing == true) then dump() end 
			until removing == false
		end
	end
end

function ganerationMix( )
	--обнулим игровое поле
	for i=0,sizeTable do
		for j=0,sizeTable do
			tablePole[i][j] = 0
			tableRemove[i][j] = 0
		end
	end
	--значениями из s заполнить tablePole
	local s2 = s 
	for i=0,sizeTable do
		for j=0,sizeTable do
			repeat
				buf = math.random (0 , 5) 
				if(buf == 0 and s2["A"] > 0) then 
					tablePole[i][j] = "A" 
					s2["A"] = s2["A"] - 1
				elseif (buf == 1 and s2["B"] > 0) then 
					tablePole[i][j] = "B"
					s2["B"] = s2["B"] - 1
				elseif (buf == 2 and s2["C"] > 0) then 
					tablePole[i][j] = "C"
					s2["C"] = s2["C"] - 1
				elseif (buf == 3 and s2["D"] > 0) then 
					tablePole[i][j] = "D"
					s2["D"] = s2["D"] - 1
				elseif (buf == 4 and s2["E"] > 0) then 
					tablePole[i][j] = "E"
					s2["E"] = s2["E"] - 1
				elseif (buf == 5 and s2["F"] > 0) then 
					tablePole[i][j] = "F"
					s2["F"] = s2["F"] - 1
				end
			until tablePole[i][j] ~= 0
		end
	end
end

function mix()
	possibleMove = false
	--проверка направо
	for i=0,sizeTable do
		for j=0,(sizeTable-1) do
			buf = tablePole[i][j]
			tablePole[i][j] = tablePole[i][j+1]
			tablePole[i][j+1] = buf
			CheckRemoveRow( )
			tablePole[i][j+1] = tablePole[i][j]
			tablePole[i][j] = buf
			if(removing == true) then
				possibleMove = true
				removing = false
				for i=0,sizeTable do
					for j=0,sizeTable do
						tableRemove[i][j] = 0
					end
				end
			end
		end
	end
	--проверка вниз
	if(possibleMove == false) then
		for i=0,(sizeTable-1) do
			for j=0,sizeTable do
				buf = tablePole[i][j]
				tablePole[i][j] = tablePole[i+1][j]
				tablePole[i+1][j] = buf
				CheckRemoveRow( )
				tablePole[i+1][j] = tablePole[i][j]
				tablePole[i][j] = buf
				if(removing == true) then
					possibleMove = true
					removing = false
					for i=0,sizeTable do
						for j=0,sizeTable do
							tableRemove[i][j] = 0
						end
					end
				end
			end
		end
	end
	--Если нет возможного хода
	if(possibleMove == false) then 
		s = {}
		s["A"] = 0
		s["B"] = 0
		s["C"] = 0
		s["D"] = 0
		s["E"] = 0
		s["F"] = 0
		repeat
			for i=0,sizeTable do
				for j=0,sizeTable do
					s[tablePole[i][j]] = s[tablePole[i][j]] + 1
				end
			end
			ganerationMix( )
			CheckRemoveRow( )
		until removing == false
	end
end

--отрисовка игры
function dump()
	local str = "    0 1 2 3 4 5 6 7 8 9"
	print(str)
	str = "    _ _ _ _ _ _ _ _ _ _"
	print(str)
	str = ""
	for i=0,sizeTable do
		for j=0,sizeTable do
			str = str .. tablePole[i][j] .. " "
		end
		str = i .. " | " .. str
		print(str)
		str = ""
	end
	print(str)
end

--Начальная настройка игры
init()
repeat
	CheckRemoveRow(  )
	RemoveRow( )
	addNewElements()
until removing == false
mix()

--Процесс игры ( бесконечный цикл или выход по команде q)
repeat 
	tick()
until endgame == true