require 'csv'

namespace :db do
  desc "This task seeds our database"
    task seed_development_db: [:environment] do
      system'rake db:reset'
      # folder = "db/seeds"
      # all_files = Dir.entries(folder)
      # ordered_files = [all_files[3], all_files[5], all_files[7], all_files[2], all_files[4], all_files[6]]

      # Dir.foreach(folder) do |file|
      #   next if file == '.' or file == '..'
      ordered_files = [
        "db/seeds/customers.csv",
        "db/seeds/merchants.csv",
        "db/seeds/items.csv",
        "db/seeds/invoices.csv",
        "db/seeds/invoice_items.csv",
        "db/seeds/transactions.csv"
      ]

      ordered_files.each do |filepath|
        CSV.foreach(filepath, :headers => true) do |row|
          row_hash = row.to_h.symbolize_keys
          # row_hash.delete(:id)
          if row_hash[:unit_price]
            row_hash[:unit_price] = row_hash[:unit_price].to_d / 100
          end
          file_name = filepath.delete_prefix('db/seeds/').delete_suffix('s.csv')
          class_name = file_name.classify.constantize()
          class_name.create(row_hash)
        end
      end
    end
end
