class R2d2 < ActiveRecord::Base
  validates :part_number, :presence => true,
                          :length => {:within => 10..12},
                          :format => {:with => /^08-\d{4,5}-\d{2,2}$/}
  validates :instance, :presence => true
  validates_numericality_of :instance, :only_integer => true
  validates :instance, :inclusion => {:in => 0..7}

  validates :refdes, :presence => true,
                     :length => {:within => 2..6},
                     :format => {:with => /^U\d{1,5}$/}
  validates :tx_memories, :presence => true, :associated => true
  validates :rx_memories, :presence => true, :associated => true

  #validates :assembly, :presence => true

  belongs_to :assembly
  has_many :tx_memories, :order => 'instance ASC', :dependent => :destroy
  has_many :rx_memories, :order => 'instance ASC', :dependent => :destroy

  accepts_nested_attributes_for :rx_memories
  accepts_nested_attributes_for :tx_memories
end
