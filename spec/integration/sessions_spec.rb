require 'capybara/rspec'
require 'capybara/dsl'
require 'sinatra'
require File.expand_path('../../../app/social_gamer.rb', __FILE__)

Sinatra::Application.environment = :test
Capybara.app = Sinatra::Application
#Capybara.default_driver = :selenium

RSpec.configure do |config|
  config.include Capybara
end

describe 'register', type: :request do
  it 'is accessible from the login dropdown' do
    visit '/'
    click_on 'login'
    within('#dropdown') do
      click_on 'Register'
    end
    current_path.should eq '/register'
  end

  it 'starts user session for the new user' do
    visit '/register'
    within '#registration_form' do
      fill_in 'email', with: 'bob@bob.bob'
      fill_in 'password', with: 'herp'
      fill_in 'password_confirmation', with: 'herp'
      click_button 'Register'
    end

    current_path.should eq '/'
  end

end


