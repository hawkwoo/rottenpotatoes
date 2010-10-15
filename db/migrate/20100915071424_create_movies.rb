class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :title
      t.text :overview
      t.string :rating
      t.float :score
      t.datetime :released_on
      t.string :genres

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
