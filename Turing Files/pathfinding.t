include "pathfinding_grid.t"

proc resetAStar(enemyNum : int)
    if enemyNum = 1 then
        new enemy1Q, 0 
        new enemy1Searched, 0
        enemy(1).openX := 0
        enemy(1).openY := 0
    elsif enemyNum = 2 then
        new enemy2Q, 0 
        new enemy2Searched, 0
        enemy(2).openX := 0
        enemy(2).openY := 0
    elsif enemyNum = 3 then
        new enemy3Q, 0 
        new enemy3Searched, 0
        enemy(3).openX := 0
        enemy(3).openY := 0
    elsif enemyNum = 4 then
        new enemy4Q, 0 
        new enemy4Searched, 0
        enemy(4).openX := 0
        enemy(4).openY := 0
    end if
    enemy(enemyNum).initialize := true
    enemy(enemyNum).setPlayerPos := true
end resetAStar 


function contains (x,y,enemyNum : int,list :string) : boolean
    if enemyNum = 1 then
        if list = "q" then
            for i : 1 .. upper(enemy1Q)
                if enemy1Q(i).a = x and enemy1Q(i).b = y then
                    result true
                end if
            end for
            result false
        elsif list = "searched" then
            for i : 1 .. upper(enemy1Searched)
                if enemy1Searched(i).a = x and enemy1Searched(i).b = y then
                    result true
                end if
            end for
            result false
        end if
    elsif enemyNum = 2 then
        if list = "q" then
            for i : 1 .. upper(enemy2Q)-1
                if enemy2Q(i).a = x and enemy2Q(i).b = y then
                    result true
                end if
            end for
            result false
        elsif list = "searched" then
            for i : 1 .. upper(enemy2Searched)
                if enemy2Searched(i).a = x and enemy2Searched(i).b = y then
                    result true
                end if
            end for
            result false
        end if
    elsif enemyNum = 3 then
        if list = "q" then
            for i : 1 .. upper(enemy3Q)
                if enemy3Q(i).a = x and enemy3Q(i).b = y then
                    result true
                end if
            end for
            result false
        elsif list = "searched" then
            for i : 1 .. upper(enemy3Searched)
                if enemy3Searched(i).a = x and enemy3Searched(i).b = y then
                    result true
                end if
            end for
            result false
        end if
    elsif enemyNum = 4 then
        if list = "q" then
            for i : 1 .. upper(enemy4Q)
                if enemy4Q(i).a = x and enemy4Q(i).b = y then
                    result true
                end if
            end for
            result false
        elsif list = "searched" then
            for i : 1 .. upper(enemy4Searched)
                if enemy4Searched(i).a = x and enemy4Searched(i).b = y then
                    result true
                end if
            end for
            result false
        end if
    end if
end contains


