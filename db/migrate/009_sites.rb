class Sites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :name
      t.integer :user_id
    end
  end

  def self.down
    drop_table :sites
  end
end