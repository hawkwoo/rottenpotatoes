class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.xml
  def index
    @movies = Movie.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @movies }
    end
  end

  def search
    @movie = Movie.new

    respond_to do |format|
      format.html # search.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  def results
    @movie = Movie.new(params[:movie])
    
    if params[:title].empty?
      redirect_to("/movies/search", :notice => "Please enter a valid title.")
    else
      @results = getFiveMoviesFromTmdb(params[:title])
      if @results.empty?
        redirect_to("/movies/search", :notice => "Movie not found.")
      end
    end
  end
  
  # returns a collection of 5 {title, id} pairs
  # corresponding to search results for title
  def getFiveMoviesFromTmdb(title)
    Tmdb.api_key = "0e4d2f4ef3b595d34223dd7f2f51767d"
    searchResults = TmdbMovie.find(:title=>title, :limit=>5, :expand_results=>false)
    # if find returns just one movie, wrap it in an array
    searchResults = [searchResults] if not searchResults.is_a? Enumerable
    results = []
    searchResults.each do |movie|
      results << 
      {
        :title => movie.name,
        :id => movie.id,
        :score => movie.score
      }
    end
    results
  end
  
  # returns a Tmdb entry for the title
  def getOneMovieFromTmdb(id)
    Tmdb.api_key = "0e4d2f4ef3b595d34223dd7f2f51767d"
    movie = TmdbMovie.find(:id=>id, :limit=>1, :expand_results=>false)
  end
  
  # returns a Movie with the fields from a Tmdb entry
  def createMovieFromTmdbResult(entry)
    movie = Movie.new
    movie.title = entry.name
    movie.overview = entry.overview
    movie.score = entry.rating.to_f
    movie.rating = entry.certification
    movie.released_on = Time.parse(entry.released)
    movie.genres = tmdbGenresToString(entry.genres)
    movie
  end
  
  def tmdbGenresToString(genres)
    result = ""
    if genres
      genres.each do |genre|
        result += (genre.name + ", ")
      end
      result = result[0, result.length - 2] if not result.empty?
    end
    result
  end
  
  def add
    @movie = createMovieFromTmdbResult(getOneMovieFromTmdb(params[:id]))
    @id = params[:id]
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movie }
    end
  end

=begin
  # GET /movies/new
  # GET /movies/new.xml
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @movie }
    end
  end
=end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.xml
  def create
    @movie = createMovieFromTmdbResult(getOneMovieFromTmdb(params[:id]))

    respond_to do |format|
      if @movie.save
        format.html { redirect_to(@movie, :notice => 'Movie was successfully created.') }
        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
      else
        format.html { render :action => "search" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.xml
  def update
    @movie = Movie.find(params[:id])

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to(@movie, :notice => 'Movie was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.xml
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to(movies_url) }
      format.xml  { head :ok }
    end
  end
end
