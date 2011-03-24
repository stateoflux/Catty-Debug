class RxMemory < ActiveRecord::Base
 validates :part_number, :presence => true,
                          :length => {:within => 10..12},
                          :format => {:with => /^15-\d{4,5}-\d{2,2}$/}

  validates :instance, :presence => true
  validates_numericality_of :instance, :only_integer => true
  validates :instance, :inclusion => {:in => 0..3}

  validates :refdes, :presence => true,
                     :length => {:within => 2..6},
                     :format => {:with => /^U\d{1,5}$/}

  #validates :r2d2, :presence => true
 
  belongs_to :r2d2
end
