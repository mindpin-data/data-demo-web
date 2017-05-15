class UpdateFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :materials, :current_now
    remove_column :materials, :current_history
    remove_column :materials, :current_guiding
    remove_column :materials, :percent_change
    remove_column :materials, :now
    remove_column :materials, :history
    remove_column :materials, :guiding

    add_column :materials, :locality_1, :string
    add_column :materials, :locality_2, :string
    add_column :materials, :locality_3, :string
    add_column :materials, :locality_4, :string

    add_column :materials, :locality_1_data, :string
    add_column :materials, :locality_2_data, :string
    add_column :materials, :locality_3_data, :string
    add_column :materials, :locality_4_data, :string
  end
end
