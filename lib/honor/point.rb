module Honor
  class Point < ActiveRecord::Base
    attr_accessible :category, :message, :user_id, :value

    #after_save :update_scorecard

    class << self
      def give_to(user_id, number_of_points, message = "Manually granted through 'add_points'", category = 'default')
        create!({user_id: user_id, value: number_of_points, message: message, category: category})
      end

      def take_from(user_id, number_of_points, message = "Manually granted through 'add_points'", category = 'default')
        give_to user_id, -number_of_points, message, category
      end

      def user_points_total(user_id)
        where(:user_id => user_id).sum(:value)
      end

      def user_points_today(user_id)
        where(:user_id => user_id).where(:created_at => Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).sum(:value)
      end

      def user_points_this_week(user_id)
        where(:user_id => user_id).where(:created_at => Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).sum(:value)
      end

      def user_points_this_month(user_id)
        where(:user_id => user_id).where(:created_at => Time.zone.now.beginning_of_month..Time.zone.now.end_of_month).sum(:value)
      end

      def user_points_this_year(user_id)
        where(:user_id => user_id).where(:created_at => Time.zone.now.beginning_of_year..Time.zone.now.end_of_year).sum(:value)
      end

    end

    private

    # def update_scorecard
    #   scorecard = Scorecard.find_or_initialize_by_user_id(user_id)
    #   scorecard.daily     = Point.user_points_today(user_id)
    #   scorecard.weekly    = Point.user_points_this_week(user_id)
    #   scorecard.monthly   = Point.user_points_this_month(user_id)
    #   scorecard.yearly    = Point.user_points_this_year(user_id)
    #   scorecard.lifetime  = Point.user_points_total(user_id)
    #   scorecard.save!
    # end

  end
end