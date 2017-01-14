proc set_enemy_room
    enemy(1).start_room := Rand.Int(1,7)
    loop
        enemy(2).start_room := Rand.Int(1,7)
        exit when enemy(2).start_room ~= enemy(1).start_room
    end loop
    loop
        enemy(3).start_room := Rand.Int(1,7)
        exit when enemy(3).start_room ~= enemy(1).start_room and enemy(3).start_room ~= enemy(2).start_room
    end loop
    loop
        enemy(4).start_room := Rand.Int(1,7)
        exit when enemy(4).start_room ~= enemy(1).start_room and enemy(4).start_room ~= enemy(2).start_room and enemy(4).start_room ~= enemy(3).start_room
    end loop
    for enemy_num : 1 .. num_enemies
        if enemy(enemy_num).start_room = 1 then % Carbon
            enemy(enemy_num).x := Rand.Int(650,1340)
            enemy(enemy_num).y := Rand.Int(300,930)
        elsif enemy(enemy_num).start_room = 2 then % Wood
            enemy(enemy_num).x := Rand.Int(775,1340)
            enemy(enemy_num).y := Rand.Int(1020,1765)
        elsif enemy(enemy_num).start_room = 3 then % Long Vert Hall
            enemy(enemy_num).x := Rand.Int(1453,1756)
            enemy(enemy_num).y := Rand.Int(308,2155)
        elsif enemy(enemy_num).start_room = 4 then % Short Vert Hall
            enemy(enemy_num).x := Rand.Int(365,666)
            enemy(enemy_num).y := Rand.Int(1045,2155)
        elsif enemy(enemy_num).start_room = 5 then % Red
            enemy(enemy_num).x := Rand.Int(1867,2356)
            enemy(enemy_num).y := Rand.Int(308,1334)
        elsif enemy(enemy_num).start_room = 6 then % Purple
            enemy(enemy_num).x := Rand.Int(2467,2899)
            enemy(enemy_num).y := Rand.Int(1445,1765)
        elsif enemy(enemy_num).start_room = 7 then % Long Horz Hall
            enemy(enemy_num).x := Rand.Int(651,2899)
            enemy(enemy_num).y := Rand.Int(1876,2155)
        end if
    end for
end set_enemy_room  

