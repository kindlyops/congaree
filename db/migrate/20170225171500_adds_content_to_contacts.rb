class AddsContentToContacts < ActiveRecord::Migration[5.0]
  def change
    change_table :contacts do |t|
      t.text :content
      t.boolean :candidate, null: false, default: false
    end
  end
end