proc aStar(startX,startY,goalX,goalY,enemyNum:int)
    if enemyNum = 1 then
        if enemy(enemyNum).initialize then
            for i : 1 .. 60
                for j : 1 .. 53
                    if startX >= grid(i,j).leftB.x and 
                            startX < grid(i,j).rightB.x and 
                            startY >= grid(i,j).leftB.y and 
                            startY < grid(i,j).leftT.y then
                        enemy(enemyNum).start.x := i
                        enemy(enemyNum).start.y := j
                        grid(i,j).start := true
                        new enemy1Q, upper(enemy1Q)+1
                        enemy1Q(upper(enemy1Q)).a := i
                        enemy1Q(upper(enemy1Q)).b := j
                    end if
                    if goalX >= grid(i,j).leftB.x and 
                        goalX < grid(i,j).rightB.x and
                        goalY >= grid(i,j).leftB.y and
                        goalY < grid(i,j).leftT.y then
                        grid(i,j).goal := true
                        grid(i,j).wall := false
                        enemy(enemyNum).goal.x := i
                        enemy(enemyNum).goal.y := j
                    end if
                end for
            end for
                enemy(enemyNum).initialize := false
        end if
    
    if enemy(enemyNum).goal.x not= enemy(enemyNum).start.x or 
            enemy(enemyNum).goal.y not= enemy(enemyNum).start.y then
        %Open first item in queue and remove from list
        enemy(enemyNum).openX := enemy1Q(lower(enemy1Q)).a
        enemy(enemyNum).openY := enemy1Q(lower(enemy1Q)).b
        new enemy1Searched, upper(enemy1Searched) + 1
        enemy1Searched(upper(enemy1Searched)) := enemy1Q(lower(enemy1Q))
        for i : 1 .. upper(enemy1Q)-1
            enemy1Q(i) := enemy1Q(i+1)
        end for
            new enemy1Q, upper(enemy1Q)-1
        %Add surrounding tiles to queue
        %Up Tile
        if enemy(enemyNum).openX+1 <= upper(grid,1) then
            if grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY). wall = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,1,'searched') = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,1,'q') = false then
                new enemy1Q, upper(enemy1Q) + 1
                enemy1Q(upper(enemy1Q)).a := enemy(enemyNum).openX + 1
                enemy1Q(upper(enemy1Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy1.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy1.y := enemy(enemyNum).openY
                enemy1Q(upper(enemy1Q)).fScore := round( 8*(abs(enemy(enemyNum).openX+1 - enemy(enemyNum).goal.x) + abs(enemy(enemyNum).openY   - enemy(enemyNum).goal.y)) + abs(enemy(enemyNum).openX+1 - enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY   - enemy(enemyNum).start.y))
                enemy1Q(upper(enemy1Q)).direction := "up"
            end if
        end if
        %Down Tile
        if enemy(1).openX-1 >= 1 then
            if grid(enemy(1).openX-1,enemy(enemyNum).openY). wall = false and contains(enemy(enemyNum).openX-1,enemy(1).openY,1,'searched') = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,1,'q') = false then
                new enemy1Q, upper(enemy1Q) + 1
                enemy1Q(upper(enemy1Q)).a := enemy(enemyNum).openX - 1
                enemy1Q(upper(enemy1Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy1.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy1.y := enemy(enemyNum).openY
                enemy1Q(upper(enemy1Q)).fScore := round( 8*(abs((enemy(enemyNum).openX-1)-enemy(enemyNum).goal.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).goal.y)) + (abs((enemy(enemyNum).openX-1)-enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).start.y)))
                enemy1Q(upper(enemy1Q)).direction := "down"
            end if
        end if
        %Left Tile
        if enemy(enemyNum).openY+1 <= upper(grid,2) then
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,1,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,1,'q') = false then
                new enemy1Q, upper(enemy1Q) + 1
                enemy1Q(upper(enemy1Q)).a := enemy(enemyNum).openX
                enemy1Q(upper(enemy1Q)).b := enemy(enemyNum).openY + 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy1.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy1.y := enemy(enemyNum).openY
                enemy1Q(upper(enemy1Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).start.y)))
                enemy1Q(upper(enemy1Q)).direction := 'left'
            end if
        end if
        %Right Tile
        if enemy(enemyNum).openY-1 >= lower(grid,1) then            
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,1,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,1,'q') = false then
                new enemy1Q, upper(enemy1Q) + 1
                enemy1Q(upper(enemy1Q)).a := enemy(enemyNum).openX
                enemy1Q(upper(enemy1Q)).b := enemy(enemyNum).openY - 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy1.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy1.y := enemy(enemyNum).openY
                enemy1Q(upper(enemy1Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).start.y)))
                 enemy1Q(upper(enemy1Q)).direction := 'left'
            end if
        end if
        if enemy(enemyNum).goal.x not= enemy(enemyNum).openX then
            %Sort
            if debug then
             for j : 1 .. upper(enemy1Q)-1
                        put "enemy4 ",j..
                        put " upper: ",upper(enemy1Q)..
                       put " ",enemy1Q(j).a, " ",enemy1Q(j).b..
                       put "direction: ",enemy1Q(j).direction
                        put " fScore ",enemy1Q(j).fScore
                        View.Update
                    end for
                end if
            var temp : arrayElement
            for a : 1 .. upper(enemy1Q)
                for i : 1 .. (upper(enemy1Q)-1)
                    if debug then
                         put enemy1Q(i).a
                    end if
                    if enemy1Q(i).fScore > enemy1Q(i+1).fScore then
                        temp := enemy1Q(i)
                        enemy1Q(i) := enemy1Q(i+1)
                        enemy1Q(i+1) := temp
                    end if
                end for
            end for
        end if
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            enemy(enemyNum).path(200).x := enemy(enemyNum).openX
            enemy(enemyNum).path(200).y := enemy(enemyNum).openY
            enemy(enemyNum).path(199).x := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy1.x
            enemy(enemyNum).path(199).y := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy1.y
            enemy(enemyNum).count := 198
            loop/*
                put "enemyNum ",enemyNum..
                put ' count' ,enemy(enemyNum).count..
                put  " x val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                put " y val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y..
                put " Goal X: ", goalX..
                put " Y: ", goalY..
                put " Goal X: ",enemy(enemyNum).goal.x..
                put" Y: ",enemy(enemyNum).goal.y..
                put " current X: ",enemy(enemyNum).path(enemy(enemyNum).count+1).x..
                put " Y: ",enemy(enemyNum).path(enemy(enemyNum).count+1).y
                put "Grid at current X: ", grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                 put "Y: ", grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y
                put contains(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y,1,'searched')
                View.Update*/
                enemy(enemyNum).path(enemy(enemyNum).count).x := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy1.x
                enemy(enemyNum).path(enemy(enemyNum).count).y := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy1.y
                enemy(enemyNum).count -= 1
                if enemy(enemyNum).path(enemy(enemyNum).count+1).x = enemy(enemyNum).start.x and 
                        enemy(enemyNum).path(enemy(enemyNum).count+1).y = enemy(enemyNum).start.y then
                    exit
                end if
                if enemy(enemyNum).count = 1 then
                    resetAStar(enemyNum)
                    exit
                end if
            end loop
        end if
        
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            %enemy(enemyNum).firstMove := counter
            enemy(enemyNum).enemyPath := true
            %newPath := true
            %pathing := true
            resetAStar(enemyNum)
            enemy(enemyNum).count := enemy(enemyNum).count + 1
            enemy(enemyNum).pLast.x := -1
            enemy(enemyNum).pLast.y := -1
            enemy(enemyNum).status := "searching"
            enemy(enemyNum).noiseSearch := false
        end if
    end if
    elsif enemyNum =2 then
        if enemy(enemyNum).initialize then
            for i : 1 .. 60
                for j : 1 .. 53
                    if startX >= grid(i,j).leftB.x and 
                            startX < grid(i,j).rightB.x and 
                            startY >= grid(i,j).leftB.y and 
                            startY < grid(i,j).leftT.y then
                        enemy(enemyNum).start.x := i
                        enemy(enemyNum).start.y := j
                        grid(i,j).start := true
                        new enemy2Q, upper(enemy2Q)+1
                        enemy2Q(upper(enemy2Q)).a := i
                        enemy2Q(upper(enemy2Q)).b := j
                    end if
                    if goalX >= grid(i,j).leftB.x and 
                        goalX < grid(i,j).rightB.x and
                        goalY >= grid(i,j).leftB.y and
                        goalY < grid(i,j).leftT.y then
                        grid(i,j).goal := true
                        grid(i,j).wall := false
                        enemy(enemyNum).goal.x := i
                        enemy(enemyNum).goal.y := j
                    end if
                end for
            end for
                enemy(enemyNum).initialize := false
        end if
    
    if enemy(enemyNum).goal.x not= enemy(enemyNum).start.x or 
            enemy(enemyNum).goal.y not= enemy(enemyNum).start.y then
        %Open first item in queue and remove from list
        enemy(enemyNum).openX := enemy2Q(lower(enemy2Q)).a
        enemy(enemyNum).openY := enemy2Q(lower(enemy2Q)).b
        new enemy2Searched, upper(enemy2Searched) + 1
        enemy2Searched(upper(enemy2Searched)) := enemy2Q(lower(enemy2Q))
        for i : 1 .. upper(enemy2Q)-1
            enemy2Q(i) := enemy2Q(i+1)
        end for
        new enemy2Q, upper(enemy2Q)-1
        %Add surrounding tiles to queue
        %Up Tile
        if enemy(enemyNum).openX+1 <= upper(grid,1) then
            if grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY). wall = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,2,'searched') = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,2,'q') = false then
                new enemy2Q, upper(enemy2Q) + 1
                enemy2Q(upper(enemy2Q)).a := enemy(enemyNum).openX + 1
                enemy2Q(upper(enemy2Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy2.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy2.y := enemy(enemyNum).openY
                enemy2Q(upper(enemy2Q)).fScore := round( 8*(abs(enemy(enemyNum).openX+1 - enemy(enemyNum).goal.x) + 
                abs(enemy(enemyNum).openY   - enemy(enemyNum).goal.y)) + 
                abs(enemy(enemyNum).openX+1 - enemy(enemyNum).start.x) + 
                abs(enemy(enemyNum).openY   - enemy(enemyNum).start.y))
                enemy2Q(upper(enemy2Q)).direction := 'up'
            end if
        end if
        %Down Tile
        if enemy(enemyNum).openX-1 >= 1 then
            if grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY). wall = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,2,'searched') = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,2,'q') = false then
                new enemy2Q, upper(enemy2Q) + 1
                enemy2Q(upper(enemy2Q)).a := enemy(enemyNum).openX - 1
                enemy2Q(upper(enemy2Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy2.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy2.y := enemy(enemyNum).openY
                enemy2Q(upper(enemy2Q)).fScore := round( 8*(abs((enemy(enemyNum).openX-1)-enemy(enemyNum).goal.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).goal.y)) + (abs((enemy(enemyNum).openX-1)-enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).start.y)))
                enemy2Q(upper(enemy2Q)).direction := 'down'
            end if
        end if
        %Left Tile
        if enemy(enemyNum).openY+1 <= upper(grid,2) then
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,2,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,2,'q') = false then
                new enemy2Q, upper(enemy2Q) + 1
                enemy2Q(upper(enemy2Q)).a := enemy(enemyNum).openX
                enemy2Q(upper(enemy2Q)).b := enemy(enemyNum).openY + 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy2.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy2.y := enemy(enemyNum).openY
                enemy2Q(upper(enemy2Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).start.y)))
                enemy2Q(upper(enemy2Q)).direction := 'left'
                %put enemy2Q(upper(enemy2Q)).fScore
            end if
        end if
        %Right Tile
        if enemy(enemyNum).openY-1 >= lower(grid,1) then            
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,2,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,2,'q') = false then
                new enemy2Q, upper(enemy2Q) + 1
                enemy2Q(upper(enemy2Q)).a := enemy(enemyNum).openX
                enemy2Q(upper(enemy2Q)).b := enemy(enemyNum).openY - 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy2.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy2.y := enemy(enemyNum).openY
                enemy2Q(upper(enemy2Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).start.y)))
                enemy2Q(upper(enemy2Q)).direction := 'right'
                %put enemy2Q(upper(enemy2Q)).fScore
            end if
        end if
        if enemy(enemyNum).goal.x not= enemy(enemyNum).openX then
        if debug then
        for j : 1 .. upper(enemy2Q)-1
                        put "enemy4 ",j..
                        put " upper: ",upper(enemy2Q)..
                       put " ",enemy2Q(j).a, " ",enemy2Q(j).b..
                       put "direction: ",enemy2Q(j).direction
                        put " fScore ",enemy2Q(j).fScore
                        View.Update
                    end for
                    end if
            %Sort
            var temp : arrayElement
            for a : 1 .. upper(enemy2Q)
                for i : 1 .. (upper(enemy2Q)-1)
                    if enemy2Q(i).fScore > enemy2Q(i+1).fScore then
                        temp := enemy2Q(i)
                        enemy2Q(i) := enemy2Q(i+1)
                        enemy2Q(i+1) := temp
                    end if
                end for
            end for
        end if
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            enemy(enemyNum).path(200).x := enemy(enemyNum).openX
            enemy(enemyNum).path(200).y := enemy(enemyNum).openY
            enemy(enemyNum).path(199).x := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy2.x
            enemy(enemyNum).path(199).y := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy2.y
            enemy(enemyNum).count := 198
            loop/*
                put "enemyNum ",enemyNum..
                put ' count' ,enemy(enemyNum).count..
                put  " x val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                put " y val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y..
                put " Goal X: ", goalX..
                put " Y: ", goalY..
                put " Goal X: ",enemy(enemyNum).goal.x..
                put" Y: ",enemy(enemyNum).goal.y..
                put " current X: ",enemy(enemyNum).path(enemy(enemyNum).count+1).x..
                put " Y: ",enemy(enemyNum).path(enemy(enemyNum).count+1).y..
                put contains(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y,2,'searched')
                View.Update*/
                enemy(enemyNum).path(enemy(enemyNum).count).x := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy2.x
                enemy(enemyNum).path(enemy(enemyNum).count).y := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy2.y
                enemy(enemyNum).count -= 1
                if enemy(enemyNum).path(enemy(enemyNum).count+1).x = enemy(enemyNum).start.x and 
                    enemy(enemyNum).path(enemy(enemyNum).count+1).y = enemy(enemyNum).start.y then
                    exit
                end if
                if enemy(enemyNum).count = 1 then
                    resetAStar(enemyNum)
                    exit
                end if
            end loop
        end if
        
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            %enemy(enemyNum).firstMove := counter
            enemy(enemyNum).enemyPath := true
            %newPath := true
            %pathing := true
            resetAStar(enemyNum)
            enemy(enemyNum).count := enemy(enemyNum).count + 1
            enemy(enemyNum).pLast.x := -1
            enemy(enemyNum).pLast.y := -1
            enemy(enemyNum).status := "searching"
            enemy(enemyNum).noiseSearch := false
        end if
    end if
    elsif enemyNum = 3 then
        if enemy(enemyNum).initialize then
            for i : 1 .. 60
                for j : 1 .. 53
                    if startX >= grid(i,j).leftB.x and 
                            startX < grid(i,j).rightB.x and 
                            startY >= grid(i,j).leftB.y and 
                            startY < grid(i,j).leftT.y then
                        enemy(enemyNum).start.x := i
                        enemy(enemyNum).start.y := j
                        grid(i,j).start := true
                        new enemy3Q, upper(enemy3Q)+1
                        enemy3Q(upper(enemy3Q)).a := i
                        enemy3Q(upper(enemy3Q)).b := j
                    end if
                    if goalX >= grid(i,j).leftB.x and 
                        goalX < grid(i,j).rightB.x and
                        goalY >= grid(i,j).leftB.y and
                        goalY < grid(i,j).leftT.y then
                        grid(i,j).goal := true
                        grid(i,j).wall := false
                        enemy(enemyNum).goal.x := i
                        enemy(enemyNum).goal.y := j
                    end if
                end for
            end for
                enemy(enemyNum).initialize := false
        end if
    
    if enemy(enemyNum).goal.x not= enemy(enemyNum).start.x or 
            enemy(enemyNum).goal.y not= enemy(enemyNum).start.y then
        %Open first item in queue and remove from list
        enemy(enemyNum).openX := enemy3Q(lower(enemy3Q)).a
        enemy(enemyNum).openY := enemy3Q(lower(enemy3Q)).b
        new enemy3Searched, upper(enemy3Searched) + 1
        enemy3Searched(upper(enemy3Searched)) := enemy3Q(lower(enemy3Q))
        for i : 1 .. upper(enemy3Q)-1
            enemy3Q(i) := enemy3Q(i+1)
        end for
            new enemy3Q, upper(enemy3Q)-1
        %Add surrounding tiles to queue
        %Up Tile
        if enemy(enemyNum).openX+1 <= upper(grid,1) then
            if grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY). wall = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,3,'searched') = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,3,'q') = false then
                new enemy3Q, upper(enemy3Q) + 1
                enemy3Q(upper(enemy3Q)).a := enemy(enemyNum).openX + 1
                enemy3Q(upper(enemy3Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy3.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy3.y := enemy(enemyNum).openY
                enemy3Q(upper(enemy3Q)).fScore := round( 8*(abs(enemy(enemyNum).openX+1 - enemy(enemyNum).goal.x) + 
                abs(enemy(enemyNum).openY   - enemy(enemyNum).goal.y)) + 
                abs(enemy(enemyNum).openX+1 - enemy(enemyNum).start.x) + 
                abs(enemy(enemyNum).openY   - enemy(enemyNum).start.y))
            end if
        end if
        %Down Tile
        if enemy(enemyNum).openX-1 >= 1 then
            if grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY). wall = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,3,'searched') = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,3,'q') = false then
                new enemy3Q, upper(enemy3Q) + 1
                enemy3Q(upper(enemy3Q)).a := enemy(enemyNum).openX - 1
                enemy3Q(upper(enemy3Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy3.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy3.y := enemy(enemyNum).openY
                enemy3Q(upper(enemy3Q)).fScore := round( 8*(abs((enemy(enemyNum).openX-1)-enemy(enemyNum).goal.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).goal.y)) + (abs((enemy(enemyNum).openX-1)-enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).start.y)))
            end if
        end if
        %Left Tile
        if enemy(enemyNum).openY+1 <= upper(grid,2) then
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,3,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,3,'q') = false then
                new enemy3Q, upper(enemy3Q) + 1
                enemy3Q(upper(enemy3Q)).a := enemy(enemyNum).openX
                enemy3Q(upper(enemy3Q)).b := enemy(enemyNum).openY + 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy3.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy3.y := enemy(enemyNum).openY
                enemy3Q(upper(enemy3Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).start.y)))
            end if
        end if
        %Right Tile
        if enemy(enemyNum).openY-1 >= lower(grid,1) then            
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,3,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,3,'q') = false then
                new enemy3Q, upper(enemy3Q) + 1
                enemy3Q(upper(enemy3Q)).a := enemy(enemyNum).openX
                enemy3Q(upper(enemy3Q)).b := enemy(enemyNum).openY - 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy3.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy3.y := enemy(enemyNum).openY
                enemy3Q(upper(enemy3Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).start.y)))
            end if
        end if
        if enemy(enemyNum).goal.x not= enemy(enemyNum).openX then
            %Sort
            if debug then
            for j : 1 .. upper(enemy3Q)-2
                locate(1,1)
                        put "enemy3Q ",j , " upper: ",upper(enemy3Q), " ",enemy3Q(j).a, " ",enemy3Q(j).b," "..
                        put enemy3Q(j).fScore
                        View.Update
                    end for
                end if
            var temp : arrayElement
            for a : 1 .. upper(enemy3Q)
                for i : 1 .. (upper(enemy3Q)-2)
                    if enemy3Q(i).fScore > enemy3Q(i+1).fScore then
                        temp := enemy3Q(i)
                        enemy3Q(i) := enemy3Q(i+1)
                        enemy3Q(i+1) := temp
                    end if
                end for
            end for
        end if
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            enemy(enemyNum).path(200).x := enemy(enemyNum).openX
            enemy(enemyNum).path(200).y := enemy(enemyNum).openY
            enemy(enemyNum).path(199).x := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy3.x
            enemy(enemyNum).path(199).y := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy3.y
            enemy(enemyNum).count := 198
            loop/*
                put "enemyNum ",enemyNum..
                put ' count' ,enemy(enemyNum).count..
                put  " x val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                put " y val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y..
                put " Goal X: ", goalX..
                put " Y: ", goalY..
                put " Goal X: ",enemy(enemyNum).goal.x..
                put" Y: ",enemy(enemyNum).goal.y..
                put " current X: ",enemy(enemyNum).path(enemy(enemyNum).count+1).x..
                put " Y: ",enemy(enemyNum).path(enemy(enemyNum).count+1).y
                put "Grid at current X: ", grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                put "Y: ", grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y..
                put contains(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y,3,'searched')
                put "parent.x ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy3.x
                put "parent.y ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy3.y..
                
                View.Update
                delay(100)*/
                enemy(enemyNum).path(enemy(enemyNum).count).x := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy3.x
                enemy(enemyNum).path(enemy(enemyNum).count).y := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy3.y
                enemy(enemyNum).count -= 1
                if enemy(enemyNum).path(enemy(enemyNum).count+1).x = enemy(enemyNum).start.x and 
                        enemy(enemyNum).path(enemy(enemyNum).count+1).y = enemy(enemyNum).start.y then
                    exit
                end if
                if enemy(enemyNum).count = 1 then
                    resetAStar(enemyNum)
                    exit
                end if
            end loop
        end if
        
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            %enemy(enemyNum).firstMove := counter
            enemy(enemyNum).enemyPath := true
            %newPath := true
            %pathing := true
            resetAStar(enemyNum)
            enemy(enemyNum).count := enemy(enemyNum).count + 1
            enemy(enemyNum).pLast.x := -1
            enemy(enemyNum).pLast.y := -1
            enemy(enemyNum).status := "searching"
            enemy(enemyNum).noiseSearch := false
        end if
    end if
    elsif enemyNum = 4 then
        if enemy(enemyNum).initialize then
            for i : 1 .. 60
                for j : 1 .. 53
                    if startX >= grid(i,j).leftB.x and 
                            startX < grid(i,j).rightB.x and 
                            startY >= grid(i,j).leftB.y and 
                            startY < grid(i,j).leftT.y then
                        enemy(enemyNum).start.x := i
                        enemy(enemyNum).start.y := j
                        grid(i,j).start := true
                        new enemy4Q, upper(enemy4Q)+1
                        enemy4Q(upper(enemy4Q)).a := i
                        enemy4Q(upper(enemy4Q)).b := j
                    end if
                    if goalX >= grid(i,j).leftB.x and 
                        goalX < grid(i,j).rightB.x and
                        goalY >= grid(i,j).leftB.y and
                        goalY < grid(i,j).leftT.y then
                        grid(i,j).goal := true
                        grid(i,j).wall := false
                        enemy(enemyNum).goal.x := i
                        enemy(enemyNum).goal.y := j
                    end if
                end for
            end for
                enemy(enemyNum).initialize := false
        end if
    
    if enemy(enemyNum).goal.x not= enemy(enemyNum).start.x or 
            enemy(enemyNum).goal.y not= enemy(enemyNum).start.y then
        %Open first item in queue and remove from list
        if debug then
            put enemy4Q(lower(enemy4Q)).a
        end if
        enemy(enemyNum).openX := enemy4Q(lower(enemy4Q)).a
        enemy(enemyNum).openY := enemy4Q(lower(enemy4Q)).b
        new enemy4Searched, upper(enemy4Searched) + 1
        enemy4Searched(upper(enemy4Searched)) := enemy4Q(lower(enemy4Q))
        for i : 1 .. upper(enemy4Q)-1
            enemy4Q(i) := enemy4Q(i+1)
        end for
            new enemy4Q, upper(enemy4Q)-1
        %Add surrounding tiles to queue
        %Up Tile
        if enemy(enemyNum).openX+1 <= upper(grid,1) then
            if grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY). wall = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,4,'searched') = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,4,'q') = false then
                new enemy4Q, upper(enemy4Q) + 1
                enemy4Q(upper(enemy4Q)).a := enemy(enemyNum).openX + 1
                enemy4Q(upper(enemy4Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy4.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy4.y := enemy(enemyNum).openY
                enemy4Q(upper(enemy4Q)).fScore := round( 8*(abs(enemy(enemyNum).openX+1 - enemy(enemyNum).goal.x) +abs(enemy(enemyNum).openY - enemy(enemyNum).goal.y)) + abs(enemy(enemyNum).openX+1 - enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY - enemy(enemyNum).start.y))
                enemy4Q(upper(enemy4Q)).direction := 'up'
            end if
        end if
        %Down Tile
        if enemy(enemyNum).openX-1 >= 1 then
            if grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY). wall = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,4,'searched') = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,4,'q') = false then
                new enemy4Q, upper(enemy4Q) + 1
                enemy4Q(upper(enemy4Q)).a := enemy(enemyNum).openX - 1
                enemy4Q(upper(enemy4Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy4.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy4.y := enemy(enemyNum).openY
                enemy4Q(upper(enemy4Q)).fScore := round( 8*(abs((enemy(enemyNum).openX-1)-enemy(enemyNum).goal.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).goal.y)) + (abs((enemy(enemyNum).openX-1)-enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).start.y)))
                enemy4Q(upper(enemy4Q)).direction := 'down'
            end if
        end if
        %Left Tile
        if enemy(enemyNum).openY+1 <= upper(grid,2) then
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,4,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,4,'q') = false then
                new enemy4Q, upper(enemy4Q) + 1
                enemy4Q(upper(enemy4Q)).a := enemy(enemyNum).openX
                enemy4Q(upper(enemy4Q)).b := enemy(enemyNum).openY + 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy4.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy4.y := enemy(enemyNum).openY
                enemy4Q(upper(enemy4Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).start.y)))
                enemy4Q(upper(enemy4Q)).direction := 'left'
            end if
        end if
        %Right Tile
        if enemy(enemyNum).openY-1 >= lower(grid,1) then            
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,4,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,4,'q') = false then
                new enemy4Q, upper(enemy4Q) + 1
                enemy4Q(upper(enemy4Q)).a := enemy(enemyNum).openX
                enemy4Q(upper(enemy4Q)).b := enemy(enemyNum).openY - 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy4.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy4.y := enemy(enemyNum).openY
                enemy4Q(upper(enemy4Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).start.y)))
                enemy4Q(upper(enemy4Q)).direction := 'right'
            end if
        end if
        if enemy(enemyNum).goal.x not= enemy(enemyNum).openX then
            %Sort
            if debug then
            for j : 1 .. upper(enemy4Q)-1
                        put "enemy4 ",j..
                        put " upper: ",upper(enemy4Q)..
                       put " ",enemy4Q(j).a, " ",enemy4Q(j).b..
                       put "direction: ",enemy4Q(j).direction
                        put " fScore ",enemy4Q(j).fScore
                        View.Update
                    end for
            end if
            var temp : arrayElement
            for a : 1 .. upper(enemy4Q)
                for i : 1 .. (upper(enemy4Q)-1)
                    if enemy4Q(i).fScore > enemy4Q(i+1).fScore then
                        temp := enemy4Q(i)
                        enemy4Q(i) := enemy4Q(i+1)
                        enemy4Q(i+1) := temp
                    end if
                end for
            end for
        end if
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            enemy(enemyNum).path(200).x := enemy(enemyNum).openX
            enemy(enemyNum).path(200).y := enemy(enemyNum).openY
            enemy(enemyNum).path(199).x := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy4.x
            enemy(enemyNum).path(199).y := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy4.y
            enemy(enemyNum).count := 198
            loop/*
                put "enemyNum ",enemyNum..
                put ' count' ,enemy(enemyNum).count..
                put  " x val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                put " y val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y..
                put " Goal X: ", goalX..
                put " Y: ", goalY..
                put " Goal X: ",enemy(enemyNum).goal.x..
                put" Y: ",enemy(enemyNum).goal.y..
                put " current X: ",enemy(enemyNum).path(enemy(enemyNum).count+1).x..
                put " Y: ",enemy(enemyNum).path(enemy(enemyNum).count+1).y
                put "Grid at current X: ", grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                put "Y: ", grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y..
                put contains(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y,4,'searched')
                View.Update
                delay(100)*/
                enemy(enemyNum).path(enemy(enemyNum).count).x := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy4.x
                enemy(enemyNum).path(enemy(enemyNum).count).y := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy4.      y
                enemy(enemyNum).count -= 1
                if enemy(enemyNum).path(enemy(enemyNum).count+1).x = enemy(enemyNum).start.x and 
                        enemy(enemyNum).path(enemy(enemyNum).count+1).y = enemy(enemyNum).start.y then
                    exit
                end if
            end loop
        end if
        
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            %enemy(enemyNum).firstMove := counter
            enemy(enemyNum).enemyPath := true
            %newPath := true
            %pathing := true
            resetAStar(enemyNum)
            enemy(enemyNum).count := enemy(enemyNum).count + 1
            enemy(enemyNum).pLast.x := -1
            enemy(enemyNum).pLast.y := -1
            enemy(enemyNum).status := "searching"
            enemy(enemyNum).noiseSearch := false
        end if
    end if
    end if
end aStar