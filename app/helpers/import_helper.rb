module ImportHelper
  require 'task_helpers/update_data'
  
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

  