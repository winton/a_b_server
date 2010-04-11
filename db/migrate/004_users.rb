class Users < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.boolean :admin
      t.integer :identifier
      t.string :token
    end
  end

  def self.down
    drop_table :users
  end
end
