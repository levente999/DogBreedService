require 'rails_helper'

RSpec.describe BreedsController, type: :controller do
  # Helper method to stub requests to the Dog API
  def stub_dog_api(breed, status:, body: nil)
    stub_request(:get, "https://dog.ceo/api/breed/#{breed}/images/random")
      .to_return(status: status, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  describe "POST #fetch_breed" do
    let(:breed_name) { 'poodle' }
    let(:unknown_breed) { 'unknown' }

    context "when breed is found" do
      before do
        stub_dog_api(breed_name, status: 200, body: { message: "http://example.com/image.jpg" })
        post :fetch_breed, params: { breed: breed_name }, as: :json
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns correct image url" do
        expect(JSON.parse(response.body)['image_url']).to eq('http://example.com/image.jpg')
      end
    end

    context "when breed is not found" do
      before do
        stub_dog_api(unknown_breed, status: 404, body: { message: "Breed not found" })
        post :fetch_breed, params: { breed: unknown_breed }, as: :json
      end

      it "handles not found error gracefully" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include('Breed not found')
      end
    end
  end
end
