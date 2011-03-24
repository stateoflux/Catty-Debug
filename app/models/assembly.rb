class Assembly < ActiveRecord::Base
  validates :project_name, :presence => true,
                           :length => {:within => 3..20},
                           :format => {:with => /^[A-Z]{1,1}[\w-]{1,18}[\D]$/}

  validates :revision, :presence => true
  validates_numericality_of :revision, :only_integer => true
  validates :revision, :inclusion => {:in => 1..20}
  
  validates :num_of_r2d2s, :presence => true
  validates_numericality_of :num_of_r2d2s, :only_integer => true
  validates :num_of_r2d2s, :inclusion => {:in => 1..8}

  validates :proper_name, :presence => true

  validates :assembly_number, :presence => true,
                              :length => {:within => 10..12},
                              :format => {:with => /^73-\d{4,6}-\d{2,2}$/}

  validates :r2d2s, :presence => true, :associated => true 
 
  # Associations
  has_many :r2d2s, :order => 'instance ASC', :dependent => :destroy
  has_many :r2d2_debugs, :order => 'created_at DESC', :dependent => :nullify
  has_many :rework_requests, :through => :r2d2_debugs,
                             :order => 'created_at DESC'

  accepts_nested_attributes_for :r2d2s  # this allows me to set the attributes of r2d2s at the same time
                                        # that i set the assembly attributes

  default_scope order('assemblies.project_name') # order search results by ascending project name
end
