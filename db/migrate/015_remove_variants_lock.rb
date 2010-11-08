class RemoveVariantsLock < ActiveRecord::Migration
  def self.up
    remove_column :variants, :lock_version
  end

  def self.down
    add_column :variants, :lock_version, :integer, :default => 0
  end
end
