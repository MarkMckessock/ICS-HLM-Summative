% Sets all elements to 0 to see when the array elements start
proc reset_game_vars
    for i : 1 .. num_enemies
        set_enemy_room
        enemy(i).count := 1
        enemy(i).dead := false
        enemy(i).pLast.x := -1
        enemy(i).pLast.y := -1
        enemy(i).shootDelay := 0
        enemy(i).shooting := false
        enemy(i).status := "neutral"
        enemy(i).noiseSearch := false
        enemy(i).setPlayerPos := true
        enemy(i).initialize := true
        enemy(i).newPath := false
        enemy(i).eyesOn := false
        enemy(i).bulletPos.x := enemy(i).x
        enemy(i).bulletPos.y := enemy(i).y
        enemy(i).enemyRoom := "null"
        enemy(i).timeOnTarget := 0
        enemy(i).enemyPath := false
        enemy(i).init_shoot_dir := true
        enemy(i).death_animation := Rand.Int(1,4)
        accept_input := true
        end_animate := false
        resetAStar(i)
        enemy(i).moveDirection := "null"
        for j : 1 .. upper(enemy(i).path)
            enemy(i).path(j).x := 0
            enemy(i).path(j).y := 0
        end for
    end for
    bulletPos(1).x := maxx div 2
    bulletPos(1).y := maxy div 2
    start_time := Time.Elapsed
    camera.x := -930
    camera.y := 300
    colorback(purple)
    View.Set("offscreenonly")
end reset_game_vars
reset_game_vars