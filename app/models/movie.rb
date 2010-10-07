class Movie < ActiveRecord::Base
  
  validates_presence_of :title, :description
  validates_uniqueness_of :title
  validates_length_of :description, :minimum => 10
  validates_inclusion_of :rating, :in => ['G', 'PG', 'PG-13', 'R', 'NC-17']

  def appropriate_for_birthdate?(birthdate)
    Movie.appropriate_ratings_for_birthdate(birthdate).include? rating
  end

  def self.find_all_appropriate_for_birthdate(birthdate)
    appropriate_ratings = Movie.appropriate_ratings_for_birthdate(birthdate)
    Movie.find(:all, :conditions => {:rating => appropriate_ratings})
  end

  def self.appropriate_ratings_for_birthdate(birthdate)
    if birthdate <= (17.years.ago)
      return ['G','PG','PG-13','R','NC-17']
    elsif birthdate <= (13.years.ago)
      return ['G','PG','PG-13']
    else
      return ['G','PG']
    end
  end

end
