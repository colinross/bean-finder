class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address_line_1
      t.string :address_line_2
      t.string :postal_code_name
      t.string :postal_code_suffix
      t.string :phone_number
      t.decimal :radius, precision: 5, scale: 2 # 0.01 - 999.99 Miles
      t.st_point :lonlat, geographic: true

      t.timestamps null: false

      t.index :lonlat, using: :gist
    end
  end
end
