class MoviesController < ApplicationController
  def index
    @movies = FetchMovieData.fetch_top_movies
  end

  def movie_detail
    @movie = FetchMovieData.fetch_movie_detail(params)
  end
end
