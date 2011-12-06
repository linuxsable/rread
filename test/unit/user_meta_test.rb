require 'test_helper'

class UserMetaTest < ActiveSupport::TestCase
  # Validations
  test 'presence validation' do
    user_meta = get_user_meta
    
    assert !user_meta.valid?
    assert user_meta.invalid?(:user_id)
    assert user_meta.invalid?(:provider)
    assert user_meta.invalid?(:uid)
  end
  
  test 'uniqueness validation' do
    user_meta = get_user_meta
    
    assert !user_meta.valid?
    assert user_meta.invalid?(:uid)
  end
  
  # Other
  test 'create_from_hash_and_user' do
    user = users(:good_user)
    hash = get_omni_hash
    
    assert_difference('UserMeta.count', 1) do
      UserMeta.create_from_hash_and_user(hash, user)
    end
  end
  
  def get_user_meta
    UserMeta.new do |u|
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
