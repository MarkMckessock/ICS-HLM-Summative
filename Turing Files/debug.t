% Debug Mode
if debug then
    if chars('1') then
        enemy(1).dead := true
    elsif chars('2') then
        enemy(2).dead := true
    elsif chars('3') then
        enemy(3).dead := true
    elsif chars('4') then
        enemy(4).dead := true
    end if
    Font.Draw("Enemy #1: ",0,maxy-20,font1,white)
    Font.Draw("Position: X: "+intstr(enemy(1).x) + " Y: " + intstr(enemy(1).y),0,maxy-40,font1,white)
    Font.Draw("Enemy Status: "+enemy(1).status,0,maxy-60,font1,white)
    if enemy(1).noiseSearch then
        Font.Draw("Enemy noiseSearch: true ", 0, maxy-80, font1, white)
    else
        Font.Draw("Enemy noiseSearch: false ", 0, maxy-80, font1, white)
    end if
    Font.Draw("Enemy room: " + enemy(1).enemyRoom,0,maxy-100,font1,white)
    if enemy(1).eyesOn then
        Font.Draw("Enemy 1 Eyes-on: true",0,maxy-120,font1,white) 
    else 
        Font.Draw("Enemy 1 Eyes-on: false",0,maxy-120,font1,white)
    end if
    Font.Draw(intstr(upper(enemy1Q)) + " items in Q",0,maxy-140,font1,white)
    Font.Draw(intstr(upper(enemy1Searched)) + " items in Searched",0,maxy-160,font1,white)
    Font.Draw("Current item in path: " + intstr(enemy(1).count),0,maxy-180,font1,white)
    if enemy(1).status = "searching" then
        Font.Draw("Next element in path: X: " + intstr(grid(enemy(1).path(enemy(1).count).x,enemy(1).path(enemy(1).count).y).leftB.x) + " Y: " + intstr(grid(enemy(1).path(enemy(1).count).x,enemy(1).path(enemy(1).count).y).leftB.y),0,maxy-200,font1,white)
    else
        Font.Draw("Not searching",0,maxy-200,font1,white)
    end if
    Font.Draw("Enemy count: " + intstr(enemy(1).count),0,maxy-220,font1,white)
    %Font.Draw("------------------------------",0,maxy-220,font1,black)
    Font.Draw("Enemy #2: ",0,maxy-240,font1,white)
    Font.Draw("Position: X: "+intstr(enemy(2).x) + " Y: " + intstr(enemy(2).y),0,maxy-260,font1,white)
    Font.Draw("Enemy Status: "+enemy(2).status,0,maxy-280,font1,white)
    if enemy(2).noiseSearch then
        Font.Draw("Enemy noiseSearch: true ", 0, maxy-300, font1, white)
    else
        Font.Draw("Enemy noiseSearch: false ", 0, maxy-300, font1, white)
    end if
    Font.Draw("Enemy room: " + enemy(2).enemyRoom,0,maxy-320,font1,white)
    if enemy(2).eyesOn then
            Font.Draw("Enemy 2 Eyes-on: true",0,maxy-340,font1,white) 
        else 
            Font.Draw("Enemy 2 Eyes-on: false",0,maxy-340,font1,white)
    end if
    Font.Draw(intstr(upper(enemy2Q)) + " items in Q",0,maxy-360,font1,white)
    Font.Draw(intstr(upper(enemy2Searched)) + " items in Searched",0,maxy-380,font1,white)
    Font.Draw("Current item in path: " + intstr(enemy(2).count),0,maxy-400,font1,white)
        if enemy(2).status = "searching" then
            Font.Draw("Next element in path: X: " + intstr(grid(enemy(2).path(enemy(2).count).x,enemy(2).path(enemy(2).count).y).leftB.x) + " Y: " + intstr(grid(enemy(2).path(enemy(2).count).x,enemy(2).path(enemy(2).count).y).leftB.y),0,maxy-420,font1,white)
        else
            Font.Draw("Not searching",0,maxy-420,font1,white)
        end if
        Font.Draw("Enemy count: " + intstr(enemy(2).count),0,maxy-440,font1,white)
        Font.Draw("Player Room " + playerRoom,0,400,font1,black)
        Font.Draw("Player X: " + intstr(maxx div 2 - camera.x) + " Y: " + intstr(maxy div 2 - camera.y),0,370,font1,white)
        Font.Draw("X: "+intstr(camera.x)+ " Y: "+intstr(camera.y),0,350,font1,white)
        Font.Draw("Val: "+intstr(1577+camera.x) + " " + intstr(maxx),0,330,font1,white)
    end if