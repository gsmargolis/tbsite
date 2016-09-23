module UsersHelper
  
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
  
  def division_rank(player_id)
    
    # count players with lower winning percentage and add one
    # User.where("points > ?", points).count + 1

  end
  
  def avg_wins_per_week(player_id)
    # get array of players contianing an array of weekly wins (nil for non picking weeks)
    # divide the total wins by the number of weeks picked
  end
  
  def avg_wins_pw_div(division)
    # get array of players contianing an array of weekly wins (nil for non picking weeks)
    # For each week, sum the wins of the players that picked and divide by the number of players that picked
  end
  
  def playoff_pos(player_id)
    # Create an array of conference players sorted by winning percentage, then wins, then sphincters ascending
    # use ranking algorithm to determine rank from top.
    # Find top ranked players in each division.
    # if player is top ranked player, assign "Division Winner"
    # remove one of the top ranked players from each division.
    # Take the next four ranked players and any players tied with the fourth player taken.
    # if player is in the list, player is a wild card.
    # Determine how many players are tied with the player and add "Tied, pending coin toss" to rank if needed.
  end
  
  
end
