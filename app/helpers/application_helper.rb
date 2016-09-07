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
  
  def set_trophies(weeknumber)
      
      Award.where(weeknum: weeknumber).destroy_all
      
      mnfpts = get_mnf_pts(weeknumber)
      picks, maxpts, minpts = get_picks(weeknumber)
      toppicks = picks.find_all { |p| p[:wins] == maxpts }
      bestmnf = toppicks.min { |x,y|  ((x[:pts].to_i - mnfpts).abs) <=> ((y[:pts].to_i - mnfpts).abs) }[:pts]
      toppicks.each do |tp|
        if (tp[:pts] == bestmnf) and (tp[:htmlrow].index("No Picks Submitted") == 0)
          trophy = Award.create(awardtype: "Trophy", weeknum: weeknumber, player_id: tp[:playerid])
        end
      end
      
      bottompicks = picks.find_all { |p| p[:wins] == minpts }
      worstmnf = bottompicks.max { |x,y|  ((x[:pts].to_i - mnfpts).abs) <=> ((y[:pts].to_i - mnfpts).abs) }[:pts]
      bottompicks.each do |bp|
        #puts bp[:player]
        if (bp[:pts] == worstmnf) && (bp[:pts] != bestmnf)
          trophy = Award.create(awardtype: "Sphincter", weeknum: weeknumber, player_id: bp[:playerid])
        end
      end
  end
  
  def get_picks(weeknumber)
    picks = []
    mnfpts = get_mnf_pts(weeknumber)
    players = Player.all
    players.each do |p|
      pickrow, wins, pts = get_player_picks_wins(p.id, weeknumber)
      picks << {:player => p.playername, :htmlrow => pickrow, :wins => wins, :pts => pts, :playerid => p.id}
    end
    return picks.sort_by { |w| [-w[:wins], ((w[:pts].to_i - mnfpts).abs)] }, picks.max { |w,z| w[:wins] <=> z[:wins]}[:wins], picks.min { |w,z| ((w[:wins] == 0)? 100 : w[:wins]) <=> ((z[:wins] == 0)? 100 : z[:wins])}[:wins] 
  end
  
  def get_player_picks_wins(player_id, weeknumber)
    wins = 0
    pts = 0
    winners = get_winners(weeknumber)
    returnarray = []
    picks = Pick.where(player_id: player_id, weeknum: weeknumber).order(:game_id)
    pickrow = ""
    picks.each do |p|
      winlose = (winners.include? p.gamepick)? "winteam" : "loseteam"
      if (p.picktype == "Points")
        winlose = ""
        pts = p.gamepick
      end
      pickrow = pickrow + "<td class=\"" + winlose + "\">" + p.gamepick + "</td>"
      wins = wins + ((winners.include? p.gamepick)? 1 : 0)
    end
      trophystyle = (award = Award.find_by(player_id: player_id, weeknum: weeknumber))? award.awardtype : "pointstyle"
      pickrow = (picks.size > 0)? pickrow + "<td class=\"" + trophystyle + "\">" + wins.to_s + "</td>" : pickrow + "<td class=\"" + trophystyle + "\" colspan=\"20\">No Picks Submitted</td>"
    return pickrow, wins, pts
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
  
  def get_week_info
    weekinfo = []
    picks = Pick.all
    maxweek = picks.max {|x,y| x[:weeknum] <=> y[:weeknum]}[:weeknum]
    for i in 1..maxweek
      trophies = []
      sphincters = []
      junk, maxpts, minpts = get_picks(i)
      Award.where(weeknum: i).each do |a|
        (a.awardtype == "Trophy")? (trophies << a.player_id) : (sphincters << a.player_id)
      end
      puts "----------------------------"
      weekinfo[i] = { :games => Game.where(weeknum: i).count, :minpts => minpts, :trophies => trophies, :sphincters => sphincters }
    end
    weekinfo
  end
  
  def get_division_list(division)
    weekinfo = get_week_info
    #totalgames = weekinfo.inject(0) {|sum,w| sum + w[:games]}
    playerlist = []
    players = Player.where(division: division)
    players.each do |p|
      playergames = 0
      playerwins = 0
      playerhtml = ""
      playertrophies = 0
      playersphincters = 0
      playerwinpercent = 0.0
      playerbye = false
      for w in 1..(weekinfo.size - 1)
        cellstyle = "pointstyle"
        picks, wins, pts = get_player_picks_wins(p.id, w)
        if Pick.where(player_id: p.id, weeknum: w).count > 0
          playerwins += wins
          playergames += weekinfo[w][:games]
          
          if (weekinfo[w][:trophies].include? p.id)
            cellstyle = "Trophy"
            playertrophies += 1
          elsif (weekinfo[w][:sphincters].include? p.id)
            cellstyle = "Sphincter"
            playersphincters += 1
          else
            cellstyle = "pointstyle"
          end
  
          playerhtml += "<td class=\"" + cellstyle + "\">" + wins.to_s + "</td>"
          
        elsif w % 4 == 0
            playergames += weekinfo[w][:games]
            cellstyle = "nopicks"
            playerhtml += "<td class=\"" + cellstyle + "\">0</td>"
        elsif playerbye == false
            playerbye = true
            playerhtml += "<td class=\"" + cellstyle + "\">Bye</td>"
        else
          cellstyle = "nopicks"
          playerwins += (weekinfo[w][:minpts] / 2.0).ceil
          playergames += weekinfo[w][:games]
          playerhtml += "<td class=\"" + cellstyle + "\">" + (weekinfo[w][:minpts] / 2.0).ceil.to_s + "</td>"
        end
      end
      playerwinpercent = (playergames > 0)? (playerwins.to_f / playergames.to_f * 100).round(2) : 0.to_f.round(2)
      playerlist << { :player_id => p.id, :playername => p.playername, :wins => playerwins, \
            :games => playergames, :playerhtml => playerhtml, :trophies => playertrophies, \
            :sphincters => playersphincters, :winpercent => playerwinpercent}
    end
    playerlist.sort_by { |w| -w[:winpercent] }
  end
  
  def get_weeks_list
    weekinfo = get_week_info
    weekhtml = ""
    for i in 1..(weekinfo.size - 1)
      weekhtml += "<a href=\"/weeks/" + i.to_s + "\">Week " + i.to_s + "</a>"  
    end
    weekhtml
  end
  
  def duppicks
    picks = Pick.where(player_id: 266)
    picks.each do |p|
      Pick.create(weeknum: 1, game_id: p.game_id, picktype: p.picktype, gamepick: p.gamepick, player_id: 270)
    end
  end
end
