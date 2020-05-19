class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :price

  belongs_to :merchant
end
