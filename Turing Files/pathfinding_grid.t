proc draw
    for i : 1 .. 60
        for j : 1 .. 53
            grid(i,j).wall := false
            grid(i,j).start := false
            grid(i,j).goal := false
            grid(i,j).leftB.x := i*50-50
            grid(i,j).leftB.y := j*50-50
            grid(i,j).rightB.x := i*50
            grid(i,j).rightB.y := j*50-50
            grid(i,j).rightT.x := i*50
            grid(i,j).rightT.y := j*50
            grid(i,j).leftT.x := i*50-50
            grid(i,j).leftT.y :=j*50
            if collisionDetect(grid(i,j).leftB.x+camera.x, grid(i,j).leftB.y+camera.y,true)  or
                    collisionDetect(grid(i,j).rightB.x+camera.x,grid(i,j).rightB.y+camera.y,true) or
                    collisionDetect(grid(i,j).leftT.x+camera.x,grid(i,j).leftT.y+camera.y,true) or
                    collisionDetect(grid(i,j).rightT.x+camera.x,grid(i,j).rightT.y+camera.y,true) then
                grid(i,j).wall := true
            end if
        end for
    end for
end draw
draw