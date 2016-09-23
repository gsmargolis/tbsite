module PlayersHelper
  
  def get_wins_needed(division)
    weekinfo = get_week_info
    for i in 1..weekinfo.size-1
      if (Game.where(weeknum: i).max { |x,y| x[:gamedt] <=> y[:gamedt] }[:gamedt]) < (DateTime.current.beginning_of_week(start_day = :tuesday))
        lastfullweek = i
      end
    end
    
    playerlist = get_division_list(division, :week => lastfullweek)
    div_leader = playerlist.first
    playerdata = playerlist.find { |x| x[:player_id] == @player.id }
    
    avg_wins = (div_leader[:wins].to_f / div_leader[:weeks].to_f)
    used_bye = (div_leader[:playerhtml].index("Bye",1) != nil)? true : false 
    leadinfo = { :name => div_leader[:playername], :winpercent => div_leader[:winpercent], :wins => div_leader[:wins], :weeks => div_leader[:weeks], :avgwins => avg_wins, :games => div_leader[:games], :bye => used_bye }
    
    avg_wins = (playerdata[:wins].to_f / playerdata[:weeks].to_f)
    used_bye = (div_leader[:playerhtml].index("Bye",1) != nil)? true : false 
    playerinfo = { :name => playerdata[:playername], :winpercent => playerdata[:winpercent], :wins => playerdata[:wins], :weeks => playerdata[:weeks], :avgwins => avg_wins, :games => playerdata[:games], :bye => used_bye }

    nextweekgames = get_weeks_games(lastfullweek + 1)
    if nextweekgames != nil
      
    end
    
    binding.pry
  end
  
  
end
