class User < ApplicationRecord
  has_many :question_responses

  validates_uniqueness_of :username

  def accuracy(start_date, end_date)
    question_responses.within_dates(start_date, end_date).average(:correct)
  end

  def most_recent_answer
    question_responses.order(created_at: :desc).first
  end

  def global_accuracy_rank(start_date, end_date)
    users_ahead = other_users_accuracy_in_comparison(start_date, end_date, '>').size
    users_ahead.size + 1
  end

  def higher_ranked_users(start_date, end_date, amount = 2000)
    other_users_accuracy_in_comparison(start_date, end_date, '>').limit(amount)
  end

  def lower_ranked_users(start_date, end_date, amount = 2000)
    other_users_accuracy_in_comparison(start_date, end_date, '<').limit(amount)
  end

  # Comparison operator ex '>' or '<'
  def other_users_accuracy_in_comparison(start_date, end_date, comparison)
    User.select('users.id, users.username, avg(question_responses.correct)').
      joins(:question_responses).
      merge(QuestionResponse.within_dates(start_date, end_date)).
      group('users.id').
      having("avg(question_responses.correct) #{comparison} #{accuracy(start_date, end_date).to_s}")
  end
end
