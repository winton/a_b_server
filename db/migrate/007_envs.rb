class Envs < ActiveRecord::Migration
  def self.up
    create_table :envs do |t|
      t.string :name
      t.integer :user_id
    end
    add_index :envs, :user_id
  end

  def self.down
    drop_table :envs
  end
end
