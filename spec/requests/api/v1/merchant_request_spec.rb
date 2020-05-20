require 'rails_helper'

RSpec.describe "Merchant API" do
  it "Merchant Index" do
    create_list(:merchant, 4)

    get "/api/v1/merchants"

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants["data"].count).to eq(4)
  end
  it "Merchant Show" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq("#{id}")
  end
  it "Merchant Creation" do
    merchant_params = {
      name: "Austerity"
    }

    post "/api/v1/merchants", params: { merchant: merchant_params }
    merchant = Merchant.last

    expect(response).to be_successful
    expect(merchant.name).to eq(merchant_params[:name])
  end
  it "Merchant Update" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: "Austerity" }

    put "/api/v1/merchants/#{id}", params: { merchant: merchant_params }
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq("Austerity")
  end
  it "Merchant Destroy" do
    merchant = create(:merchant)

    expect{ delete "/api/v1/merchants/#{merchant.id}" }.to change(Merchant, :count). by(-1)

    expect(response).to be_successful
    expect{Item.find(item.id).to raise_error(ActoveRecord::RecordNotFound)}
  end
  it "Merchant Item Relationship" do
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant_id: merchant_1.id)
    item_2 = create(:item, merchant_id: merchant_1.id)
    item_3 = create(:item, merchant_id: merchant_1.id)
    item_4 = create(:item, merchant_id: merchant_1.id)

    merchant_2 = create(:merchant)
    item_5 = create(:item, merchant_id: merchant_2.id)
    item_6 = create(:item, merchant_id: merchant_2.id)
    item_7 = create(:item, merchant_id: merchant_2.id)

    get "/api/v1/merchants/#{merchant_1.id}/items"
    items_response = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items_response[:data].count).to eq(4)
  end
end
