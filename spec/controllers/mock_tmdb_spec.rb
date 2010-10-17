require 'spec_helper'
require 'ostruct'

describe MoviesController do

  def mock_movie(stubs={})
    @mock_movie ||= mock_model(Movie, stubs)
  end
  
  describe "hw3 part2b: when calling the TMDb api" do
    before(:each) do
      @tmdb_data = [OpenStruct.new({:id=>1, :name=>"Movie A", :overview=>"A", :rating=>1.0, 
                                    :released_on=>Time.at(0), :certification=>'G', :genres=>["Action"]}),
                    OpenStruct.new({:id=>2, :name=>"Movie B", :overview=>"B", :rating=>2.0, 
                                    :released_on=>Time.at(0), :certification=>'G', :genres=>["Action", "Adventure"]}),        
                    OpenStruct.new({:id=>3, :name=>"Movie C", :overview=>"C", :rating=>3.0, 
                                    :released_on=>Time.at(0), :certification=>'G', :genres=>["Comedy"]}),        
                    OpenStruct.new({:id=>4, :name=>"Movie D", :overview=>"D", :rating=>4.0, 
                                    :released_on=>Time.at(0), :certification=>'G', :genres=>["Drama"]}),    
                    OpenStruct.new({:id=>5, :name=>"Movie E", :overview=>"E", :rating=>5.0, 
                                    :released_on=>Time.at(0), :certification=>'G', :genres=>["Science Fiction"]})]
      @title_ids = []
      @tmdb_data.each do |movie|
        @title_ids << { :title=>movie.name, :id=>movie.id }
      end
    end
  
    it "should return a list of 5 {title, id} pairs from getFiveMoviesFromTmdb" do
      TmdbMovie.stub!(:find).and_return(@tmdb_data)
      @movies = MoviesController.new.getFiveMoviesFromTmdb("X")
      @movies.should have(5).things
      @movies.should == @title_ids
    end
    
  end
  
end