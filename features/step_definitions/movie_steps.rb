Given /I am at the search results page for "([^"]*)"$/ do |movie_name|
  visit path_to('title search page')
  fill_in('title', :with=>movie_name)
  click_button('Search')
end

Given /I have added "([^"]*)"$/ do |movie_name|
  visit path_to('title search page')
  fill_in('title', :with=>movie_name)
  click_button('Search')
  click_link(movie_name)
  click_button('Add')
end