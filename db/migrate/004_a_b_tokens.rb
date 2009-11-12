class ABTokens < ActiveRecord::Migration
  def self.up
    create_table :a_b_tokens do |t|
      t.string :token
      t.timestamps
    end
  end

  def self.down
    drop_table :a_b_tokens
  end
end
