require 'csv'

namespace :users do
  desc "Populate users and question_responses"
  task populate: :environment do
    USERS_TO_INSERT = 500000
    RESPONSES_PER_USER = 10000
    MAX_INSERTS_PER_QUERY = 1000

    db_config = Rails.application.config.database_configuration[Rails.env]
    time_zones = ActiveSupport::TimeZone.all.map(&:name)
    created_at = (Time.current - 6.months).to_s

    client = Mysql2::Client.new(host: db_config['host'], username: db_config['username'] , password: db_config['password'], database: db_config['database'], flags: Mysql2::Client::MULTI_STATEMENTS)
    client.query "SET FOREIGN_KEY_CHECKS = 0; SET UNIQUE_CHECKS = 0; SET SESSION tx_isolation='READ-UNCOMMITTED'; SET sql_log_bin = 0;"
    client.abandon_results!

    user_count = 0
    (USERS_TO_INSERT / MAX_INSERTS_PER_QUERY).times do |insert|
      user_inserts = 'INSERT INTO users (username, timezone, created_at) VALUES '
      MAX_INSERTS_PER_QUERY.times do |row|
        user_inserts.concat(" ('user_#{user_count += 1}', #{ActiveRecord::Base.connection.quote(time_zones.sample)}, '#{created_at}') ")
        user_inserts.concat(row == (MAX_INSERTS_PER_QUERY - 1) ? ';' : ',')
      end
      client.query user_inserts
    end

    responses_start_time = Time.current - 6.months
    seconds_since_start_time = Time.current.to_i - responses_start_time.to_i

    puts "Inserting #{USERS_TO_INSERT * RESPONSES_PER_USER} question_responses"
    question_responses_counter = 0
    (RESPONSES_PER_USER / MAX_INSERTS_PER_QUERY).times do
      responses_insert = ''
      MAX_INSERTS_PER_QUERY.times do |t|
        responses_insert.concat("INSERT INTO question_responses (user_id, correct, created_at) SELECT id, ROUND(RAND()), FROM_UNIXTIME(UNIX_TIMESTAMP('#{responses_start_time}') + FLOOR(0 + (RAND() * #{seconds_since_start_time})) ) FROM users;\n")
      end
      client.query responses_insert
      while client.next_result
        # Wait to process
      end
      question_responses_counter += MAX_INSERTS_PER_QUERY * USERS_TO_INSERT
      print("Inserted #{question_responses_counter} question_responses\r")
    end
  end
end
