class Collaborations < ActiveRecord::Migration
  def self.up
    create_table :collaborations do |t|
      t.integer :site_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :collaborations
  end
end