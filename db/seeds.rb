# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
json = ActiveSupport::JSON.decode(File.read('db/seeds/assemblies.json'))
 
json.each do |a|
   assembly = Assembly.new
   assembly.assembly_number = a['assembly']['assembly_number']
   assembly.num_of_r2d2s = a['assembly']['num_of_r2d2s']
   assembly.project_name = a['assembly']['project_name']
   assembly.proper_name = a['assembly']['proper_name']
   assembly.revision = a['assembly']['revision']
   for r2d2_json in a['assembly']['r2d2s'] do
     r2d2 = R2d2.new
     r2d2.instance = r2d2_json['instance'] 
     r2d2.part_number = r2d2_json['part_number']
     r2d2.refdes = r2d2_json['refdes'] 
     for memory_json in r2d2_json['tx_memories'] do 
         r2d2.tx_memories << TxMemory.new(memory_json)
     end
     for memory_json in r2d2_json['rx_memories'] do 
         r2d2.rx_memories << RxMemory.new(memory_json)
     end
     assembly.r2d2s << r2d2
   end
   assembly.save
end
