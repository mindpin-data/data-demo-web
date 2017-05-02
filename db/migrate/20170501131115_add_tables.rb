class AddTables < ActiveRecord::Migration[5.0]
  def change
    create_table :obor_countries do |t|
      t.string :name
      t.string :code
      t.float :total
      t.float :percent_change
      t.string :now
      t.string :history
    end

    create_table :city_amounts do |t|
      t.string :name
      t.string :amount
      t.float :long
      t.float :lat
      t.boolean :in_china
    end

    create_table :total_amounts do |t|
      t.float :total
      t.float :export
      t.string :now
      t.string :forecast
      t.string :history
    end

    create_table :materials do |t|
      t.string :name
      t.string :color
      t.float :current_now
      t.float :current_history
      t.float :current_guiding
      t.float :percent_change
      t.string :now
      t.string :history
      t.string :guiding
    end

    create_table :scourges do |t|
      t.string :name
      t.string :scourge
      t.string :date
      t.float :long
      t.float :lat
    end

    create_table :localities do |t|
      t.string :material
      t.float :amount
      t.float :long
      t.float :lat
    end
  end
end
