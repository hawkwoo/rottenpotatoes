require 'spec_helper'
require 'ostruct'

describe MoviesController do
  before(:each) do
    OpenStruct.__send__(:define_method, :id) { @table[:id] || self.object_id }
    @action_genre = OpenStruct.new({:name=>"Action"})
    @adventure_genre = OpenStruct.new({:name=>"Adventure"})
    @comedy_genre = OpenStruct.new({:name=>"Comedy"})
    @tmdb_data = [OpenStruct.new({:id=>"1", :name=>"Movie A", :overview=>"A", :rating=>1.0, 
                    :released_on=>Time.at(0), :certification=>'G', :genres=>[@action_genre]}),
                  OpenStruct.new({:id=>"2", :name=>"Movie B", :overview=>"B", :rating=>2.0, 
                    :released_on=>Time.at(0), :certification=>'G', :genres=>[@action_genre]}),        
                  OpenStruct.new({:id=>3, :name=>"Movie C", :overview=>"C", :rating=>3.0, 
                    :released_on=>Time.at(0), :certification=>'G', :genres=>[@comedy_genre]}),        
                  OpenStruct.new({:id=>4, :name=>"Movie D", :overview=>"D", :rating=>4.0, 
                    :released_on=>Time.at(0), :certification=>'G', :genres=>[@action_genre, @adventure_genre, @comedy_genre]}),    
                  OpenStruct.new({:id=>5, :name=>"Movie E", :overview=>"E", :rating=>5.0, 
                    :released_on=>Time.at(0), :certification=>'G', :genres=>[@comedy_genre]})]
    @title_ids = []
    @tmdb_data.each do |movie|
      @title_ids << { :title=>movie.name, :id=>movie.id }
    end
    # Enable us to test private instance methods in MoviesController
    MoviesController.class_eval {public *MoviesController.private_instance_methods}
  end

  def mock_movie(stubs={})
    @mock_movie ||= mock_model(Movie, stubs)
  end
  
  describe "hw3 part2b: when calling the TMDb API through getFiveMoviesFromTmdb" do
    it "should return a list of 5 movies when the API call returns 5 movies" do
      TmdbMovie.stub!(:find).and_return(@tmdb_data)
      @movies = MoviesController.new.getFiveMoviesFromTmdb("X")
      @movies.should have(5).things
      @movies.should == @title_ids
    end
    
    it "should return a list of 1 movie when the API call returns 1 movie" do
      # Note that TmdbMovie returns a movie, not a collection, in this case
      TmdbMovie.stub!(:find).and_return(@tmdb_data.first)
      @movies = MoviesController.new.getFiveMoviesFromTmdb("X")
      @movies.should have(1).things
      @movies.should == [@title_ids.first]
    end
    
    it "should return a list of 0 movies when the API call returns nothing" do
      TmdbMovie.stub!(:find).and_return([])
      @movies = MoviesController.new.getFiveMoviesFromTmdb("X")
      @movies.should have(0).things
    end
  end
  
  describe "helper method tmdbGenresToString" do
    it "should return the empty string if the movie has no genres listed in TMDb" do
      @tmdb_entry = OpenStruct.new({:id=>"1", :name=>"Movie A", :overview=>"A", :rating=>1.0, 
                                    :released_on=>Time.at(0), :certification=>'G'}) # no genres
      @genres = MoviesController.new.tmdbGenresToString(@tmdb_entry.genres)
      @genres.should == ""
    end
    
    it "should return a single genre string if the movie has 1 genre listed in TMDb" do
      @tmdb_entry = @tmdb_data[1]
      @genres = MoviesController.new.tmdbGenresToString(@tmdb_entry.genres)
      @genres.should == "Action"
    end
    
    it "should return a multiple genre string if the movie has 3 genres listed in TMDb" do
      @tmdb_entry = @tmdb_data[3]
      @genres = MoviesController.new.tmdbGenresToString(@tmdb_entry.genres)
      @genres.should == "Action, Adventure, Comedy"
    end
  end
  
end