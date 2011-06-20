Factory.define :rx_memory do |f|
  f.instance 0 
  #f.sequence(:instance) { |n| n }
  f.part_number "15-11466-01"
  f.sequence(:refdes) { |n| "U30#{n}" }
end

Factory.define :tx_memory do |f|
  f.instance 0 
  #f.sequence(:instance) { |n| n }
  f.part_number "15-11466-01"
  f.sequence(:refdes) { |n| "U20#{n}" }
end

Factory.define :r2d2 do |f|
  f.instance 0 
  f.part_number "08-0674-05"
  f.sequence(:refdes) { |n| "U10#{n}" }
  f.rx_memories { add_rx_memories } 
  f.tx_memories { add_tx_memories } 
end

Factory.define :assembly do |f|
  f.project_name "Ringar" 
  f.revision 5 
  f.num_of_r2d2s 4 
  f.assembly_number "73-113327-01"
  f.r2d2s { add_r2d2s }
end

Factory.define :user do |f|
  f.first_name "Wayne" 
  f.last_name "Montague" 
  f.email "wmontagu@cisco.com" 
  f.admin true
end

Factory.define :bad_bit do |f|
  f.bad_bit 100 
  #f.r2d2_debugs { [] << Factory.build(:r2d2_debug) } 
end

Factory.define :r2d2_debug do |f|
  f.r2d2_instance 1 
  f.interface "Tx"
  f.serial_number "SAD111222UX"
  f.data_read "Data Read..."
  f.bad_bits { [] << Factory.build(:bad_bit) }
  f.association :assembly 
  f.association :user
end

def add_rx_memories
  rx_memories = []
  4.times { rx_memories << Factory.build(:rx_memory) }
  rx_memories
end

def add_tx_memories
  tx_memories = []
  4.times { tx_memories << Factory.build(:tx_memory) }
  tx_memories
end

def add_r2d2s
# Assembly has many R2D2s and each R2D2 has many tx & rx memories
  r2d2s = []
  4.times { r2d2s << Factory.build(:r2d2) }
  r2d2s
end
