class AddTables < ActiveRecord::Migration[5.0]
  def change
    create_table :obor_countries do |t|
      t.string :name
      t.string :code
      t.decimal :total
      t.decimal :percent_change
      t.string :now
      t.string :history
    end

    create_table :city_amounts do |t|
      t.string :name
      t.string :amount
      t.decimal :long
      t.decimal :lat
      t.boolean :in_china
    end

    create_table :total_amounts do |t|
      t.decimal :total
      t.decimal :export
      t.string :now
      t.string :forecast
      t.string :history
    end
  end
end
