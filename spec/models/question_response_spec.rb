require 'rails_helper'

describe QuestionResponse, type: :model do
  it 'should only return models within date range' do
    user = User.create(username: 'user', timezone: ActiveSupport::TimeZone.all.first)
    QuestionResponse.create(user: user, created_at: 2.weeks.ago + 1.minute)
    QuestionResponse.create(user: user, created_at: 3.weeks.ago - 1.minute)
    response1 = QuestionResponse.create(user: user, created_at: 3.weeks.ago + 1.minute)
    response2 = QuestionResponse.create(user: user, created_at: 2.weeks.ago - 1.minute)

    expect(QuestionResponse.within_dates(3.weeks.ago, 2.weeks.ago).pluck(:id)).to match_array [response1.id, response2.id]
  end
end
