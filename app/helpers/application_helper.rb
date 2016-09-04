module ApplicationHelper
  def get_winners(weeknumber)
     winners = []
     @games = Game.where(weeknum: weeknumber)
     @games.each do |g|
        if g[:awayscore] != g[:homescore] + g[:line]
          winner = (g[:awayscore] >= g[:homescore] + g[:line])? g[:awayteam] : g[:hometeam]
          winners << winner
        end
     end
     winners
  end
  
  def get_picks(weeknumber)
    picks = []
    players = Player.all
    players.each do |p|
      pickrow, wins = get_player_picks_wins(p.id, weeknumber)
      picks << {:player => p.playername, :htmlrow => pickrow, :wins => wins}
    end
    return picks.sort_by { |w| -w[:wins] }, picks.max { |w,z| w[:wins] <=> z[:wins]}[:wins], picks.min { |w,z| ((w[:wins] == 0)? 100 : w[:wins]) <=> ((z[:wins] == 0)? 100 : z[:wins])}[:wins] 
  end
  
  def get_player_picks_wins(player_id, weeknumber)
    wins = 0
    winners = get_winners(weeknumber)
    returnarray = []
    picks = Pick.where(player_id: player_id, weeknum: weeknumber).order(:game_id)
    pickrow = ""
    picks.each do |p|
      winlose = (winners.include? p.gamepick)? "winteam" : "loseteam"
      winlose = (p.picktype == "Points")? "" : winlose
      pickrow = pickrow + "<td class=\"" + winlose + "\">" + p.gamepick + "</td>"
      wins = wins + ((winners.include? p.gamepick)? 1 : 0)
    end
    return pickrow, wins
  end

   def get_games(weeknumber)
    gamelist = {}
    winners = get_winners(weeknumber)
    @games = Game.where(weeknum: weeknumber).order(:id)
    @games.each do |g|
      gamerow = ""
      awayclass = (winners.include? g.awayteam)? "winteam" : "loseteam"
      homeclass = (winners.include? g.hometeam)? "winteam" : "loseteam"
      gamerow = "<table class=\"noborder\">"
      gamerow = gamerow + "<tr>"
      gamerow = gamerow + "       <th class=\"lefthead noborder " + awayclass + "\">" + g.awayteam + "</th>"
      gamerow = gamerow + "        <th class=\"rightalign noborder " + awayclass + "\">" + g.awayscore.to_s + "</th>"
      gamerow = gamerow + "     </tr> "
      gamerow = gamerow + "     <tr>"
      gamerow = gamerow + "       <th class=\"lefthead noborder " + homeclass + "\">" + g.hometeam + "</th>"
      gamerow = gamerow + "       <th class=\"rightalign noborder " + homeclass + "\">" + g.homescore.to_s + "</th>"
      gamerow = gamerow + "       <th class=\"rightalign noborder\">(" + ((g.line == g.line.to_i)? g.line.to_i.to_s : g.line.to_s) + ")</th>"
      gamerow = gamerow + "     </tr>"
      gamerow = gamerow + "   </table>"
      gamelist[g.id] = gamerow
    end
    gamelist
  end
  
  
  def get_mnf_pts(weeknumber)
    mnfgame = Game.find_by(weeknum: weeknumber, ismnf: true)
    mnfpoints = mnfgame.awayscore + mnfgame.homescore
    mnfpoints
  end
end
