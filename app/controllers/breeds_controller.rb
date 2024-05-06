class BreedsController < ApplicationController
  def index
  end

  def fetch_breed
    breed = params[:breed].downcase
    response = HTTParty.get("https://dog.ceo/api/breed/#{breed}/images/random")
    if response.code == 200
      render json: { image_url: response.parsed_response["message"] }, status: :ok
    else
      render json: { error: 'Breed not found' }, status: :unprocessable_entity
    end
  end
end
