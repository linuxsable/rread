require 'test_helper'

class UserTest < ActiveSupport::TestCase  
  # Validations
  
  # Other
  test 'create_from_hash' do
    assert_difference('User.count', 1) do
      User.create_from_hash(get_omni_hash)
    end
  end
  
end
