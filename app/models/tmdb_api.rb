require 'hpricot'
require 'open-uri'
require 'ostruct'
require 'movie'
require 'uri'
require 'cgi'

class TmdbApi
  
  @@api_key = "0e4d2f4ef3b595d34223dd7f2f51767d"
  
  # call the TMDb API and return all the titles and id associated
  # with the title
  def tmdbApiCall(title)
    movies = Array.new
    doc = Hpricot(open(URI.escape("http://api.themoviedb.org/2.1/Movie.search/en/xml/"+@@api_key+"/"+title)))
    doc.search("//movie").each do |movie|
      if movies.length < 5
        id = movie.at("id").inner_html
        movies << getOneMovieFromTmdb(id)
      end
      #movies << {:title => movie.at("name").inner_html, :id => movie.at("id").inner_html}
    end
    movies
  end
  
  # returns a collection of 5 {title, id} pairs
  # corresponding to search results for title
  def getFiveMoviesFromTmdb(title)
    movies = Array.new
    tmdbMovies = tmdbApiCall(title)
    tmdbMovies = [tmdbMovies] if not tmdbMovies.is_a? Enumerable
    tmdbMovies[0..4].each do |movie|
      movies << {:title => movie.name, :id => movie.tmdb_id}
    end
    movies
  end

  # returns a Tmdb entry for the id
  # a Tmdb 'entry' consists of name, overview, rating, certification, 
  #   release date, and an array of genres
  def getOneMovieFromTmdb(id)
    entry = OpenStruct.new
    doc = Hpricot(open(URI.escape("http://api.themoviedb.org/2.1/Movie.getInfo/en/xml/"+@@api_key+"/"+id)))
    entry.tmdb_id = id
    entry.name = CGI.unescapeHTML(doc.at("name").inner_html)
    entry.overview = CGI.unescapeHTML(doc.at("overview").inner_html) if doc.at("overview")
    entry.rating = doc.at("rating").inner_html if doc.at("rating")
    entry.certification = doc.at("certification").inner_html if doc.at("certification")
    entry.released = doc.at("released").inner_html if doc.at("released")
    entry.genres = Array.new
    (doc/"categories/category").each do |category|
      entry.genres << category.attributes['name']
    end
    entry
  end

  # returns a Movie with the fields from a Tmdb entry
  def createMovieFromTmdbResult(entry)
    movie = Movie.new
    movie.title = entry.name
    movie.overview = entry.overview if entry.overview
    movie.score = entry.rating.to_f if entry.rating
    movie.rating = entry.certification if entry.certification
    movie.released_on = Time.parse(entry.released) if entry.released
    movie.genres = tmdbGenresToString(entry.genres) if entry.genres
    movie
  end

  def tmdbGenresToString(genres)
    result = ""
    if genres
      genres.each do |genre|
        result += (genre + ", ")
      end
      result = result[0, result.length - 2] if not result.empty?
    end
    result
  end

end
