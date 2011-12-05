require 'test_helper'

class AuthorizationTest < ActiveSupport::TestCase
  fixtures :authorizations, :users
  
  # Validations
  test 'requires user_id' do
    a = get_authorization
    a.user = nil
    a.save
    
    assert a.errors.get(:user_id)
  end
  
  test 'requires uid' do
    a = get_authorization
    a.uid = nil
    a.save
    
    assert a.errors.get(:uid)
  end
  
  test 'requires provider' do
    a = get_authorization
    a.provider = nil
    a.save
    
    assert a.errors.get(:provider)
  end
  
  test 'unique :provider' do
    a = get_authorization
    b = get_authorization
    
    a.save
    b.save
    
    assert b.errors.get(:provider)
  end
  
  # Other
  test 'find_from_hash' do
    record = Authorization.find_from_hash(get_omni_hash)
    assert record.valid?
  end
  
  test 'create_from_hash' do
    # First create a user if there's none
    
    # Then create an Authorization
    
    # Then create the UserMeta
  end
  
  def get_authorization
    Authorization.new do |auth|
      auth.user     = users(:good_user)
      auth.provider = 'facebook'
      auth.uid      = '1351231422134'
      auth.token    = 'ccb4a9130f39cc557558b9248360f43f'
      auth.secret   = '475af0eb6b2fe9a6b0136c48b05532e6'
    end
  end
end
