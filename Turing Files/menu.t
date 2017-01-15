% Main and Score Menu

proc get_char (var field : string) 
    var ch : string(1)
    getch(ch)
    if ord(ch) = 8 then
        if length(field) > 0 then
            field := field(1..(length(field)-1))
            cls
            Pic.Draw(background_img,0,0,0)
        end if
    elsif ord(ch) = 10 then
        type_exit:=true
    else
        field += ch
        cls
        Pic.Draw(background_img,0,0,0)
    end if
end get_char

proc score_screen(mode:string)
    type_exit := false
    View.Set("offscreenonly")
    Sprite.Hide(background_slider_sprite)
    Sprite.Hide(player)
    for i : 1 .. num_enemies
        Sprite.Hide(enemy(i).SPR)
        Sprite.Hide(enemy(i).bullet)
    end for
    Sprite.Show(scores_sprite)
    Sprite.Hide(bulletSPR)
    Sprite.Hide(player)
    Sprite.Hide(logo_sprite)
    Sprite.Hide(play_sprite)
    Sprite.Hide(background_img_sprite)
    Sprite.Hide(van_sprite)
    Sprite.SetPosition(scores_sprite,maxx div 2+200,maxy - 50,true)
    Sprite.Hide(quit_sprite)
    Pic.Draw(background_img,0,0,0)
    var key_delay : int := Time.Elapsed
    var file_num : int
    open : file_num,"save_data/hot_data",read
        read : file_num,scores
    close : file_num
    if mode = "win" then
        if scores(11).player_first_name = 'null' then
            scores(11).player_first_name := ""
        end if
        if scores(11).player_last_name = 'null' then
            scores(11).player_last_name := ""
        end if
        scores(11).miliseconds := level_time
        if scores(11).miliseconds < 1000 then
            scores(11).time_string :=  "00:00:"+intstr(scores(11).miliseconds)
        elsif scores(11).miliseconds < 60000 then
            scores(11).time_string := "00:"+intstr(scores(11).miliseconds div 1000)+":"+ intstr((scores(11).miliseconds-(scores(11).miliseconds div 1000)*1000))
        elsif scores(11).miliseconds > 60000 then
            if scores(11).miliseconds -((scores(11).miliseconds div 60000) * 60000) < 10000 then
                if ((scores(11).miliseconds div 60000) * 60000) < 10 then
                    scores(11).time_string := "0"+intstr(scores(11).miliseconds div 60000)+":0"+intstr((scores(11).miliseconds -((scores(11).miliseconds div 60000) * 60000))div 1000)+":"+ intstr((scores(11).miliseconds-(scores(11).miliseconds div 1000)*1000))
                else
                    scores(11).time_string := intstr(scores(11).miliseconds div 60000)+":0"+intstr((scores(11).miliseconds -((scores(11).miliseconds div 60000) * 60000))div 1000)+":"+ intstr((scores(11).miliseconds-(scores(11).miliseconds div 1000)*1000))
                end if
            else
                if ((scores(11).miliseconds div 60000) * 60000) < 10 then
                    scores(11).time_string := "0"+intstr(scores(11).miliseconds div 60000)+":"+intstr((scores(11).miliseconds -((scores(11).miliseconds div 60000) * 60000))div 1000)+":"+ intstr((scores(11).miliseconds-(scores(11).miliseconds div 1000)*1000))
                else
                    scores(11).time_string := intstr(scores(11).miliseconds div 60000)+":"+intstr((scores(11).miliseconds -((scores(11).miliseconds div 60000) * 60000))div 1000)+":"+ intstr((scores(11).miliseconds-(scores(11).miliseconds div 1000)*1000))
                end if
            end if
        end if
        loop
            Sprite.SetPosition(scores_sprite,maxx div 2,maxy - 50,true)
            Font.Draw(scores(11).player_first_name,maxx div 2-100,maxy div 2 + 100,font2,blue)
            Font.Draw("Please enter your first name: ",maxx div 2-400,maxy div 2+200,font2,black)
            get_char(scores(11).player_first_name)
            if type_exit = true then
                type_exit := false
                exit 
            end if
        end loop
            cls
            Pic.Draw(background_img,0,0,0)
        loop
            Font.Draw(scores(11).player_last_name,maxx div 2-100,maxy div 2 + 100,font2,blue)
            Font.Draw("Please enter your last name: ",maxx div 2-400,maxy div 2+200,font2,black)
            get_char(scores(11).player_last_name)
            if type_exit = true then
                type_exit := false
                exit 
            end if
        end loop
         for cycles : 1 .. 11
        for items : 1 .. 10
            if scores(items).miliseconds > scores(items+1).miliseconds then
                var temp : score := scores(items)
                scores(items) := scores(items+1)
                scores(items+1) := temp
            end if
        end for
    end for
    open : file_num, "save_data/hot_data", write
        write : file_num, scores
    close : file_num
    end if
    cls
    Sprite.SetPosition(scores_sprite,maxx div 2+200,maxy - 50,true)
    Pic.Draw(background_img,0,0,0)
    Font.Draw("Name:    Time:",50,maxy - 110,font2,black)
    Font.Draw("___________________________________________",0,maxy - 120,font2,black)
    for i : 1..11
        if scores(i).player_first_name ~= "null" then
            Font.Draw(scores(i).player_first_name,50,maxy-30*i-130,font1,white)
            Font.Draw(scores(i).time_string,400,maxy-30*i-130,font1,white)
        end if
    end for
    Font.Draw("Press 'esc' to return to menu.",0,0,font3,black)
    loop
        Input.KeyDown(chars)
        if chars(KEY_ESC) then
            menu_selection := 1
            exit
        end if
    end loop
