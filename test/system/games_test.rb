require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit games_url
  #
  #   assert_selector "h1", text: "Game"
  # end

  test "Going to /new gives us a new random grid to play with" do
    p "Visit the New Game Page"
    visit new_url
    assert test: "New game"
    assert_selector "p", count: 10
  end

  test "Giving a word and click on play give us the score" do
    p "Try playing"
    visit new_url
    fill_in "word", with: "hello"
    click_on "Play!"
    assert_text "Sorry hello is not in the grid\nPlay again!"
  end


end
