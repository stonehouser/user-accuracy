class QuestionResponse < ApplicationRecord
  belongs_to :user

  scope :within_dates, -> (start_date, end_date) { where('question_responses.created_at >= ? AND question_responses.created_at <= ?', start_date, end_date) }
end
