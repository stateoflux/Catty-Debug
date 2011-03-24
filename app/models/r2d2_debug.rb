class R2d2Debug < ActiveRecord::Base

  # So that I can validate if the r2d2 belongs to the baseboard or daughterboard
  attr_reader :extracted_device_number

  # Validations
  validates :r2d2_instance, :presence => true
  validates_numericality_of :r2d2_instance, :only_integer => true
  validates :r2d2_instance, :inclusion => {:in => 0..7}

  validates :interface, :presence => true,
                        :length => {:is => 2},
                        :format => {:with => /^[RT]x$/}
  validates :serial_number, :presence => true,
                            :length => {:within => 11..15},
                            :format => {:with => /^SAD\d{6,7}[A-Z0-9]{2,2}$/}
  validates :user, :presence => true, :associated => true
  validates :assembly, :presence => true, :associated => true
  validates :bad_bits, :presence => true, :associated => true
 
  # Associations
  belongs_to :user
  belongs_to :assembly
  has_and_belongs_to_many :bad_bits, :order => 'bad_bit DESC'
  has_one :rework_request, :order => 'created_at DESC', :dependent => :destroy

  # Callbacks
  # after_create :test_result_should_contain_text

#------------------------------------------------------------------------------
# 
#------------------------------------------------------------------------------
  def extract_and_set_attr(test_result)
    extract_attr(test_result)

    bad_bit_values = extract_bad_bits @extracted_data_pattern, @extracted_data_read 
    for bad_bit_value in bad_bit_values
      bad_bits << BadBit.new(:bad_bit => bad_bit_value)
    end

    self.r2d2_instance = @extracted_device_number.to_i - 1
    self.interface = @extracted_interface.sub(/X/, "x") 
  end
  
  def extract_attr(test_result)
    @test_result = test_result

    # extract the following from "test_result" parameter string
    # - interface (Tx/Rx) via R2D2[T|R]PB string ($1)
    # - test data pattern (default 0x55) ($2)
    # - r2d2 instance via "Device Number" string ($3)
    # - data read back from memory via "Data Read" string ($4 - $7)
    /R2D2((?:T|R)X)PB.+?\r\n(?:.+?\r\n){4,4}
    \sData\sPattern.+?(\d{2,2})\r\n
    \sDevice\sNumber.+?(\d)[\r\n](?:[\w:\s]+?[\n\r]){13,13}
    \sData\sRead\s+?:\s0x\s((?:(?:\d|[abcdef]){4,4}\s){11,11})[\n\r]
    \s+?((?:(?:\d|[abcdef]){4,4}\s){11,11})[\n\r]
    \s+?((?:(?:\d|[abcdef]){4,4}\s){11,11})[\n\r]
    \s+?((?:(?:\d|[abcdef]){4,4}\s){3,3})/x =~ test_result

    #logger.debug("these are the fields extracted from result text: #{$1}\n#{$2}\n#{$3}\n#{$4}\n#{$5}\n#{$6}\n#{$7}")
    #
    @extracted_interface = $1
    @extracted_data_pattern = $2
    @extracted_device_number = $3
    @extracted_data_read = [$4, $5, $6, $7]
  end

  def extract_bad_bits(data_pattern, data_read)
    expected = ""
    72.times {expected = expected + data_pattern}
    binary_bits = (expected.hex ^ (data_read.join("").scan(/\w+/).join.hex)).to_s(2).reverse
    index = -1 
    bad_bits = []
    while(index)
      index = binary_bits.index('1', index + 1)
      bad_bits << index if index
    end
    bad_bits.reverse
  end
  
  # Custom validators to check values extracted from test result
  #def test_result_should_contain_text
  #  errors.add(:test_result, "test result cannot be blank") if @test_result == ""
  #end


  def generate_data_read
    @extracted_data_read[0] + "\n" + "\s" * 25 + @extracted_data_read[1] + "\n" + 
    "\s" * 25 + @extracted_data_read[2] + "\n" + "\s" * 25 + @extracted_data_read[3]
  end

    def get_unique_refdes
    get_all_refdes.uniq.join(", ")
  end

  def get_all_refdes
    refdes_collection = []
    for bad_bit in bad_bits
      refdes_collection << mem_refdes(bad_bit)
    end
    refdes_collection
  end

  def mem_refdes(bad_bit)
    if interface == "Tx"
      assembly.r2d2s[r2d2_instance].tx_memories[bad_bit.memory].refdes
    else
      assembly.r2d2s[r2d2_instance].rx_memories[bad_bit.memory].refdes
    end
  end

end
