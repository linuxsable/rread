require 'test_helper'

class AuthorizationTest < ActiveSupport::TestCase
  fixtures :authorizations, :users
  
  # Validations
  test 'presence validation' do
    auth = Authorization.new
    
    assert !auth.valid?
    assert auth.invalid?(:user_id)
    assert auth.invalid?(:uid)
    assert auth.invalid?(:provider)
    assert auth.invalid?(:secret)
  end
  
  # Provider unique to user
  test 'provider unique validation' do
    a = get_authorization
    a.user_id = authorizations(:good_facebook_provider).user_id
    a.save
    
    assert a.invalid?(:provider)
  end
  
  # uid unique to provider
  test 'uid unique validation' do
    a = get_authorization
    a.provider = authorizations(:good_facebook_provider).provider
    a.uid = authorizations(:good_facebook_provider).uid
    a.save
    
    assert a.invalid?(:uid)
  end
  
  # Other
  test 'find_from_hash' do
    record = Authorization.find_from_hash(get_omni_hash)
    assert record.valid?
  end

  test 'create_from_hash' do
    # First create a user if there's none
    hash = get_omni_hash
    hash['provider'] = 'twitter'
    user = users(:good_user)
  
    a = nil
    assert_difference('Authorization.count', 1) do
      assert_difference('ProviderInfo.count', 1) do
        a = Authorization.create_from_hash(hash, user)
      end
    end

    assert a.valid?
    assert a.user.valid?
    assert a.user.provider_infos.first.valid?
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
