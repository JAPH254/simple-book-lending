class AddAvailableToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :available, :boolean
  end
end
