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
                            :format => {:with => /^SA[DL][A-Z0-9]{8,9}$/}
  validates :data_read, :presence => true
  validates :user, :presence => true, :associated => true
  validates :assembly, :presence => true, :associated => true
  validates :bad_bits, :presence => true, :associated => true
 
  # Associations
  belongs_to :user
  belongs_to :assembly
  has_and_belongs_to_many :bad_bits, :order => 'bad_bit DESC'
  has_one :rework_request, :order => 'created_at DESC', :dependent => :destroy

  # Default order
  default_scope order('r2d2_debugs.id DESC')

  # Named scopes
  scope :first_ten, limit(10)

  # Callbacks
  # after_create :test_result_should_contain_text

#------------------------------------------------------------------------------
# 
#------------------------------------------------------------------------------
  def extract_and_set_attr(test_result)
    extract_attr(test_result)
    if (check_if_right_board)
      bad_bit_values = extract_bad_bits @extracted_data_pattern, @extracted_data_read 
      for bad_bit_value in bad_bit_values
        bad_bits << BadBit.new(:bad_bit => bad_bit_value)
      end
      self.r2d2_instance = normalized_r2d2_instance
      logger.debug "debug: r2d2_instance -> #{self.r2d2_instance}"
      self.interface = @extracted_interface.sub(/X/, "x") 
      logger.debug "debug: data_read -> #{generate_data_read}"
      self.data_read = generate_data_read
    else
      return false;
    end
  end
  
  def extract_attr(test_result)
    #logger.debug("extract_attr: test_result -> #{test_result}")
    @test_result = test_result

    # extract the following from "test_result" parameter string
    # - interface (Tx/Rx) via R2D2[T|R]PB string ($1)
    # - test data pattern (default 0x55) ($2)
    # - r2d2 instance via "Device Number" string ($3)
    # - data read back from memory via "Data Read" string ($4 - $7)
    # Discovered that when form text is sent using AJAX, lines breaks are "\n" but
    # when form text is sent normally, line breaks are "\r\n".  Modified the regex 
    # below to account for both cases (03-31-11)
    #/R2D2((?:T|R)X)PB.+?(?:\r)?\n(?:.+?(?:\r)?\n){4,4}
    #\sData\sPattern.+?(\d{2,2})(?:\r)?\n
    #\sDevice\sNumber.+?(\d)[\r\n](?:[\w:\s]+?[\n\r]){13,13}
    #\sData\sRead\s+?:\s0x\s((?:(?:\d|[abcdef]){4,4}\s){11,11})[\n\r]
    #\s+?((?:(?:\d|[abcdef]){4,4}\s){11,11})[\n\r]
    #\s+?((?:(?:\d|[abcdef]){4,4}\s){11,11})[\n\r]
    #\s+?((?:(?:\d|[abcdef]){4,4}\s){3,3})/x =~ test_result

    /R2D2((?:T|R)X)PB.+?(?:\r)?\n(?:.+?(?:\r)?\n){5,5}
    \sDevice\sNumber.+?(\d)[\r\n](?:[\w:\s]+?[\n\r]){9,9}
    \sData\sExpected\s+?:\s0x\s((?:\d|[abcdef]){2,2}).+?[\n\r](?:[\w:\s]+?[\n\r]){3,3}
    \sData\sRead\s+?:\s0x\s((?:(?:\d|[abcdef]){4,4}\s){11,11})[\n\r]
    \s+?((?:(?:\d|[abcdef]){4,4}\s){11,11})[\n\r]
    \s+?((?:(?:\d|[abcdef]){4,4}\s){11,11})[\n\r]
    \s+?((?:(?:\d|[abcdef]){4,4}\s){3,3})/x =~ test_result

    #logger.debug("these are the fields extracted from result text: #{$1}\n")
    #logger.debug("these are the fields extracted from result text: #{$1}\n#{$2}\n#{$3}\n#{$4}\n#{$5}\n#{$6}\n#{$7}")
    #
    @extracted_interface = $1
    @extracted_device_number = $2
    @extracted_data_pattern = $3
    @extracted_data_read = [$4, $5, $6, $7]
  end

  def check_if_right_board
    if (@extracted_device_number.to_i > 4 && self.assembly.project_name != "Senga" ||
        @extracted_device_number.to_i > 2 && self.assembly.project_name == "Palladium-SM")
      return false
    else
      return true
    end
  end

  def normalized_r2d2_instance
    if self.assembly.project_name == "Senga"
      return @extracted_device_number.to_i - 5  
    else
      return @extracted_device_number.to_i - 1 
    end
  end

  def extract_bad_bits(data_pattern, data_read)
    logger.debug "debug: data_pattern -> #{data_pattern}, data_read -> #{data_read}"
    expected = ""
    72.times {expected = expected + data_pattern}
    logger.debug "debug: expected -> #{expected}"
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
    "Data Read" + "\s" * 11 + ": 0x " + 
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
