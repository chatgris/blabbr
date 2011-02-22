# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Topics index", %q{
  In order to use Blabbr
    As a user
    I want to see topics index, and add a post
} do

  background do
    Factory.create(:creator)
  end

  after do
    Warden.test_reset!
  end

  scenario "Viewing topics index, add a post" do
    visit '/'
    within(:css, "#user_new") do
      fill_in 'user[email]', :with => 'email@email.com'
      fill_in 'user[password]', :with => 'password'
    end
    click_on('Sign in')
    click_on('Nouveau sujet')
    within(:css, '#new_topic') do
      fill_in 'topic[title]', :with => 'Awesome news'
      fill_in 'topic[post]', :with => 'Blabbr is cool'
      click_on("Submit")
    end
    page.should have_content("Awesome news")
    page.should have_content("Blabbr is cool")
    page.should have_css('#new_post')
    within(:css, '#new_post') do
      fill_in 'post[body]', :with => "New message"
    end
    click_on('Sauvegarder')
    page.should have_content('New message')
    click_on('Déconnexion')
    current_path.should == '/users/sign_in'
  end

  scenario "Viewing topics index, edit first post" do
    visit '/'
    within(:css, "#user_new") do
      fill_in 'user[email]', :with => 'email@email.com'
      fill_in 'user[password]', :with => 'password'
    end
    click_on('Sign in')
    click_on('Nouveau sujet')
    within(:css, '#new_topic') do
      fill_in 'topic[title]', :with => 'Awesome news'
      fill_in 'topic[post]', :with => 'Blabbr is cool'
      click_on("Submit")
    end
    page.should have_content("Awesome news")
    page.should have_content("Blabbr is cool")
    click_on('Éditer le message')
    page.should have_css('.edit_post', :count => 1)
    within(:css, ".edit_post") do
      fill_in 'post[body]', :with => "Capybara"
    end
    click_on('Sauvegarder')
    page.should have_content('Capybara')
    click_on('Déconnexion')
    current_path.should == '/users/sign_in'
  end

end
