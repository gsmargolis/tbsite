module UsersHelper
  
  # This version is for the controller
  def self.get_wins_needed(playerwins, playergames, leaderwins, leadergames, leadernewwins, nextweeksgames)
    player_at_zero = playerwins.to_f / (playergames.to_f + nextweeksgames.to_f)
    leader_at_zero = leaderwins.to_f / (leadergames.to_f + nextweeksgames.to_f)
    player_per_win = 1.to_f / (playergames.to_f + nextweeksgames.to_f)
    leader_per_win = 1.to_f / (leadergames.to_f + nextweeksgames.to_f)
    win_per_diff = leader_at_zero - player_at_zero
    wins_to_get_even_at_zero = win_per_diff / player_per_win
    
    (((leader_per_win * leadernewwins.to_f) / player_per_win) + wins_to_get_even_at_zero).round(2)

  end
  
  # This is the version for the views
  def get_wins_needed(playerwins, playergames, leaderwins, leadergames, leadernewwins, nextweeksgames)
    player_at_zero = playerwins.to_f / (playergames.to_f + nextweeksgames.to_f)
    leader_at_zero = leaderwins.to_f / (leadergames.to_f + nextweeksgames.to_f)
    player_per_win = 1.to_f / (playergames.to_f + nextweeksgames.to_f)
    leader_per_win = 1.to_f / (leadergames.to_f + nextweeksgames.to_f)
    win_per_diff = leader_at_zero - player_at_zero
    wins_to_get_even_at_zero = win_per_diff / player_per_win
    
    (((leader_per_win * leadernewwins.to_f) / player_per_win) + wins_to_get_even_at_zero).round(2)

  end
  
  def get_player_stats(player_id)
    #weekinfo = get_week_info
    #for i in 1..weekinfo.size-1
      #if (Game.where(weeknum: i).max { |x,y| x[:gamedt] <=> y[:gamedt] }[:gamedt]) < (DateTime.current.beginning_of_week(start_day = :tuesday))
        #lastfullweek = i
      #end
    #end
    #playerlist = get_division_list(nil, :week => lastfullweek)
    lastfullweek = get_lastfullweek
    if lastfullweek == 0
      lastfullweek = 1
    end
    playerlist = read_view("lastfullweek", nil)
    playerdata = playerlist.select { |pd| pd[:player_id] == player_id}
    divisiondata =  playerlist.select { |ld| ld[:division] == playerdata[0][:division] }
    leaderdata = divisiondata.first
    #leaderdata = playerlist.select { |ld| ld[:division] == playerdata[0][:division] }.first
    playerwinseries = playerdata[0][:weeklydata][1..(playerdata[0][:weeklydata].size-1)].each_with_index.map{ |pdw,i| ["Week" + (i+1).to_s, (pdw != nil)? pdw[:wins] : 0 ] }  
    
    avgwinseries = []
    avgweeks = []
    divwinseries =  []
    divweeks = []
    overstat = 0
    understat = 0
    equalstat = 0
    weekplayers = [[0,0,0]]
    playerlist.each do |pl|
      
      #get chart data
      for i in 1..lastfullweek

        if pl[:weeklydata][i] != nil

          #get overall average chart data
          (avgweeks[i] != nil)? avgweeks[i][0] += pl[:weeklydata][i][:wins] : avgweeks[i] = [pl[:weeklydata][i][:wins],0,0]
          avgweeks[i][1] += 1
          avgweeks[i][2] = (avgweeks[i][0].to_f / avgweeks[i][1].to_f).round(2)
          
          #get division average chart data
          if pl[:division] == playerdata[0][:division]
            (divweeks[i] != nil)? divweeks[i][0] += pl[:weeklydata][i][:wins] : divweeks[i] = [pl[:weeklydata][i][:wins],0,0]
            divweeks[i][1] += 1
            divweeks[i][2] = (divweeks[i][0].to_f / divweeks[i][1].to_f).round(2)
          end
          
          #get mnf points overunder chart data
          if pl[:player_id] == player_id
            (pl[:weeklydata][i][:points].to_i > pl[:weeklydata][i][:mnfpts])? overstat += 1 : (pl[:weeklydata][i][:points].to_i == pl[:weeklydata][i][:mnfpts])? equalstat += 1 : understat += 1
          end
        end
      end
    end
 
    avgwinseries = avgweeks[1..(avgweeks.size-1)].each_with_index.map { |aw,i| ["Week" + (i+1).to_s, aw[2]] }
    divwinseries = divweeks[1..(divweeks.size-1)].each_with_index.map { |dw,i| ["Week" + (i+1).to_s, dw[2]] }
    mnfseries = {"Over" => overstat, "On The Nose" => equalstat, "Under" => understat}
    
    return playerwinseries, avgwinseries, divwinseries, mnfseries, playerdata, leaderdata, divisiondata, lastfullweek
  #seriesa = playerlist.map { |x| [x[:playername], x[:wins]] }
  #seriesb = playerlist.map { |x| [x[:playername], 5] }
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
