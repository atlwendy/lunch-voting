class YelpQuery
  def initialize(location, term)
    @location = location
    @term = term || 'restaurants'
    @secret_loc = Location.new(
      :radius => 5,
      :term => @term
    )
  end
  
  def base_url
    @secret_loc.base_url
  end

  def pull_results(a, b)
    @secret_loc.pull_results(a, b)
  end

  def response_format
    @secret_loc.response_format
  end

  def to_yelp_params
    @secret_loc.to_yelp_params.merge({
      :location => @location
    })
  end
end