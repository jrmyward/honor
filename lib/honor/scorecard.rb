module Honor

  class Scorecard < ActiveRecord::Base
    attr_accessible :daily, :lifetime, :monthly, :user_id, :weekly, :yearly, :position
    attr_accessor :position

    class << self
      def leaderboard(scorecard_user_ids, opt={})
        opt.reverse_merge!  :rank_by => 'daily',
                            :sort_direction => 'desc'
        scorecards = team_scorecards(scorecard_user_ids, rank_by: opt[:rank_by], sort_direction: opt[:sort_direction])
        rankings = []
        scorecards.each_with_index do |scorecard, i|
          if i == 0
            scorecard.position = 1
          elsif scorecard[opt[:rank_by]] == scorecards[i-1][opt[:rank_by]]
            scorecard.position = rankings[i-1]
          else
            scorecard.position = i + 1
          end
          rankings[i] = scorecard.position
        end
        return scorecards
      end

      def reset_daily_scores
        where("updated_at < ?", Time.zone.now.beginning_of_day).update_all(:daily => 0)
      end

      def reset_weekly_scores
        where("updated_at < ?", Time.zone.now.beginning_of_week).update_all(:weekly => 0)
      end

      def reset_monthly_scores
        where("updated_at < ?", Time.zone.now.beginning_of_month).update_all(:monthly => 0)
      end

      def reset_yearly_scores
        where("updated_at < ?", Time.zone.now.beginning_of_year).update_all(:yearly => 0)
      end

      def team_scorecards(scorecard_user_ids, opt={})
        opt.reverse_merge!  :rank_by => 'daily',
                            :sort_direction => 'desc'
        includes(:user).where('user_id IN (?)', scorecard_user_ids).order("#{opt[:rank_by]} #{opt[:sort_direction]}")
      end
    end

  end

end