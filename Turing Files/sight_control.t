% Control enemy 'sight' mechanics and keep track of player and enemy relative positions


proc sightCheck(enemyNum : int)
    if (enemy(enemyNum).enemyRoom = playerRoom) or 
    %Block for carbon room
        (enemy(enemyNum).enemyRoom = "carbon" and playerRoom = "CARBON2wood") or 
        (enemy(enemyNum).enemyRoom = "carbon" and playerRoom = "lvh2CARBON") or 
        (enemy(enemyNum).enemyRoom = "CARBON2wood" and playerRoom = "carbon") or 
        (enemy(enemyNum).enemyRoom = "lvh2CARBON" and playerRoom = "carbon") or
        (enemy(enemyNum).enemyRoom = "lvh2CARBON" and playerRoom = "CARBON2wood") or 
        (enemy(enemyNum).enemyRoom = "CARBON2wood" and playerRoom = "lvh2CARBON") or 
        (enemy(enemyNum).enemyRoom = "CARBON2wood" and playerRoom = "carbon2WOOD") or 
        (enemy(enemyNum).enemyRoom = "carbon2WOOD" and playerRoom = "CARBON2wood") or 
        (enemy(enemyNum).enemyRoom = "lvh2CARBON" and playerRoom = "LVH2carbon") or 
        (enemy(enemyNum).enemyRoom = "LVH2carbon" and playerRoom = "lvh2CARBON") or 
    %Block for Long vert Hall
        (enemy(enemyNum).enemyRoom = "longVertHall" and playerRoom = "LVH2red") or 
        (enemy(enemyNum).enemyRoom = "longVertHall" and playerRoom = "LVH2wood") or 
        (enemy(enemyNum).enemyRoom = "longVertHall" and playerRoom = "LVH2carbon") or 
        (enemy(enemyNum).enemyRoom = "longVertHall" and playerRoom = "intLVH&LHH") or 
        (enemy(enemyNum).enemyRoom = "LVH2red" and playerRoom = "longVertHall") or
        (enemy(enemyNum).enemyRoom = "LVH2red" and playerRoom = "LVH2wood") or
        (enemy(enemyNum).enemyRoom = "LVH2red" and playerRoom = "LVH2carbon") or
        (enemy(enemyNum).enemyRoom = "LVH2red" and playerRoom = "intLVH&LHH") or
        (enemy(enemyNum).enemyRoom = "LVH2carbon" and playerRoom = "longVertHall") or
        (enemy(enemyNum).enemyRoom = "LVH2carbon" and playerRoom = "LVH2wood") or
        (enemy(enemyNum).enemyRoom = "LVH2carbon" and playerRoom = "LVH2carbon") or
        (enemy(enemyNum).enemyRoom = "LVH2carbon" and playerRoom = "intLVH&LHH") or
        (enemy(enemyNum).enemyRoom = "LVH2wood" and playerRoom = "longVertHall") or
        (enemy(enemyNum).enemyRoom = "LVH2wood" and playerRoom = "LVH2carbon") or
        (enemy(enemyNum).enemyRoom = "LVH2wood" and playerRoom = "intLVH&LHH") or
        (enemy(enemyNum).enemyRoom = "LVH2wood" and playerRoom = "LVH2red") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "LVH2wood") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "LVH2red") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "LVH2carbon") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "longVertHall") or
    %Block for Wood room
        (enemy(enemyNum).enemyRoom = "wood" and playerRoom = "WOOD2svh") or
        (enemy(enemyNum).enemyRoom = "wood" and playerRoom = "carbon2WOOD") or
        (enemy(enemyNum).enemyRoom = "wood" and playerRoom = "lvh2WOOD") or
        (enemy(enemyNum).enemyRoom = "WOOD2svh" and playerRoom = "wood2SVH") or
        (enemy(enemyNum).enemyRoom = "wood2SVH" and playerRoom = "WOOD2svh") or
        (enemy(enemyNum).enemyRoom = "carbon2WOOD" and playerRoom = "CARBON2wood") or
        (enemy(enemyNum).enemyRoom = "CARBON2wood" and playerRoom = "carbon2WOOD") or
        (enemy(enemyNum).enemyRoom = "WOOD2svh" and playerRoom = "wood") or
        (enemy(enemyNum).enemyRoom = "WOOD2svh" and playerRoom = "carbon2WOOD") or
        (enemy(enemyNum).enemyRoom = "WOOD2svh" and playerRoom = "lvh2WOOD") or
        (enemy(enemyNum).enemyRoom = "carbon2WOOD" and playerRoom = "wood") or
        (enemy(enemyNum).enemyRoom = "carbon2WOOD" and playerRoom = "WOOD2svh") or
        (enemy(enemyNum).enemyRoom = "carbon2WOOD" and playerRoom = "lvh2WOOD") or
        (enemy(enemyNum).enemyRoom = "lvh2WOOD" and playerRoom = "wood") or
        (enemy(enemyNum).enemyRoom = "lvh2WOOD" and playerRoom = "WOOD2svh") or
        (enemy(enemyNum).enemyRoom = "lvh2WOOD" and playerRoom = "carbon2WOOD") or
    %Block for Long horizontal hall
        (enemy(enemyNum).enemyRoom = "longHorzHall" and playerRoom = "intLVH&LHH") or
        (enemy(enemyNum).enemyRoom = "longHorzHall" and playerRoom = "intSVH&LHH") or
        (enemy(enemyNum).enemyRoom = "longHorzHall" and playerRoom = "PURPLE2lhh") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "longHorzHall") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "intSVH&LHH") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "PURPLE2lhh") or
        (enemy(enemyNum).enemyRoom = "intSVH&LHH" and playerRoom = "longHorzHall") or
        (enemy(enemyNum).enemyRoom = "intSVH&LHH" and playerRoom = "PURPLE2lhh") or
        (enemy(enemyNum).enemyRoom = "intSVH&LHH" and playerRoom = "intLVH&LHH") or
        (enemy(enemyNum).enemyRoom = "purple2LHH" and playerRoom = "longHorzHall") or
        (enemy(enemyNum).enemyRoom = "purple2LHH" and playerRoom = "intLVH&LHH") or
        (enemy(enemyNum).enemyRoom = "purple2LHH" and playerRoom = "intSVH&LHH") or
    %Block for purple room
        (enemy(enemyNum).enemyRoom = "PurpleUpper" and playerRoom = "intPurple") or
        (enemy(enemyNum).enemyRoom = "PurpleUpper" and playerRoom = "red2PURPLE") or
        (enemy(enemyNum).enemyRoom = "PurpleUpper" and playerRoom = "PURPLE2lhh") or
        (enemy(enemyNum).enemyRoom = "intPurple" and playerRoom = "PurpleUpper") or
        (enemy(enemyNum).enemyRoom = "intPurple" and playerRoom = "PurpleLower") or
        (enemy(enemyNum).enemyRoom = "intPurple" and playerRoom = "PURPLE2lhh") or
        (enemy(enemyNum).enemyRoom = "intPurple" and playerRoom = "red2PURPLE") or
        (enemy(enemyNum).enemyRoom = "PurpleLower" and playerRoom = "intPurple") or
        (enemy(enemyNum).enemyRoom = "PurpleLower" and playerRoom = "PURPLE2lhh") or
        (enemy(enemyNum).enemyRoom = "PURPLE2red" and playerRoom = "PurpleUpper") or
        (enemy(enemyNum).enemyRoom = "PURPLE2red" and playerRoom = "intPurple") or
        (enemy(enemyNum).enemyRoom = "PURPLE2lhh" and playerRoom = "intPurple") or
        (enemy(enemyNum).enemyRoom = "PURPLE2lhh" and playerRoom = "PurpleUpper") or
        (enemy(enemyNum).enemyRoom = "PURPLE2lhh" and playerRoom = "PurpleLower") or
        (enemy(enemyNum).enemyRoom = "PURPLE2lhh" and playerRoom = "red2PURPLE") or
        (enemy(enemyNum).enemyRoom = "PURPLE2lhh" and playerRoom = "purple2LHH") or
        (enemy(enemyNum).enemyRoom = "LHH2purple" and playerRoom = "PURPLE2lhh") or
    %Block for red room
        (enemy(enemyNum).enemyRoom = "red" and playerRoom = "RED2purple") or
        (enemy(enemyNum).enemyRoom = "red" and playerRoom = "lvh2RED") or
        (enemy(enemyNum).enemyRoom = "RED2purple" and playerRoom = "red") or
        (enemy(enemyNum).enemyRoom = "RED2purple" and playerRoom = "lvh2RED") or
        (enemy(enemyNum).enemyRoom = "lvh2RED" and playerRoom = "red") or
        (enemy(enemyNum).enemyRoom = "lvh2RED" and playerRoom = "RED2purple") or
        (enemy(enemyNum).enemyRoom = "lvh2RED" and playerRoom = "LVH2red") or
        (enemy(enemyNum).enemyRoom = "LVH2red" and playerRoom = "lvh2RED") or
        (enemy(enemyNum).enemyRoom = "red2PURPLE" and playerRoom = "RED2purple") or
        (enemy(enemyNum).enemyRoom = "RED2purple" and playerRoom = "red2PURPLE") or
    %Block for Short vert Hall
        (enemy(enemyNum).enemyRoom = "shortVertHall" and playerRoom = "intSVH&LHH") or
        (enemy(enemyNum).enemyRoom = "shortVertHall" and playerRoom = "wood2SVH") or
        (enemy(enemyNum).enemyRoom = "intSVH&LHH" and playerRoom = "shortVertHall") or
        (enemy(enemyNum).enemyRoom = "intSVH&LHH" and playerRoom = "wood2SVH") or
        (enemy(enemyNum).enemyRoom = "wood2SVH" and playerRoom = "shortVertHall") or
        (enemy(enemyNum).enemyRoom = "wood2SVH" and playerRoom = "intSVH&LHH")
        then
        if enemy(enemyNum).moveDirection = "up" then
            if whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) > 0 and whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 180 then
                enemy(enemyNum).eyesOn := true
            else
                enemy(enemyNum).eyesOn := false
            end if
        elsif enemy(enemyNum).moveDirection = "right" then
            if whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 80 or whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) > 270 then
                enemy(enemyNum).eyesOn := true
            else
                enemy(enemyNum).eyesOn := false
            end if
        elsif enemy(enemyNum).moveDirection = "down" then
            if whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 360 and whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) > 180 then
                enemy(enemyNum).eyesOn := true
            else
                enemy(enemyNum).eyesOn := false
            end if
        elsif enemy(enemyNum).moveDirection = "left" then
            if whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) > 80 and whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 270 then
                enemy(enemyNum).eyesOn := true
            else
                enemy(enemyNum).eyesOn := false
            end if
        end if
    else
        enemy(enemyNum).eyesOn := false
    end if
