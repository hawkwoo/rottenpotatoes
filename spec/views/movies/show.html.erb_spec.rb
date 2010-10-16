require 'spec_helper'

describe "/movies/show.html.erb" do
  include MoviesHelper
  before(:each) do
    assigns[:movie] = @movie = stub_model(Movie,
      :title => "value for title",
      :overview => "value for overview",
      :score => "0.0",
      :rating => "value for rating",
      :genres => "value for genres"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ overview/)
    response.should have_text(/0\.0/)
    response.should have_text(/value\ for\ rating/)
    response.should have_text(/value\ for\ genres/)
  end

end
