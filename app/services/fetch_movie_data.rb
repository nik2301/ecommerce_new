class FetchMovieData
  require 'uri'
  require 'net/http'

  def self.fetch_top_movies
    @url = URI("https://imdb8.p.rapidapi.com/title/get-videos?tconst=tt0944947&limit=25&region=US")
    get_response
  end

  def self.fetch_movie_detail(params)
    @url = URI("https://imdb8.p.rapidapi.com/title/get-details?tconst=#{params[:id]}")
    get_response
  end

  def self.get_response
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(@url)
    request["X-RapidAPI-Key"] = '002f00afb6msh99217d7ece0d32bp1d43cejsne7e13a364a19'
    request["X-RapidAPI-Host"] = 'imdb8.p.rapidapi.com'

    response = http.request(request)
    response.read_body
  end
end