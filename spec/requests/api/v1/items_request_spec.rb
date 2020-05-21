require 'rails_helper'

RSpec.describe "Items API" do
  it "Item Index" do
    merchant = create(:merchant)
    create(:item, merchant_id: merchant.id)
    create(:item, merchant_id: merchant.id)
    create(:item, merchant_id: merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items["data"].count).to eq(3)
  end
  it "Item Show" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["id"]).to eq("#{id}")
  end
  it "Item Creation" do
    merchant = create(:merchant)
    item_params = {
      name: "The G.O.B",
      description: "A frozen banana double dipped in chocolate with double the nuts",
      unit_price: 3.65,
      merchant_id: merchant.id
    }

    post "/api/v1/items", params: { item: item_params }
    item = Item.last

    expect(response).to be_successful
    expect(item.name).to eq(item_params[:name])
    expect(item.description).to eq(item_params[:description])
    expect(item.unit_price).to eq(item_params[:unit_price])
    expect(merchant.items).to eq([item])
  end
  it "Item Update" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id
    previous_name = Item.last.name
    item_params = { name: "Bluth Frozen Banana" }

    put "/api/v1/items/#{id}", params: { item: item_params }
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Bluth Frozen Banana")
  end
  it "Item Destroy" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
  it "Item Merchant Relationship" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"
    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["merchant_id"]).to eq(merchant.id)
    expect(merchant_response["data"]["attributes"]["name"]).to eq(merchant.name)
  end
  describe "Item Single Find" do
    before :each do
      merchant = create(:merchant)
      @item_1 = create(:item, merchant_id: merchant.id, name: "Bluth Model Home")
      @item_2 = create(:item, merchant_id: merchant.id, name: "Sudden Valley")
      @item_3 = create(:item, merchant_id: merchant.id, name: "G.O.B's Illusions", unit_price: 17.18)
      @item_4 = create(:item, merchant_id: merchant.id, name: "Unlimited JUICE?!", description: "This party is going to be off the hook!")
    end
    it "Name Attribute" do
      name = "Bluth Model Home"

      get "/api/v1/items/find?name=#{name}"
      single_find_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(single_find_response["data"]["attributes"]["id"]).to eq(@item_1.id)
      expect(single_find_response["data"]["attributes"]["name"]).to eq(@item_1.name)
    end
    it "ID Attribute" do
      get "/api/v1/items/find?id=#{@item_2.id}"
      single_find_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(single_find_response["data"]["attributes"]["id"]).to eq(@item_2.id)
      expect(single_find_response["data"]["attributes"]["name"]).to eq(@item_2.name)
    end
    it "Unit Price Attribute" do
      get "/api/v1/items/find?unit_price=#{@item_3.unit_price}"
      single_find_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(single_find_response["data"]["attributes"]["id"]).to eq(@item_3.id)
      expect(single_find_response["data"]["attributes"]["name"]).to eq(@item_3.name)
    end
    it "Description Attrubte" do
      get "/api/v1/items/find?description=#{@item_4.description}"
      single_find_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(single_find_response["data"]["attributes"]["id"]).to eq(@item_4.id)
      expect(single_find_response["data"]["attributes"]["name"]).to eq(@item_4.name)
    end
    it "Partial String Search Case Sensitive" do
      get "/api/v1/items/find?name=JUICE"
      single_find_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(single_find_response["data"]["attributes"]["id"]).to eq(@item_4.id)
      expect(single_find_response["data"]["attributes"]["name"]).to eq(@item_4.name)
    end
    it "Partial String Search Case Inensitive" do
      get "/api/v1/items/find?name=juice"
      single_find_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(single_find_response["data"]["attributes"]["id"]).to eq(@item_4.id)
      expect(single_find_response["data"]["attributes"]["name"]).to eq(@item_4.name)
    end
  end
end
