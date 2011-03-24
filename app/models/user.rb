class User < ActiveRecord::Base
  validates :email, :presence => true, 
                    :uniqueness => true, 
                    :length => {:within => 5..50},
                    :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
  #validates :admin, :presence => true

  validates :first_name, :presence => true, 
                         :length => {:within => 2..50},
                         :format => { :with => /^[a-z,A-Z,-]{2,50}$/i }

  validates :last_name, :presence => true, 
                        :length => {:within => 2..50},
                        :format => { :with => /^[a-z,A-Z,-]{2,50}$/i }


  has_many :r2d2_debugs, :order => 'created_at DESC', 
                         :dependent => :nullify

  has_many :rework_requests, :through => :r2d2_debugs,
                             :order => 'created_at DESC'

  def self.authenticate(email)
    find_by_email(email)
  end
end
