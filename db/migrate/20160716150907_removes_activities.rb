# frozen_string_literal: true
class RemovesActivities < ActiveRecord::Migration[5.0]
  def change
    drop_table :activities
  end
end
