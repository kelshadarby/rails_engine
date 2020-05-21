class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  belongs_to :merchant
  validates_presence_of :name, uniqueness: {case_sensitive: false}
  validates_presence_of :description, uniqueness: {case_sensitive: false}
  validates_presence_of :unit_price
end
