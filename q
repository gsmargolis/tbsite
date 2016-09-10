
[1mFrom:[0m /home/ubuntu/rails_projects/tbstatus/app/helpers/application_helper.rb @ line 67 ApplicationHelper#get_player_picks_wins:

    [1;34m53[0m: [32mdef[0m [1;34mget_player_picks_wins[0m(player_id, weeknumber)
    [1;34m54[0m:   wins = [1;34m0[0m
    [1;34m55[0m:   pts = [1;34m0[0m
    [1;34m56[0m:   winners, losers = get_winners(weeknumber)
    [1;34m57[0m:   returnarray = []
    [1;34m58[0m:   picks = [1;34;4mPick[0m.where([35mplayer_id[0m: player_id, [35mweeknum[0m: weeknumber).order([33m:game_id[0m)
    [1;34m59[0m:   pickrow = [31m[1;31m"[0m[31m[1;31m"[0m[31m[0m
    [1;34m60[0m:   picks.each [32mdo[0m |p|
    [1;34m61[0m:     winlose = [31m[1;31m"[0m[31m[1;31m"[0m[31m[0m
    [1;34m62[0m:     winlose = (winners.include? p.gamepick)? [31m[1;31m"[0m[31mwinteam[1;31m"[0m[31m[0m : (losers.include? p.gamepick)? [31m[1;31m"[0m[31mloseteam[1;31m"[0m[31m[0m : [31m[1;31m"[0m[31m[1;31m"[0m[31m[0m
    [1;34m63[0m:     [32mif[0m (p.picktype == [31m[1;31m"[0m[31mPoints[1;31m"[0m[31m[0m)
    [1;34m64[0m:       winlose = [31m[1;31m"[0m[31m[1;31m"[0m[31m[0m
    [1;34m65[0m:       pts = p.gamepick
    [1;34m66[0m:     [32mend[0m
 => [1;34m67[0m:     binding.pry
    [1;34m68[0m:     pickrow = pickrow + [31m[1;31m"[0m[31m<td class=[1;35m\"[0m[31m[1;31m"[0m[31m[0m + winlose + [31m[1;31m"[0m[31m[1;35m\"[0m[31m>[1;31m"[0m[31m[0m + p.gamepick + [31m[1;31m"[0m[31m</td>[1;31m"[0m[31m[0m
    [1;34m69[0m:     wins = wins + ((winners.include? p.gamepick)? [1;34m1[0m : [1;34m0[0m)
    [1;34m70[0m:   [32mend[0m
    [1;34m71[0m:     trophystyle = (award = [1;34;4mAward[0m.find_by([35mplayer_id[0m: player_id, [35mweeknum[0m: weeknumber))? award.awardtype : [31m[1;31m"[0m[31mpointstyle[1;31m"[0m[31m[0m
    [1;34m72[0m:     pickrow = (picks.size > [1;34m0[0m)? pickrow + [31m[1;31m"[0m[31m<td class=[1;35m\"[0m[31m[1;31m"[0m[31m[0m + trophystyle + [31m[1;31m"[0m[31m[1;35m\"[0m[31m>[1;31m"[0m[31m[0m + wins.to_s + [31m[1;31m"[0m[31m</td>[1;31m"[0m[31m[0m : pickrow + [31m[1;31m"[0m[31m<td class=[1;35m\"[0m[31m[1;31m"[0m[31m[0m + trophystyle + [31m[1;31m"[0m[31m[1;35m\"[0m[31m colspan=[1;35m\"[0m[31m20[1;35m\"[0m[31m>No Picks Submitted</td>[1;31m"[0m[31m[0m
    [1;34m73[0m:   [32mreturn[0m pickrow, wins, pts
    [1;34m74[0m: [32mend[0m