end sightCheck

function roomAssign(x,y:int) :string
    if    x >= 1433+camera.x and x <= 1776+camera.x and y >= 1856+camera.y and y <= 2175+camera.y then
        result "intLVH&LHH"
    elsif x >= 1433+camera.x and x <= 1776+camera.x and y >= 578+camera.y  and y <= 665 +camera.y then
        result "LVH2carbon"
    elsif x >= 631+camera.x  and x <= 1432+camera.x and y >= 578+camera.y  and y <= 665 +camera.y then
        result "lvh2CARBON"
    elsif x >= 985+camera.x  and x <= 1071+camera.x and y >= 288+camera.y  and y <= 1019+camera.y then
        result "CARBON2wood"
    elsif x >= 985+camera.x  and x <= 1071+camera.x and y >= 1020+camera.y and y <= 1785+camera.y then
        result "carbon2WOOD"
    elsif x >= 347+camera.x  and x <= 683+camera.x  and y >= 1301+camera.y and y <= 1379+camera.y then
        result "wood2SVH"
    elsif x >= 684+camera.x  and x <= 1355+camera.x and y >= 1301+camera.y and y <= 1379+camera.y then
        result "WOOD2svh"
    elsif x >= 1427+camera.x  and x <= 1775+camera.x and y >= 1577+camera.y and y <= 1655+camera.y then
        result "LVH2wood"
    elsif x >= 755+camera.x and x <= 1426+camera.x and y >= 1577+camera.y and y <= 1655+camera.y then
        result "lvh2WOOD"
    elsif x >= 1776+camera.x and x <= 2375+camera.x and y >= 995+camera.y  and y <= 1079+camera.y then
        result "lvh2RED"
    elsif x >= 1433+camera.x and x <= 1775+camera.x and y >= 995+camera.y  and y <= 1079+camera.y then
        result "LVH2red"
    elsif x >= 2129+camera.x and x <= 2213+camera.x and y >= 1427+camera.y and y <= 1781+camera.y then
        result "red2PURPLE"
    elsif x >= 2129+camera.x and x <= 2213+camera.x and y >= 293+camera.y  and y <= 1426+camera.y then
        result "RED2purple"
    elsif x >= 2537+camera.x and x <= 2627+camera.x and y >= 995+camera.y  and y <= 1858+camera.y then
        result "PURPLE2lhh"
    elsif x >= 2537+camera.x and x <= 2627+camera.x and y >= 1859+camera.y and y <= 2177+camera.y then
        result "purple2LHH"
    elsif x >= 345+camera.x  and x <= 686+camera.x  and y >= 1856+camera.y and y <= 2175+camera.y then
        result "intSVH&LHH"
    elsif x >= 2447+camera.x and x <= 2918+camera.x and y >= 1425+camera.y and y <= 1785+camera.y then
        result "intPurple"
    elsif x >= 1413+camera.x and x <= 1776+camera.x and y >= 288+camera.y  and y <= 2175+camera.y then
        result "longVertHall"
    elsif x >= 631+camera.x  and x <= 1360+camera.x and y >= 288+camera.y  and y <= 952+camera.y  then
        result "carbon"
    elsif x >= 755+camera.x  and x <= 1360+camera.x and y >= 1000+camera.y and y <= 1785+camera.y then
        result "wood"
    elsif x >= 345+camera.x  and x <= 686+camera.x  and y >= 1025+camera.y and y <= 2175+camera.y then
        result "shortVertHall"
    elsif x >= 631+camera.x  and x <= 2918+camera.x and y >= 1856+camera.y and y <= 2175+camera.y then
        result "longHorzHall"
    elsif x >= 1847+camera.x and x <= 2376+camera.x and y >= 288+camera.y  and y <= 1354+camera.y then
        result "red"
    elsif x >= 1847+camera.x and x <= 2918+camera.x and y >= 1425+camera.y and y <= 1785+camera.y then
        result "purpleUpper"
    elsif x >= 2447+camera.x and x <= 2918+camera.x and y >= 922+camera.y  and y <= 1785+camera.y then
        result "purpleLower"
    else
        result "outside"
    end if
end roomAssign