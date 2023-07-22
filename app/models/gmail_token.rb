class GmailToken < ApplicationRecord
    def expired?
        return false if expires_at.nil?
        
        expires_at < Time.now
    end
end
