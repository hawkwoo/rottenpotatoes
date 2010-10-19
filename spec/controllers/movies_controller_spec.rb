require 'spec_helper'

describe MoviesController do

  def mock_movie(stubs={})
    @mock_movie ||= mock_model(Movie, stubs)
  end

  describe "GET index" do
    it "assigns all movies as @movies" do
      Movie.stub(:find).with(:all).and_return([mock_movie])
      get :index
      assigns[:movies].should == [mock_movie]
    end
  end

  describe "GET show" do
    it "assigns the requested movie as @movie" do
      Movie.stub(:find).with("37").and_return(mock_movie)
      get :show, :id => "37"
      assigns[:movie].should equal(mock_movie)
    end
  end

=begin
  describe "GET new" do
    it "assigns a new movie as @movie" do
      Movie.stub(:new).and_return(mock_movie)
      get :new
      assigns[:movie].should equal(mock_movie)
    end
  end
=end

  describe "GET edit" do
    it "assigns the requested movie as @movie" do
      Movie.stub(:find).with("37").and_return(mock_movie)
      get :edit, :id => "37"
      assigns[:movie].should equal(mock_movie)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created movie as @movie" do
        Movie.stub(:new).with({'these' => 'params'}).and_return(mock_movie(:save => true))
        post :create, :movie => {:these => 'params'}
        assigns[:movie].should equal(mock_movie)
      end

      it "redirects to the created movie" do
        Movie.stub(:new).and_return(mock_movie(:save => true))
        post :create, :movie => {}
        response.should redirect_to(movie_url(mock_movie))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved movie as @movie" do
        Movie.stub(:new).with({'these' => 'params'}).and_return(mock_movie(:save => false))
        post :create, :movie => {:these => 'params'}
        assigns[:movie].should equal(mock_movie)
      end

=begin
      it "re-renders the 'new' template" do
        Movie.stub(:new).and_return(mock_movie(:save => false))
        post :create, :movie => {}
        response.should render_template('new')
      end
=end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested movie" do
        Movie.should_receive(:find).with("37").and_return(mock_movie)
        mock_movie.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :movie => {:these => 'params'}
      end

      it "assigns the requested movie as @movie" do
        Movie.stub(:find).and_return(mock_movie(:update_attributes => true))
        put :update, :id => "1"
        assigns[:movie].should equal(mock_movie)
      end

      it "redirects to the movie" do
        Movie.stub(:find).and_return(mock_movie(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(movie_url(mock_movie))
      end
    end

    describe "with invalid params" do
      it "updates the requested movie" do
        Movie.should_receive(:find).with("37").and_return(mock_movie)
        mock_movie.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :movie => {:these => 'params'}
      end

      it "assigns the movie as @movie" do
        Movie.stub(:find).and_return(mock_movie(:update_attributes => false))
        put :update, :id => "1"
        assigns[:movie].should equal(mock_movie)
      end

      it "re-renders the 'edit' template" do
        Movie.stub(:find).and_return(mock_movie(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested movie" do
      Movie.should_receive(:find).with("37").and_return(mock_movie)
      mock_movie.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the movies list" do
      Movie.stub(:find).and_return(mock_movie(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(movies_url)
    end
  end
  
  describe "hw3 part2a: when user submits a completely valid form and saves the record" do
    it "should be act as if it is added to the database" do
      @time = Time.now
      @fake_movie = mock_model(Movie, :title=>"the title", :overview=>"the overview", :score=>5.0, 
        :rating=>"PG", :released_on=>@time, :genres=>"Action, Drama")
      Movie.should_receive(:new).with({"title"=>"the title", "overview"=>"the overview", "score"=>"5.0", 
        "rating"=>"PG", "released_on"=>"#{@time}", "genres"=>"Action, Drama"}).and_return(@fake_movie)
      @fake_database = []
      @fake_movie.should_receive(:save) {@fake_database << @fake_movie}
      # the user action of submitting a valid form
      post :create, :movie=>{:title=>"the title", :overview=>"the overview", :score=>"5.0", :rating=>"PG", :released_on=>"#{@time}", :genres=>"Action, Drama"}
      response.should redirect_to(movie_url(@fake_movie))
      @fake_database[0].title.should == "the title"
      @fake_database[0].overview.should == "the overview"
      @fake_database[0].rating.should == "PG"
      @fake_database[0].score.should == 5.0
      @fake_database[0].genres.should == "Action, Drama"
    end
  end


end
