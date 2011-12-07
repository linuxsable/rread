require 'test_helper'

class ProviderInfoTest < ActiveSupport::TestCase
  # Validations
  test 'presence validation' do
    info = get_provider_info
    
    assert !info.valid?
    assert info.invalid?(:user_id)
    assert info.invalid?(:provider)
    assert info.invalid?(:uid)
  end
  
  test 'uniqueness validation' do
    info = get_provider_info
    
    assert !info.valid?
    assert info.invalid?(:uid)
  end
  
  # Other
  test 'create_from_hash_and_user' do
    user = users(:good_user)
    hash = get_omni_hash
    
    assert_difference('ProviderInfo.count', 1) do
      ProviderInfo.create_from_hash_and_user(hash, user)
    end
  end
  
  def get_provider_info
    ProviderInfo.new do |u|
      u.user        = users(:good_user)
      u.provider    = 'facebook'
      u.uid         = '1'
      u.username    = '_ty'
      u.email       = 'linuxsable@gmail.com'
      u.first_name  = 'tyler'
      u.last_name   = 'van hoomissen'
      u.avatar      = '48h9q8ghag'
      u.description = 'asdfaewgasdf'
      u.location    = 'cali'
    end
  end
end