end score_screen
var new_game : boolean := true

proc main_menu
    fork play_audio("menu")
    var logo_frame_count : int := 1
    var logo_increase : boolean := true
    Sprite.Hide(player)
    Sprite.Hide(enemy(1).SPR)
    Sprite.Hide(enemy(2).SPR)
    Sprite.Hide(enemy(3).SPR)
    Sprite.Hide(enemy(4).SPR)
    Sprite.Hide(bulletSPR)
    Sprite.Hide(enemy(1).bullet)
    Sprite.Hide(enemy(2).bullet)
    Sprite.Hide(enemy(3).bullet)
    Sprite.Hide(enemy(4).bullet)
    Sprite.SetPosition(scores_sprite,maxx div 2, maxy div 2-25,true)

    menu_selection := 1
    colorback(red)
    cls
    var logo_frame_time : int := Time.Elapsed
    var background_frame_time : int := Time.Elapsed
    loop
        Sprite.Show(background_slider_sprite)
        Sprite.Show(background_img_sprite)
        Sprite.Show(logo_sprite)
        Sprite.Show(play_sprite)
        Sprite.Show(scores_sprite)
        Sprite.Show(quit_sprite)
        Input.KeyDown(chars)
        Sprite.ChangePic(logo_sprite,logo_pics(logo_frame_count))
        Sprite.ChangePic(background_slider_sprite,background_pics(background_frame))
        if menu_selection = 1 then
            Sprite.ChangePic(play_sprite,play_selected_pics(logo_frame_count))
            Sprite.ChangePic(scores_sprite,scores_unselected_pics(logo_frame_count))
            Sprite.ChangePic(quit_sprite,quit_unselected_pic)
        elsif menu_selection = 2 then
            Sprite.ChangePic(play_sprite,play_unselected_pics(logo_frame_count))
            Sprite.ChangePic(scores_sprite,scores_selected_pics(logo_frame_count))
            Sprite.ChangePic(quit_sprite,quit_unselected_pic)
        elsif menu_selection = 3 then
            Sprite.ChangePic(play_sprite,play_unselected_pics(logo_frame_count))
            Sprite.ChangePic(scores_sprite,scores_unselected_pics(logo_frame_count))
            Sprite.ChangePic(quit_sprite,quit_selected_pic)                
        end if
        if Time.Elapsed - logo_frame_time > 100 then
            logo_frame_time := Time.Elapsed
            if logo_increase then
                logo_frame_count += 1
            else 
                logo_frame_count -= 1
            end if
        end if
        if logo_frame_count = 85 then
            logo_increase := false
        elsif logo_frame_count = 1 then
            logo_increase := true
        end if
        if Time.Elapsed - background_frame_time > 100 then
            background_frame_time := Time.Elapsed
            background_frame += 1
        end if
        if background_frame = num_frames_background then
            background_frame := 1
        end if
        if chars(KEY_DOWN_ARROW) and Time.Elapsed - menu_time > 300 then
            menu_time := Time.Elapsed
            if menu_selection = 3 then
                menu_selection := 1
            else
                menu_selection += 1
            end if
        elsif chars(KEY_UP_ARROW) and Time.Elapsed - menu_time > 300 then
            menu_time := Time.Elapsed
            if menu_selection = 1 then
                menu_selection := 3
            else
                menu_selection -= 1
            end if
        end if
        if menu_selection = 1 and chars(KEY_ENTER) then
            new_game := true
            %Randomize game
            for i : 1 .. num_enemies
                resetAStar(i)
            end for
            reset_game_vars
            start_time := Time.Elapsed
            exit
        elsif menu_selection =2 and chars(KEY_ENTER) then
            score_screen('null')
            Sprite.SetPosition(scores_sprite,maxx div 2, maxy div 2-25,true)
        elsif menu_selection = 3 and chars(KEY_ENTER) then
            Window.Hide(Window.GetActive)
            quit
        end if
    end loop
    %loop
    %mousewhere(mousex,mousey,button)
    %end loop
end main_menu
main_menu