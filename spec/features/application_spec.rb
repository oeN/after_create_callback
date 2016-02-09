require 'rails_helper'

describe "I can see the front page", type: :feature, js: true do

  it "the title is visible" do
    visit root_path
    expect(page).to have_selector 'h1#welcome_title'
  end
end
