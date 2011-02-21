require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Topics index", %q{
  In order to use Blabbr
    As a user
    I want to see topics index
} do

  background do
    Fabricate.build(:creator)
  end

  after do
    Warden.test_reset!
  end

  scenario "Viewing topics index" do
    Fabricate(:topic)
    visit '/'
    within(:css, "#user_new") do
      fill_in 'user[email]', :with => 'email@email.com'
      fill_in 'user[password]', :with => 'password'
    end
    click_on('Sign in')
    login_as @current_user
    within(:css, '#topics') do
      page.should have_content("One topic")
    end
  end

end
