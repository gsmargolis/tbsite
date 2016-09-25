class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {:case_sensitive => false, :message => lambda{|x,y| "\"#{y[:value]}\" is already assigned to another user"}}
   
  has_secure_password
  
  
    before_create do
        p = Player.find_by(playername: self.name)
        
        if p != nil
          self.cbs_id = p.cbsid
        end
        
    end
  
end
