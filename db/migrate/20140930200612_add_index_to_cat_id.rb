class AddIndexToCatId < ActiveRecord::Migration
  def change
    add_index :cat_rental_requests, :cat_id
  end
end
