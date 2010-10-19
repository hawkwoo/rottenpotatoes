require 'spec_helper'
require 'ostruct'

describe TmdbApi do
  before(:each) do
    #OpenStruct.__send__(:define_method, :id) { @table[:id] || self.object_id }
    @action_genre, @adventure_genre, @comedy_genre = "Action", "Adventure", "Comedy"
    @tmdb_data = [OpenStruct.new({:tmdb_id=>1, :name=>"Movie A", :overview=>"A", :rating=>1.0, 
                    :released_on=>Time.at(0), :certification=>'G', :genres=>[@action_genre]}),
                  OpenStruct.new({:tmdb_id=>2, :name=>"Movie B", :overview=>"B", :rating=>2.0, 
                    :released_on=>Time.at(0), :certification=>'G', :genres=>[@action_genre]}),        
                  OpenStruct.new({:tmdb_id=>3, :name=>"Movie C", :overview=>"C", :rating=>3.0, 
                    :released_on=>Time.at(0), :certification=>'G', :genres=>[@comedy_genre]}),        
                  OpenStruct.new({:tmdb_id=>4, :name=>"Movie D", :overview=>"D", :rating=>4.0, 
                    :released_on=>Time.at(0), :certification=>'G', :genres=>[@action_genre, @adventure_genre, @comedy_genre]}),    
                  OpenStruct.new({:tmdb_id=>5, :name=>"Movie E", :overview=>"E", :rating=>5.0, 
                    :released_on=>Time.at(0), :certification=>'G', :genres=>[@comedy_genre]}),
                  OpenStruct.new({:tmdb_id=>6, :name=>"Movie F", :overview=>"F", :rating=>6.0, 
                    :released_on=>Time.at(0), :certification=>'G', :genres=>[@comedy_genre]})]
    @title_ids = []
    @tmdb_data.each do |movie|
      @title_ids << { :title=>movie.name, :id=>movie.tmdb_id }
    end
  end

  describe "hw3 part2b: when calling the TMDb API through getFiveMoviesFromTmdb" do
    it "should return a list of 5 movies when the API call returns 5 movies" do
      @tmdb_api = TmdbApi.new
      @tmdb_api.stub!(:tmdbApiCall).and_return(@tmdb_data)
      @movies = @tmdb_api.getFiveMoviesFromTmdb("X")
      @movies.should have(5).things
      @movies.should == @title_ids[0..4]
    end
    
    it "should return a list of 1 movie when the API call returns 1 movie" do
      @tmdb_api = TmdbApi.new
      @tmdb_api.stub!(:tmdbApiCall).and_return(@tmdb_data.first)
      @movies = @tmdb_api.getFiveMoviesFromTmdb("X")
      @movies.should have(1).things
      @movies.should == [@title_ids.first]
    end

    it "should add one of the 5 movies to the database" do
      @tmdb_api = TmdbApi.new
      @tmdb_api.stub!(:tmdbApiCall).and_return(@tmdb_data)
      @fake_database = []
      @tmdb_entry = @tmdb_api.tmdbApiCall[3]
      @movie = @tmdb_api.createMovieFromTmdbResult(@tmdb_entry)
      @movie.stub!(:save) {@fake_database << @movie}
      @movie.save
      @fake_database[0].title.should == "Movie D"
      @fake_database[0].overview.should == "D"
      @fake_database[0].rating.should == "G"
      @fake_database[0].score.should == 4.0
      @fake_database[0].genres.should == "Action, Adventure, Comedy"
    end
    
    it "should return a list of 0 movies when the API call returns nothing" do
      @tmdb_api = TmdbApi.new
      @tmdb_api.stub!(:tmdbApiCall).and_return([])
      @movies = @tmdb_api.getFiveMoviesFromTmdb("X")
      @movies.should have(0).things
    end
  end
  
  describe "hw3 part3: when calling the TMDb API through getFiveMoviesFromTmdb" do
    it "should return a list of 1 movie when searching for District 9" do
      @movies = TmdbApi.new.getFiveMoviesFromTmdb("District 9")
      @movies.should have(1).things
      @movies.first[:title].should == "District 9"
    end
    
    it "should return a list without the title of Wall-E when searching for Wall-E" do
      @movies = TmdbApi.new.getFiveMoviesFromTmdb("Wall-E")
      @movies.each do |movie|
        movie[:title].should_not == "Wall-E"
      end
    end

    it "should return a list of 5 movie when searching for The Matrix" do
      @movies = TmdbApi.new.getFiveMoviesFromTmdb("The Matrix")
      @movies.should have(5).things
      @movies.first[:title].should == "The Matrix"
    end
    
    it "should return a list of 1 movie when searching for The Matrix Reloaded" do
      @movies = TmdbApi.new.getFiveMoviesFromTmdb("The Matrix Reloaded")
      @movies.should have(1).things
      @movies.first[:title].should == "The Matrix Reloaded"
    end

    it "should add the selected movie to the database when all form fields are present" do
      @movies = TmdbApi.new.getFiveMoviesFromTmdb("District 9")
      @movie = @movies.first
      @movie = TmdbApi.new.getOneMovieFromTmdb(@movie[:id])
      @movie = TmdbApi.new.createMovieFromTmdbResult(@movie)
      @movie.save!
      Movie.find_by_title("District 9").should be_valid
    end

    it "should add the selected movie to the database when not all form fields are present" do
      @movies = TmdbApi.new.getFiveMoviesFromTmdb("Snow White")
      @movie = @movies.first
      @movie = TmdbApi.new.getOneMovieFromTmdb(@movie[:id])
      @movie = TmdbApi.new.createMovieFromTmdbResult(@movie)
      @movie.save!
      Movie.find_by_title("Snow White").should be_valid
    end

    it "should return a list of 0 movies when the API call returns nothing" do
      @movies = TmdbApi.new.getFiveMoviesFromTmdb("nonexistent")
      @movies.should have(0).things
    end
  end

  describe "helper method tmdbGenresToString" do
    it "should return the empty string if the movie has no genres listed in TMDb" do
      @tmdb_entry = OpenStruct.new({:id=>"1", :name=>"Movie A", :overview=>"A", :rating=>1.0, 
                                    :released_on=>Time.at(0), :certification=>'G'}) # no genres
      @genres = TmdbApi.new.tmdbGenresToString(@tmdb_entry.genres)
      @genres.should == ""
    end
    
    it "should return a single genre string if the movie has 1 genre listed in TMDb" do
      @tmdb_entry = @tmdb_data[1]
      @genres = TmdbApi.new.tmdbGenresToString(@tmdb_entry.genres)
      @genres.should == "Action"
    end
    
    it "should return a multiple genre string if the movie has 3 genres listed in TMDb" do
      @tmdb_entry = @tmdb_data[3]
      @genres = TmdbApi.new.tmdbGenresToString(@tmdb_entry.genres)
      @genres.should == "Action, Adventure, Comedy"
    end
  end

  
end
