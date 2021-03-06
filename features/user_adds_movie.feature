Feature: User adds movie

  In order to easily add movies
  As a user
  I want to be able to enter a title and select one of 5 movies to add

	Scenario: go to search page
	  Given I am on the movies page
	  When I follow "Add a movie"
	  Then I should be on the title search page
		And I should see "Title:"
		And I should not see "Rating:"
		And I should not see "Release date:"
		
	Scenario: search for title
		Given I am on the title search page
		When I fill in "title" with "The Matrix"
		And I press "Search"
		Then I should be on the search results page
		And I should see "The Matrix"
		And I should see "The Matrix Revisited"
		And I should see "Matrix Dezionised"
		And I should see "The Matrix Reloaded"
		And I should see "The Matrix Revolutions"
		And I should see "None of these"
		
	Scenario: search for another title (with only one search result from TMDB)
		Given I am on the title search page
		When I fill in "title" with "District 9"
		And I press "Search"
		Then I should be on the search results page
		And I should see "District 9"
		And I should see "None of these"
	
	Scenario: search for another title (with 0 search results from TMDB)
		Given I am on the title search page
		When I fill in "title" with "Nonexistant Movie"
		And I press "Search"
		Then I should be on the title search page
		And I should see "Movie not found"
		
	Scenario: select 'None of these'
		Given I am at the search results page for "Wall-E"
		When I follow "None of these"
		Then I should be on the title search page
		
	Scenario: select a title from search results
		Given I am at the search results page for "The Matrix Reloaded"
		When I follow "The Matrix Reloaded"
		Then I should be on the add movie page
		And the "title" field should contain "The Matrix Reloaded"
		And the "overview" field should contain "In this second chapter of the"
		And the "score" field should contain "6.2"
		And the "rating" field should contain "R"
		And the "genres" field should contain "Action, Science Fiction"
		
	Scenario: see the added movie on the movies page
		Given I have added "Air Force One"
		When I go to the movies page
		Then I should see "Air Force One"




  

