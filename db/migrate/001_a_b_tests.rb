class ABTests < ActiveRecord::Migration
  def self.up
    create_table :a_b_tests do |t|
      t.string :name
      t.string :ticket_url
      t.timestamps
    end
    add_index :a_b_tests, :name
  end

  def self.down
    drop_table :a_b_tests
  end
end