function collisionDetect (x,y: int,character : boolean) : boolean %checks if the currect coordinates collide with a wall
    % Bottom, left Brick wall
    walls(1).x.lower := 560  + camera.x
    walls(1).x.upper := 1530 + camera.x
    walls(1).y.lower := 217  + camera.y
    walls(1).y.upper := 288  + camera.y
    % Left, Top wall of hardwood
    walls(2).x.lower := 686  + camera.x
    walls(2).x.upper := 750  + camera.x
    walls(2).y.lower := 1384 + camera.y
    walls(2).y.upper := 1857 + camera.y
    % Top Wall of hardwood 
    walls(3).x.lower := 686  + camera.x
    walls(3).x.upper := 1433 + camera.x
    walls(3).y.lower := 1785 + camera.y
    walls(3).y.upper := 1857 + camera.y
    % Top,Right wall of carbon
    walls(4).x.lower := 1071 + camera.x
    walls(4).x.upper := 1433 + camera.x
    walls(4).y.lower := 952  + camera.y
    walls(4).y.upper := 1025 + camera.y
    % Right, Top wall of hardwood room
    walls(5).x.lower := 1360 + camera.x
    walls(5).x.upper := 1433 + camera.x
    walls(5).y.lower := 1657 + camera.y
    walls(5).y.upper := 1857 + camera.y
    % Right, Bottom Wall of carbon room
    walls(6).x.lower := 1360 + camera.x
    walls(6).x.upper := 1433 + camera.x
    walls(6).y.lower := 217  + camera.y
    walls(6).y.upper := 578  + camera.y
    % Right, Top Wall of carbon room
    walls(7).x.lower := 1360 + camera.x
    walls(7).x.upper := 1433 + camera.x
    walls(7).y.lower := 665  + camera.y
    walls(7).y.upper := 1573 + camera.y
    % Bottom, Left wall of hardwood room
    walls(8).x.lower := 271  + camera.x
    walls(8).x.upper := 985  + camera.x
    walls(8).y.lower := 952  + camera.y
    walls(8).y.upper := 1025 + camera.y
    % Left, Bottom wall of hardwood room
    walls(9).x.lower := 686  + camera.x
    walls(9).x.upper := 750  + camera.x
    walls(9).y.lower := 952  + camera.y
    walls(9).y.upper := 1297 + camera.y
    % Left wall of carbon room
    walls(10).x.lower := 560  + camera.x
    walls(10).x.upper := 631  + camera.x
    walls(10).y.lower := 217  + camera.y
    walls(10).y.upper := 1025 + camera.y
    % Left-most wall
    walls(11).x.lower := 272  + camera.x
    walls(11).x.upper := 345  + camera.x
    walls(11).y.lower := 952  + camera.y
    walls(11).y.upper := 2247 + camera.y
    % Top, Left wall
    walls(12).x.lower := 272  + camera.x
    walls(12).x.upper := 1552 + camera.x
    walls(12).y.lower := 2175 + camera.y
    walls(12).y.upper := 2247 + camera.y
    % Top, Right wall
    walls(13).x.lower := 1637 + camera.x
    walls(13).x.upper := 2990 + camera.x
    walls(13).y.lower := 2175 + camera.y
    walls(13).y.upper := 2247 + camera.y
    % Bottom, Right Wall
    walls(14).x.lower := 1616 + camera.x
    walls(14).x.upper := 2449 + camera.x
    walls(14).y.lower := 217  + camera.y
    walls(14).y.upper := 288  + camera.y
    % Left, Bottom Wall of red room
    walls(15).x.lower := 1776 + camera.x
    walls(15).x.upper := 1849 + camera.x
    walls(15).y.lower := 217  + camera.y
    walls(15).y.upper := 993  + camera.y
    % Right Wall of red room
    walls(16).x.lower := 2375 + camera.x
    walls(16).x.upper := 2448 + camera.x
    walls(16).y.lower := 217  + camera.y
    walls(16).y.upper := 1425 + camera.y
    % Left, Top Wall of red room / Left wall of purple room
    walls(17).x.lower := 1776 + camera.x
    walls(17).x.upper := 1849 + camera.x
    walls(17).y.lower := 1080 + camera.y
    walls(17).y.upper := 1857 + camera.y
    % Left wall between red and purple room
    walls(18).x.lower := 1776 + camera.x
    walls(18).x.upper := 2129 + camera.x
    walls(18).y.lower := 1352 + camera.y
    walls(18).y.upper := 1425 + camera.y
    % Right wall between red and purple room
    walls(19).x.lower := 2217 + camera.x
    walls(19).x.upper := 2448 + camera.x
    walls(19).y.lower := 1352 + camera.y
    walls(19).y.upper := 1425 + camera.y
    % Top, Left wall of purple room
    walls(20).x.lower := 1776 + camera.x
    walls(20).x.upper := 2535 + camera.x
    walls(20).y.lower := 1784 + camera.y
    walls(20).y.upper := 1857 + camera.y
    % Top, Right wall of purple room
    walls(21).x.lower := 2632 + camera.x
    walls(21).x.upper := 2992 + camera.x
    walls(21).y.lower := 1784 + camera.y
    walls(21).y.upper := 1857 + camera.y
    % Right, Top wall of purple room
    walls(22).x.lower := 2917 + camera.x
    walls(22).x.upper := 2991 + camera.x
    walls(22).y.lower := 1673 + camera.y
    walls(22).y.upper := 2247 + camera.y
    % Right, Bottom wall of purple room
    walls(23).x.lower := 2917 + camera.x
    walls(23).x.upper := 2991 + camera.x
    walls(23).y.lower := 920  + camera.y
    walls(23).y.upper := 1584 + camera.y
    % Bottom wall of purple room
    walls(24).x.lower := 2377 + camera.x
    walls(24).x.upper := 2991 + camera.x
    walls(24).y.lower := 920  + camera.y
    walls(24).y.upper := 990  + camera.y
    % Top wall of elevator
    walls(25).x.lower := 1377 + camera.x
    walls(25).x.upper := 1829 + camera.x
    walls(25).y.lower := 2572 + camera.y
    walls(25).y.upper := 2604 + camera.y
    % Right wall of elevator
    walls(26).x.lower := 1377 + camera.x
    walls(26).x.upper := 1412 + camera.x
    walls(26).y.lower := 2175  + camera.y
    walls(26).y.upper := 2604 + camera.y
    % Left wall of elevator
    walls(27).x.lower := 1795 + camera.x
    walls(27).x.upper := 1829 + camera.x
    walls(27).y.lower := 2175  + camera.y
    walls(27).y.upper := 2604  + camera.y
    % Left side of van
    walls(28).x.lower := 1369 + camera.x
    walls(28).x.upper := 1575 + camera.x
    walls(28).y.lower := -120  + camera.y
    walls(28).y.upper := 110  + camera.y
    % Right side of van
    walls(29).x.lower := 1640 + camera.x
    walls(29).x.upper := 1846 + camera.x
    walls(29).y.lower := -120  + camera.y
    walls(29).y.upper := 110  + camera.y
    % Bottom of van
    walls(30).x.lower := 1575 + camera.x
    walls(30).x.upper := 1640 + camera.x
    walls(30).y.lower := -120  + camera.y
    walls(30).y.upper := -41  + camera.y
    
    postMove.x := x
    postMove.y := y
    if x = maxx div 2 and y = maxy div 2 then
        Input.KeyDown(key)
        for i : 1 .. upper(inputEffects)
            if key(inputEffects(i).input) then
                postMove.x -= inputEffects(i).effect.x
                postMove.y -= inputEffects(i).effect.y
            end if
        end for
    end if
    
    if character = false    then
        for i : 1 .. upper(walls)
            walls(i).x.lower += 20
            walls(i).x.upper -= 20
            walls(i).y.lower += 20
            walls(i).y.upper -= 20
        end for
    end if
    
    for i : 1 .. upper(walls) 
        if postMove.x > walls(i).x.lower and 
        postMove.x < walls(i).x.upper and 
        postMove.y >  walls(i).y.lower and 
        postMove.y < walls(i).y.upper then
            result true
        end if
    end for
        result false
end collisionDetect