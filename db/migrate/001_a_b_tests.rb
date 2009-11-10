class ABTests < ActiveRecord::Migration
  def self.up
    create_table :a_b_tests do |t|
      t.string :name
      t.string :ticket_url
    end
  end

  def self.down
    drop_table :a_b_tests
  end
end
