class Tokens < ActiveRecord::Migration
  def self.up
    create_table :tokens do |t|
      t.string :description
      t.string :token
    end
  end

  def self.down
    drop_table :tokens
  end
end
