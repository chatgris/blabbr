require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "login page", %q{
  In order to enjoy blabbr
    As a user
    I want to login
} do

  background do
    Fabricate.build(:creator)
  end

  after do
    Warden.test_reset!
  end
  
  scenario "Login with valid params" do
    visit '/'
    within(:css, "#user_new") do
      fill_in 'user[email]', :with => 'email@email.com'
      fill_in 'user[password]', :with => 'password'
    end
    click_on('Sign in')
    page.should_not have_content('invalid')
    page.should have_css("#topics")
  end
end

feature "Login Page", %q{
  In order to view blabbr
    As a user
    I want to see the login page, create an account, and login
} do

  scenario "View login form, then subscription form" do
    visit "/"

    page.should have_css("#user_new", :count => 1)
    within(:css, "#user_new") do
      page.should have_content("Email")
      page.should have_content("Password")
      page.should have_content("Remember me")
    end
    click_link 'Sign up'
    page.should have_content("Pseudo")
  end

  scenario "View subscription form" do
    visit "/users/sign_up"

    page.should have_css("#user_new", :count => 1)
    within(:css, "#user_new") do
      page.should have_content("Email")
      page.should have_content("Pseudo")
      page.should have_content("Password")
      page.should have_content("Password confirmation")
    end
  end

  scenario "View subscription form, submit valid informations" do
    visit "/users/sign_up"
    within("#user_new") do
      fill_in 'user[nickname]', :with => 'chatgris'
      fill_in 'user[email]', :with => 'chatgris@mail.com'
      fill_in 'user[password]', :with => 'caplin'
      fill_in 'user[password_confirmation]', :with => 'caplin'
    end
    click_on('Sign up')
    page.should_not have_css('#error_explanation')
    page.should have_content('chatgris')
  end

  scenario "View subscription form, submit non valid informations" do
    visit "/users/sign_up"
    click_on('Sign up')
    page.should have_css('#error_explanation')
  end

  scenario "Login with invalid params" do
    visit '/'
    within(:css, "#user_new") do
      page.should have_content("Email")
      fill_in 'user[email]', :with => 'chatgris@mail.com'
    end
    click_on('Sign in')
    page.should have_content('invalid')
  end
end
