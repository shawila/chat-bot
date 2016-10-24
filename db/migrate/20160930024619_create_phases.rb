class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.belongs_to :raid, index: :true

      t.string :name
      t.datetime :start

      t.timestamps null: false
    end
  end
end
