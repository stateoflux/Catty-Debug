class BadBit < ActiveRecord::Base
  validates :bad_bit, :presence => true
  validates_numericality_of :bad_bit, :only_integer => true
  validates :bad_bit, :inclusion => {:in => 0..575}  # number of bits in a GMTL cell

  #validates :r2d2_debugs, :presence => true, :associated => true

  has_and_belongs_to_many :r2d2_debugs

  def cycle
    if bad_bit <= 287
      return "2nd"
    else
      return "1st"
    end
  end

  def memory 
    (phy / 2).to_i
  end

  def phy
    case bad_bit % 288 
      when 0..35    then return 0
      when 36..71   then return 1
      when 72..107  then return 2
      when 108..143 then return 3
      when 144..179 then return 4
      when 180..215 then return 5
      when 216..251 then return 6
      when 252..287 then return 7
    end
  end

  def edge
    if (bad_bit % 288) % 36 <= 17
      return "falling"
    else
      return "rising"
    end
  end

  def dq
  end
end
