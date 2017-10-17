class ChangeScourgesFields < ActiveRecord::Migration[5.0]
  def change
    rename_column :scourges, :date, :cdate
    rename_column :scourges, :long, :lon
  end
end
