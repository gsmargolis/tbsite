class User < ActiveRecord::Base
  
  has_secure_password
  
  
    before_create do
        p = Player.find_by(playername: self.name)
        
        if p != nil
          self.cbs_id = p.cbsid
        end
        
    end
  
end
