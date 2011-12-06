ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def get_omni_hash
    {
      'uid' => 1234,
      'provider' => 'facebook',
      'info' => {
        'nickname' => '_ty',
        'email' => 'linuxsable@gmail.com',
        'first_name' => 'tyler',
        'last_name' => 'van hoomissen',
        'image' => 'ofiqjgoqig',
        'description' => 'oihaoihfaosdifhaosdfiadf',
        'location' => 'oawigejaorigj'
      },
      'credentials' => {
        'token' => '298thqg98hq3rg89hqg3298qh34g',
        'secret' => '293hq3g98qhgauhg0q834gnxvcb'
      }
    }
  end
end
