class AddScreeningUniquenessConstraints < ActiveRecord::Migration
  def change
    add_index :search_questions, [:search_id, :question_id], unique: true
    add_index :search_leads, [:search_id, :lead_id], unique: true
    add_index :inquiries, [:search_lead_id, :search_question_id], unique: true, name: "index_by_search_lead_and_search_question"
  end
end
