class AddHintsToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :question_hint, :string
  end

  def self.down
    remove_column :questions, :question_hint, :string
  end
end
