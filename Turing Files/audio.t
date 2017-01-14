% Audio Interface

process play_audio(track_name : string)
    if track_name = "Game" then
        Music.PlayFileLoop("../_audio/vengeance.mp3")
    elsif track_name = "gunshot" then
        Music.PlayFile("../_audio/shotgunFire.mp3")
        Music.PlayFile("../_audio/shotgunReload.mp3")
    elsif track_name = "menu" then
        Music.PlayFileLoop("../_audio/paris.mp3")
    end if
end play_audio