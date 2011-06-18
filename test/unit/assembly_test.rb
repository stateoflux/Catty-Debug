require 'test_helper'

class AssemblyTest < ActiveSupport::TestCase

# CRUD TESTING
#------------------------------------------------------------------------------
  test "should create assembly" do
    assembly = Factory.build(:assembly)
    assert assembly.save 
  end

  test "should find assembly" do
    # assert that no exception is raised when a find is executed on the 
    # Assembly class...tests that read operation is working
    assert_nothing_raised { Assembly.find(Factory(:assembly).id) }
  end

  test "should update assembly" do
    assembly = Factory(:assembly)
    # Using the ActiveRecord Query Interface to retrieve a row from the table actually
    # wraps the row in an ActiveRecord Relation Object vs a regular ActiveRecord object.
    # An Relation object does not have the "update_attributes" method, instead it has
    # update_all
    assert Assembly.update_all("id = #{assembly.id}", :project_name => 'Heathland', :revision => 6)
  end

  test "should destroy assembly" do
    assembly = Factory(:assembly)
    assembly.destroy
    # assert that find method will cause a RecordNotFound exception since this record should have been deleted.
    assert_raise(ActiveRecord::RecordNotFound) { Assembly.find(assembly.id) } 
  end

# VALIDATION TESTING
#------------------------------------------------------------------------------
  test "should not create an assembly without any of its attributes" do
    assembly = Factory.build(:assembly, :project_name => nil, :revision => nil,
                             :num_of_r2d2s => nil, :assembly_number => nil,
                             :r2d2s => [])

    # assert that assembly object is not valid since project_name and revision were not specified
    assert !assembly.valid?  
    # assert that assembly object will have a project_name/revision entry in it's error hash 
    assert assembly.errors[:project_name].any?
    assert assembly.errors[:revision].any?
    assert assembly.errors[:num_of_r2d2s].any?
    assert assembly.errors[:assembly_number].any?
    assert assembly.errors[:r2d2s].any?
    # assert that assembly object will have error messages that are equal to "can't be blank" 
    assert_equal "can't be blank", assembly.errors[:project_name][0]
    assert_equal "can't be blank", assembly.errors[:revision][0]
    assert_equal "can't be blank", assembly.errors[:num_of_r2d2s][0]
    assert_equal "can't be blank", assembly.errors[:assembly_number][0]
    assert_equal "can't be blank", assembly.errors[:r2d2s][0]
    # assert that assembly object will not get saved to a table since project_name and revision were not specified
    assert !assembly.save
  end

  test "should not create an assembly if project_name is shorter than 3 chars or longer than 20 chars" do
    assembly = Factory.build(:assembly)
    assembly.project_name = "wm"
    assert !assembly.valid?  
    assert assembly.errors[:project_name].any?
    assert_equal "is too short (minimum is 3 characters)", assembly.errors[:project_name][0]
    assert !assembly.save

    assembly.project_name = "this project name is far too long"

    assert !assembly.valid?  
    assert assembly.errors[:project_name].any?
    assert_equal "is too long (maximum is 20 characters)", assembly.errors[:project_name][0]
    assert !assembly.save
  end

  test "should not create an assembly if project_name has the incorrect format" do
    assembly = Factory.build(:assembly)
    assembly.project_name = "ringar"  # first letter should be capitalized
    assert !assembly.valid?  
    assert assembly.errors[:project_name].any?
    assert_equal "is invalid", assembly.errors[:project_name][0]
    assert !assembly.save
    
    assembly.project_name = "1Ringar"  # Should not begin with a number 

    assert !assembly.valid?  
    assert assembly.errors[:project_name].any?
    assert_equal "is invalid", assembly.errors[:project_name][0]
    assert !assembly.save
  end

  test "should not create an assembly if revision is not a number" do
    assembly = Factory.build(:assembly)
    assembly.revision = "One"  
    assert !assembly.valid?  
    assert assembly.errors[:revision].any?
    assert_equal "is not a number", assembly.errors[:revision][0]
    assert !assembly.save
  end

  test "should not create an assembly if revision is not an integer" do
    assembly = Factory.build(:assembly)
    assembly.revision = 10.1  
    assert !assembly.valid?  
    assert assembly.errors[:revision].any?
    assert_equal "must be an integer", assembly.errors[:revision][0]
    assert !assembly.save
  end

  test "should not create an assembly if revision is not a number between 1 - 20" do
    assembly = Factory.build(:assembly)
    assembly.revision = 0  
    assert !assembly.valid?  
    assert assembly.errors[:revision].any?
    assert_equal "is not included in the list", assembly.errors[:revision][0]
    assert !assembly.save

    assembly.revision = 35  

    assert !assembly.valid?  
    assert assembly.errors[:revision].any?
    assert_equal "is not included in the list", assembly.errors[:revision][0]
    assert !assembly.save
  end

  test "should not create an assembly if num_of_r2d2s is not a number" do
    assembly = Factory.build(:assembly)
    assembly.num_of_r2d2s = "Five"  
    assert !assembly.valid?  
    assert assembly.errors[:num_of_r2d2s].any?
    assert_equal "is not a number", assembly.errors[:num_of_r2d2s][0]
    assert !assembly.save
  end

  test "should not create an assembly if num_of_r2d2s is not an integer" do
    assembly = Factory.build(:assembly)
    assembly.num_of_r2d2s = 3.1  
    assert !assembly.valid?  
    assert assembly.errors[:num_of_r2d2s].any?
    assert_equal "must be an integer", assembly.errors[:num_of_r2d2s][0]
    assert !assembly.save
  end

 test "should not create an assembly if num_of_r2d2s is not a number between 1 - 8" do
    assembly = Factory.build(:assembly)
    assembly.num_of_r2d2s = 0  
    assert !assembly.valid?  
    assert assembly.errors[:num_of_r2d2s].any?
    assert_equal "is not included in the list", assembly.errors[:num_of_r2d2s][0]
    assert !assembly.save

    assembly.num_of_r2d2s = 35  

    assert !assembly.valid?  
    assert assembly.errors[:num_of_r2d2s].any?
    assert_equal "is not included in the list", assembly.errors[:num_of_r2d2s][0]
    assert !assembly.save
  end

  test "should not create an assembly if assembly_number has the incorrect format" do
    assembly = Factory.build(:assembly)
    assembly.assembly_number = "73-13327-" 

    assert !assembly.valid?  
    assert assembly.errors[:assembly_number].any?
    assert_equal "is too short (minimum is 10 characters)", assembly.errors[:assembly_number][0]
    assert !assembly.save
    
    assembly.assembly_number = "72-13327-01"  # Should not begin with a number 

    assert !assembly.valid?  
    assert assembly.errors[:assembly_number].any?
    assert_equal "is invalid", assembly.errors[:assembly_number][0]
    assert !assembly.save

    assembly.assembly_number = "73_13327_01" 

    assert !assembly.valid?  
    assert assembly.errors[:assembly_number].any?
    assert_equal "is invalid", assembly.errors[:assembly_number][0]
    assert !assembly.save
  end

# Method Testing
#------------------------------------------------------------------------------
  test "proper name method should return the correct string" do
    assembly = Factory.build(:assembly)
    assert assembly.valid?
    assert_equal "Ringar rev5", assembly.proper_name
  end
end
