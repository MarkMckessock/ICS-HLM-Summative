View.Set("graphics:800,600")
type coordinate:
record
    x : int
    y : int
end record
type box:
record
    start : boolean
    goal : boolean
    parent : int
    leftB  : coordinate
    rightB : coordinate
    leftT  : coordinate
    rightT : coordinate
    wall   : boolean
end record
type arrayElement:
record
    a : int
    b : int
    fScore : int
end record
var loops : int := 0
var openX,openY : int
var start,goal : coordinate
var initialize : boolean := true
var grid : array 1..10,1..10 of box
var q : flexible array 1 .. 0 of arrayElement
var closedQ : flexible array 1 .. 0 of arrayElement
var x1 : int := 100
var x2 : int := 200
var y1 : int := 100
var y2 : int := 500
for i : 1 .. 10
    for j : 1 .. 10
        grid(i,j).wall := false
        grid(i,j).start := false
        grid(i,j).goal := false
    end for
end for
proc draw
    for i : 1 .. 10
        for j : 1 .. 10
            grid(i,j).leftB.y := i*50-50
            grid(i,j).leftB.x := j*50-50
            grid(i,j).rightB.y := i*50-50
            grid(i,j).rightB.x := j*50
            grid(i,j).rightT.y := i*50
            grid(i,j).rightT.x := j*50
            grid(i,j).leftT.y := i*50
            grid(i,j).leftT.x :=j*50-50
            if (grid(i,j).leftB.x > x1 and grid(i,j).leftB.y > y1 and grid(i,j).leftB.x < x2  and grid(i,j).leftB.y < y2) or (grid(i,j).rightB.x > x1 and grid(i,j).rightB.y > y1 and grid(i,j).rightB.x < x2 and grid(i,j).rightB.y < y2) or (grid(i,j).leftT.x > x1 and grid(i,j).leftT.y > y1 and grid(i,j).leftT.x < x2  and grid(i,j).leftT.y < y2) or (grid(i,j).rightT.x > x1 and grid(i,j).rightT.y > y1 and grid(i,j).rightT.x < x2  and grid(i,j).rightT.y < y2)then
                grid(i,j).wall := true
            end if
            Draw.Box(i*50-50,j*50-50,i*50,j*50,black)
        end for
    end for
end draw
draw
grid(4,5).wall := true
grid(4,6).wall := true
grid(4,7).wall := true
%function aStar(startX,startY,goalX,goalY:int): array 1 .. 100  of arrayElement
function contains (x,y : int) : boolean
    for i : 1 .. upper(closedQ)
        if closedQ(i).a = x and closedQ(i).b = y then
            result true
        end if
    end for
        result false
end contains
proc aStar(startX,startY,goalX,goalY:int)
    if initialize then
        for i : 1 .. upper(grid,1)
            for j : 1 .. upper(grid,2)
                if startX > grid(i,j).leftB.x and startX < grid(i,j).rightB.x and startY > grid(i,j).leftB.y and startY < grid(i,j).leftT.y then
                    start.x := i
                    start.y := j
                    grid(i,j).start := true
                    new q, upper(q)+1
                    q(upper(q)).a := i
                    q(upper(q)).b := j
                elsif goalX > grid(i,j).leftB.x and goalX < grid(i,j).rightB.x and goalY > grid(i,j).leftB.y and goalY < grid(i,j).leftT.y then
                    grid(i,j).goal := true
                    goal.x := i
                    goal.y := j
                end if
            end for
        end for
            initialize := false
    end if
    %Open first item in queue and remove from list
    openX := q(lower(q)).a
    openY := q(lower(q)).b
    new closedQ, upper(closedQ) + 1
    closedQ(upper(closedQ)) := q(lower(q))
    for i : 2 .. upper(q)
        q(i-1) := q(i)
    end for
        new q, upper(q)-1
    cls
    draw
    Draw.FillBox(grid(openX,openY).leftB.x,grid(openX,openY).leftB.y,grid(openX,openY).rightT.x,grid(openX,openY).rightT.y,yellow)
    
    %Add surrounding tiles to queue
    %Up Tile
    put "A", contains(openX+1,openY)
    if openX+1 <= upper(grid,1) then
        if grid(openX+1,openY). wall = false and contains(openX+1,openY) = false then
            new q, upper(q) + 1
            q(upper(q)).a := openX + 1
            q(upper(q)).b := openY
            q(upper(q)).fScore := round( 2*(abs((openX+1)-goal.x) + abs(openY-goal.y)) + (abs((openX+1)-start.x) + abs(openY-start.y)))
        end if
    end if
    %Down Tile
    put "B",contains(openX-1,openY)
    if openX-1 >= 1 then
        if grid(openX-1,openY). wall = false and contains(openX-1,openY) = false then
            new q, upper(q) + 1
            q(upper(q)).a := openX - 1
            q(upper(q)).b := openY
            q(upper(q)).fScore := round( 2*(abs((openX-1)-goal.x) + abs(openY-goal.y)) + (abs((openX-1)-start.x) + abs(openY-start.y)))
        end if
    end if
    %Left Tile
    put "C",contains(openX,openY+1)
    if openY+1 <= upper(grid,2) then
        if grid(openX,openY+1). wall = false and contains(openX,openY+1) = false then
            new q, upper(q) + 1
            q(upper(q)).a := openX
            q(upper(q)).b := openY + 1
            q(upper(q)).fScore := round( 2*(abs(openX-goal.x) + abs((openY+1)-goal.y)) + (abs(openX-start.x) + abs((openY+1)-start.y)))
        end if
    end if
    %Right Tile
    put "D",contains(openX,openY-1)
    if openY-1 >= lower(grid,1) then            
        if grid(openX,openY-1). wall = false and contains(openX,openY-1) = false then
            new q, upper(q) + 1
            q(upper(q)).a := openX
            q(upper(q)).b := openY - 1
            q(upper(q)).fScore := round( 2*(abs(openX-goal.x) + abs((openY-1)-goal.y)) + (abs(openX-start.x) + abs((openY-1)-start.y)))
        end if
    end if
    %Sort
    var temp : arrayElement
    for a : 1 .. upper(q)
        for i : 1 .. (upper(q)-1)
            if q(i).fScore > q(i+1).fScore then
                temp := q(i)
                q(i) := q(i+1)
                q(i+1) := temp
            end if
        end for
    end for
        if openX = goal.x and openY = goal.y then
        put Time.Elapsed
        put loops
        quit
    end if
end aStar

    loop
        loops += 1
    delay(500)
    aStar(51,201,401,301)
    
    for i : 1.. upper(q)
        locate(i,70)
        put q(i).fScore, " ", q(i).a, " ",q(i).b
    end for
    for i : 1.. upper(closedQ)
        locate(i,80)
        put closedQ(i).a," ",closedQ(i).b
    end for
    for i : 1 .. 10
        for j : 1 .. 10
            if grid(i,j).wall then
                Draw.FillBox(grid(i,j).leftB.x,grid(i,j).leftB.y,grid(i,j).rightT.x,grid(i,j).rightT.y,black)
            elsif grid(i,j).start then
                Draw.FillBox(grid(i,j).leftB.x,grid(i,j).leftB.y,grid(i,j).rightB.x,grid(i,j).rightT.y,blue)
            elsif grid(i,j).goal then
                Draw.FillBox(grid(i,j).leftB.x,grid(i,j).leftB.y,grid(i,j).rightB.x,grid(i,j).rightT.y,green)
            end if
        end for
    end for
end loop
