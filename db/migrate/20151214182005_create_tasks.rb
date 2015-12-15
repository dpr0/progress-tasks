class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :state, default: 'new'
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
