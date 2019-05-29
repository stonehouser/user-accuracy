class UsersController < ApplicationController
  def search
    if params[:commit].present?

      unless params[:username].present? && params[:start_date].present? && params[:end_date].present? && params[:week_start_date].present?
        flash[:notice] = 'Please enter missing fields'
        return
      end

      @user = User.find_by(username: params[:username])

      if @user.present?
        start_date = params[:start_date].in_time_zone(@user.timezone)
        end_date = params[:end_date].in_time_zone(@user.timezone)
        week_start_date = params[:week_start_date].in_time_zone(@user.timezone)
        week_end_date = (week_start_date + 1.week)

        @accuracy = @user.accuracy(start_date, end_date)
        @accuracy_current_month = @user.accuracy(Time.now.in_time_zone(@user.timezone).beginning_of_month, Time.now)
        @global_accuracy_rank = @user.global_accuracy_rank(start_date, end_date)

        @higher_ranked_users_for_week = @user.higher_ranked_users(week_start_date, week_end_date)
        @lower_ranked_users_for_week = @user.lower_ranked_users(week_start_date, week_end_date)
      end
    end
  end
end
