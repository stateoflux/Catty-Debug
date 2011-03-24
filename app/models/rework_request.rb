class ReworkRequest < ActiveRecord::Base
  validates :board_name, :presence => true,
                         :length => {:within => 3..20},
                         :format => {:with => /^[A-Z]{1,1}[\w-]{1,18}[\D]$/}
  validates :turn_around, :presence => true,
                          :length => {:within => 8..9},
                          :format => {:with => /^\d-\d\sdays$/}

  validates :instructions, :presence => true, :length => {:minimum => 10}

  validates :bake, :presence => true,
                          :length => {:within => 2..3},
                          :format => {:with => /^(?:yes|no)$/}

  validates :xray, :presence => true,
                          :length => {:within => 2..3},
                          :format => {:with => /^(?:yes|no)$/}

  belongs_to :r2d2_debug
end
