# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Topics index", %q{
  In order to use Blabbr
    As a user
    I want to see topics index, and add a post
} do

  background do
    Fabricate.build(:creator)
  end

  after do
    Warden.test_reset!
  end

  scenario "Viewing topics index, add a post" do
    Fabricate(:topic)
    visit '/'
    within(:css, "#user_new") do
      fill_in 'user[email]', :with => 'email@email.com'
      fill_in 'user[password]', :with => 'password'
    end
    click_on('Sign in')
    click_on("One topic")
    page.should have_css('#new_post')
    within(:css, '#new_post') do
      fill_in 'post[body]', :with => "New message"
    end
    click_on('Sauvegarder')
    save_and_open_page
    page.should have_content('New message')
  end

  scenario "Viewing topics index, edit first post" do
    Fabricate(:topic)
    visit '/'
    within(:css, "#user_new") do
      fill_in 'user[email]', :with => 'email@email.com'
      fill_in 'user[password]', :with => 'password'
    end
    click_on('Sign in')
    within(:css, '#topics') do
      page.should have_content("One topic")
    end
    click_on("One topic")
    page.should have_css('.post')
    within(:css, '.post') do
      page.should have_content('Some content')
    end
    click_on('Éditer le message')
    page.should have_css('.edit_post', :count => 1)
    within(:css, ".edit_post") do
      fill_in 'post[body]', :with => "Capybara"
    end
    click_on('Sauvegarder')
    page.should have_content('Capybara')
    click_on('Déconnexion')
  end



end
