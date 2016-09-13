module ApplicationHelper
  def get_winners(weeknumber)
     winners = []
     losers = []
     @games = Game.where(weeknum: weeknumber)
     @games.each do |g|
        if g[:awayscore] != g[:homescore] + g[:line]
          winner = (g[:awayscore] > g[:homescore] + g[:line])? g[:awayteam] : g[:hometeam]
          winners << winner
          loser = (g[:awayscore] < g[:homescore] + g[:line])? g[:awayteam] : g[:hometeam]
          losers << loser
        end
     end
     return winners, losers
  end
  
  def set_trophies(weeknumber)
      
      Award.where(weeknum: weeknumber).destroy_all
      
      mnfpts = get_mnf_pts(weeknumber)
      picks, maxpts, minpts = get_picks(weeknumber)
      if maxpts != minpts
        toppicks = picks.find_all { |p| p[:wins] == maxpts }
        bestmnf = toppicks.min { |x,y|  ((x[:pts].to_i - mnfpts).abs) <=> ((y[:pts].to_i - mnfpts).abs) }[:pts]
        toppicks.each do |tp|
          if (tp[:pts] == bestmnf) and (tp[:htmlrow].index("No Picks Submitted") == nil)
            trophy = Award.create(awardtype: "Trophy", weeknum: weeknumber, player_id: tp[:playerid])
          end
        end
        bottompicks = picks.find_all { |p| p[:wins] == minpts }
        worstmnf = bottompicks.max { |x,y|  ((x[:pts].to_i - mnfpts).abs) <=> ((y[:pts].to_i - mnfpts).abs) }[:pts]
        bottompicks.each do |bp|
          if (bp[:pts] == worstmnf) #&& (bp[:pts] != bestmnf)
            trophy = Award.create(awardtype: "Sphincter", weeknum: weeknumber, player_id: bp[:playerid])
          end
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
    return picks.sort_by { |w| [-w[:wins], ((w[:pts].to_i - mnfpts).abs)] }, picks.max { |w,z| w[:wins] <=> z[:wins]}[:wins], picks.min { |w,z| ((w[:wins] == -1)? 100 : w[:wins]) <=> ((z[:wins] == -1)? 100 : z[:wins])}[:wins] 
  end
  
  def get_player_picks_wins(player_id, weeknumber)
    wins = 0
    pts = 0
    winners, losers = get_winners(weeknumber)
    returnarray = []
    picks = Pick.where(player_id: player_id, weeknum: weeknumber).order(:game_id)
    pickrow = ""
    picks.each do |p|
      if winners.include? p.gamepick
        winlose = "winteam"
      elsif losers.include? p.gamepick
        winlose = "loseteam"
      else
        winlose = ""
      end
      #binding.pry
      if (p.picktype == "Points")
        winlose = ""
        pts = p.gamepick
      end

      pickrow = pickrow + "<td class=\"" + winlose + "\">" + p.gamepick + "</td>"
      wins = wins + ((winners.include? p.gamepick)? 1 : 0)
    end
      trophystyle = (award = Award.find_by(player_id: player_id, weeknum: weeknumber))? award.awardtype : "pointstyle"
      #if picks.size > 0
      if picks.size > 0
        pickrow = pickrow + "<td class=\"" + trophystyle + "\">" + wins.to_s + "</td>"
      else
        pickrow = pickrow + "<td class=\"" + trophystyle + "\" colspan=\"20\">No Picks Submitted</td>"
        wins = -1
      end
      
      #pickrow = (picks.size > 0)? pickrow + "<td class=\"" + trophystyle + "\">" + wins.to_s + "</td>" : pickrow + "<td class=\"" + trophystyle + "\" colspan=\"20\">No Picks Submitted</td>"
    return pickrow, wins, pts
  end

   def get_games(weeknumber)
    gamelist = []
    winners, losers = get_winners(weeknumber)
    @games = Game.where(weeknum: weeknumber).order(:id)
    
    lineweek = (@games.max { |x,y| x.line <=> y.line}.line > 0)
    
    @games.each do |g|
      gamerow = ""
      if winners.include? g.awayteam
        awayclass = "winteam"
      elsif losers.include? g.awayteam
        awayclass = "loseteam"
      else
        awayclass = ""
      end
      if winners.include? g.hometeam
        homeclass = "winteam"
      elsif losers.include? g.hometeam
        homeclass = "loseteam"
      else
        homeclass = ""
      end

      case g.status
        
        when "S"
          gamestatus = g.gamedt.strftime("%-m/%d&nbsp&nbsp%l:%M")
        when "P"
          gamestatus = (g.quarter.to_i > 4)? "OT " + g.gameclock : ((g.quarter.to_i == 2) && (g.gameclock == "0:00"))? "Halftime" : g.quarter.to_i.ordinalize + " " + g.gameclock
        when "F"
          gamestatus = "Final"
      end
      
      #gline = (lineweek)? ((g.line == g.line.to_i)? g.line.to_i.to_s : g.line.to_s) : ""
      
      gamerow = "<table class=\"noborder\">"
      gamerow = gamerow + "<tr>"
      gamerow = gamerow + "       <th class=\"lefthead noborder " + awayclass + "\">" + g.awayteam + "</th>"
      gamerow = gamerow + "        <th class=\"rightalign noborder " + awayclass + "\">" + g.awayscore.to_s + "</th>"
      gamerow = gamerow + "     </tr> "
      gamerow = gamerow + "     <tr>"
      gamerow = gamerow + "       <th class=\"lefthead noborder " + homeclass + "\">" + g.hometeam + "</th>"
      if lineweek
        gamerow = gamerow + "       <th class=\"rightalign noborder " + homeclass + "\">" + g.homescore.to_s + "</th>"
        gamerow = gamerow + "       <th class=\"rightalign noborder\">(" + ((g.line == g.line.to_i)? g.line.to_i.to_s : g.line.to_s) + ")</th>"
      else
        gamerow = gamerow + "       <th class=\"rightalign noborder " + homeclass + "\">" + g.homescore.to_s + "</th>"
      end
      gamerow = gamerow + "     </tr>"
      gamerow = gamerow + "     <tr>"
      gamerow = gamerow + "       <th class=\"noborder\" colspan=\"3\">" + gamestatus + "</th>"
      gamerow = gamerow + "     </tr>"
      gamerow = gamerow + "   </table>"
      gamelist << gamerow
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
    playerlist.sort_by { |w| [-w[:winpercent], w[:playername]] }
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
  
  
    
  def logentry(action, result)
    Log.create(startdt: DateTime.current, action: action, result: result)
  end

  def getlastupdate
    lastupdate = Log.where(action: "CBS Update").maximum(:startdt)
    if lastupdate != nil
      Log.where(action: "CBS Update").maximum(:startdt).in_time_zone('Central Time (US & Canada)')
    end
  end
  
  def getcbsdata
   
   require 'json'
   
    page = HTTParty.get('http://www.cbssports.com/login?xurl=http://wilburnstb.football.cbssports.com/office-pool/standings/live?u=1&userid=c51999&password=stingray')
    datastart = page.index("var opmLS = new CBSi.app.OPMLiveStandings(")
    datastart = page.index('{"alert"', datastart)
    dataend = page.index('} );', datastart)
    
    firstblock = page[datastart..dataend]
    
    datastart = page.index('{', dataend + 1)
    dataend = page.index('}', datastart)
    
    secondblock = page[datastart..dataend]
    
    firstjson = JSON.parse(firstblock)
    secondjson = JSON.parse(secondblock)

    mnfgame = firstjson["mnfGameId"][4,firstjson["mnfGameId"].size - 3]
    week = firstjson["week"] 

    #/(.*?)\n/.match(secondjson["/ffball/games"])[1] - first game status
    rawgamedata = []
    gamedata = []
    games = []
    picks = []
    players = []
    pickcount = []
    gamestatus = []
    gamepick = ""
    firstjson["spreads"].each do
      
    end
    
    rawgamedata = secondjson["/ffball/games"].scan(/(.*?)\n/)
    rawgamedata.each do |gd|
      gamedata << { gd[0].split(/\|/)[0][13,gd[0].split(/\|/)[0].size - 13] => gd[0].split(/\|/)}
      #gamedata.last[0] = gamedata.last[0][13,gamedata.last[0].size - 13]
    end
    
    

    rawgames = firstjson["games"]["nfl"]
    #Game.where(weeknum: week).destroy_all
    rawgames.each do |g|
      gamestatus = (gamedata.find {|h| h.first[0] == g[4,g.size - 3]}.first[1])
      gametime = gamestatus[6]
      #9/12 10:20
      gday = /(.*?)\/(.*?) (.*?):(.*)/.match(gametime)[2].to_i
      gmonth = /(.*?)\/(.*?) (.*?):(.*)/.match(gametime)[1].to_i
      ghour = /(.*?)\/(.*?) (.*?):(.*)/.match(gametime)[3].to_i
      gminute = /(.*?)\/(.*?) (.*?):(.*)/.match(gametime)[4].to_i
      gyear = (DateTime.new(DateTime.current.year,gmonth,gday) < DateTime.new(DateTime.current.year,DateTime.current.month,DateTime.current.day).beginning_of_week(start_day = :tuesday))? DateTime.current.year + 1 : DateTime.current.year
      gamedt =  DateTime.new(gyear,gmonth,gday,ghour,gminute,0,0).change(:offset => (ActiveSupport::TimeZone['Eastern Time (US & Canada)'].now.utc_offset/3600).to_s).utc
      
      
      Game.where(weeknum: week, gamename: g[4,g.size - 3]).first_or_create(gamename: g[4,g.size - 3], awayteam: g[4,g.size - 3].split(/@/)[0], hometeam: g[4,g.size - 3].split(/@/)[1], awayscore: gamestatus[10], homescore: gamestatus[11], line: firstjson["spreads"][g], ismnf: (mnfgame == g[4,g.size - 3]), weeknum: week, status: gamestatus[1], quarter: gamestatus[2], gamedt: gamedt, gameclock: gamestatus[5]).update(gamename: g[4,g.size - 3], awayteam: g[4,g.size - 3].split(/@/)[0], hometeam: g[4,g.size - 3].split(/@/)[1], awayscore: gamestatus[10], homescore: gamestatus[11], line: firstjson["spreads"][g], ismnf: (mnfgame == g[4,g.size - 3]), weeknum: week, status: gamestatus[1], quarter: gamestatus[2], gamedt: gamedt, gameclock: gamestatus[5])
      #Game.where(weeknum: week, gamename: g[4,g.size - 3]).first_or_create(gamename: g[4,g.size - 3], awayteam: g[4,g.size - 3].split(/@/)[0], hometeam: g[4,g.size - 3].split(/@/)[1], awayscore: (gamedata.find{|h| h.first[0] == g[4,g.size - 3]}.first[1][10]), homescore: (gamedata.find {|h| h.first[0] == g[4,g.size - 3]}.first[1][11]), line: firstjson["spreads"][g], ismnf: (mnfgame == g[4,g.size - 3]), weeknum: week).update(gamename: g[4,g.size - 3], awayteam: g[4,g.size - 3].split(/@/)[0], hometeam: g[4,g.size - 3].split(/@/)[1], awayscore: (gamedata.find{|h| h.first[0] == g[4,g.size - 3]}.first[1][10]), homescore: (gamedata.find {|h| h.first[0] == g[4,g.size - 3]}.first[1][11]), line: firstjson["spreads"][g], ismnf: (mnfgame == g[4,g.size - 3]), weeknum: week)
    end
    games = Game.where(weeknum: week)
    players = Player.all
    
    
    totalgames = games.size
    rawpicks = firstjson["teams"]
    #Pick.where(weeknum: week).destroy_all
    rawpicks.each do |p|
      pickcount.clear
      playerid = players.find_by(playername: p["name"])
      if p.key?("picks") #Picks exist and are visible
        p["picks"].each do |x|

          if x[0] == "mnf"
            picktype = "Points"
            gamepick = x[1]
            pickgame = games.find_by(gamename: x[0][4,x[0].size - 3])
            picks << {:weeknum => week, :player => players.find_by(playername: p["name"]), :game => games.find_by(gamename: x[0][4..x.size - 3]), :picktype => picktype, :gamepick => gamepick }
           elsif x[0] == "time"
            #do nothing
          else
            picktype = "Team"
            pickgame = x[0][4,x[0].size - 3]
            gamepick = x[1]["winner"]
            pickcount << pickgame
            picks << {:weeknum => week, :player => players.find_by(playername: p["name"]), :game => games.find_by(gamename: x[0][4..x.size - 3]), :picktype => picktype , :gamepick => gamepick}
          end
        end

      else  #Picks don't exist
        #do nothing
      end
      if p.key?("numGames") and pickcount.size == 0 #Picks exist but are not visible
        for i in 0..(totalgames - 1)
          picktype = "Team"
          pickgame = games[i]
          gamepick = "X"
          picks << {:weeknum => week, :player => players.find_by(playername: p["name"]), :game => games[i], :picktype => picktype, :gamepick => gamepick}
        end
          picks << {:weeknum => week, :player => players.find_by(playername: p["name"]), :game => nil, :picktype => "Points", :gamepick => "0"}
      end
      
      if (pickcount.size > 0) && (pickcount.size < totalgames)
        games.each do |g|
          if !(pickcount.include? g[:gamename])
            picktype = "Team"
            pickgame = g
            gamepick = "X"
            picks << {:weeknum => week, :player => players.find_by(playername: p["name"]), :game => pickgame, :picktype => picktype, :gamepick => "X"}
          end
          if playerid.picks.where(picktype: "Points").count == 0
            picks << {:weeknum => week, :player => players.find_by(playername: p["name"]), :game => nil, :picktype => "Points", :gamepick => "0"}
          end
        end
        
      end
      
    end

    picks.each do |p|
      Pick.where(weeknum: p[:weeknum], player: p[:player], game: p[:game], picktype: p[:picktype]).first_or_create(weeknum: p[:weeknum], player: p[:player], game: p[:game], picktype: p[:picktype], gamepick: p[:gamepick]).update(gamepick: p[:gamepick])
    end
    
    set_trophies(week)
    logentry("CBS Update",  "")
  end
  
end
