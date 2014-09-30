class RemoveUniqueFromCatId < ActiveRecord::Migration
  def change
    remove_index :cat_rental_requests, :cat_id
  end
end
