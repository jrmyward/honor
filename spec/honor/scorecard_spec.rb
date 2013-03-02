require 'spec_helper'

describe Honor::Scorecard do
  let(:valid_user) { FactoryGirl.attributes_for(:user) }
  let (:valid_friend) { FactoryGirl.attributes_for(:user, username: 'goldfinger', email: Faker::Internet.email) }

  before(:each) do
    Time.zone = "Central Time (US & Canada)"
    Timecop.freeze(2011, 12, 4, 16, 00)
    @user_1 = User.create!({ first_name: 'Bruce', last_name: 'Wayne' })
    @user_2 = User.create!({ first_name: 'Clark', last_name: 'Kent' })
    Honor::Scorecard.create!({user_id: @user_1.id, daily: 25, weekly: 100, monthly: 350, yearly: 1250, lifetime: 1375})
    Honor::Scorecard.create!({user_id: @user_2.id, daily: 50, weekly: 100, monthly: 350, yearly: 1250, lifetime: 1375})
    Timecop.return
  end

  it "should respond to the reciever" do
    Honor::Scorecard.new.should respond_to(:user)
  end

  describe "Ranking" do
    it "should produce rankings with correctly calculated tied positions" do
      user_ids = [@user_2.id, @user_1.id]
      daily_rankings = Honor::Scorecard.leaderboard(user_ids, rank_by: 'daily', sort_direction: 'desc')
      daily_rankings[0].position.should == 1
      daily_rankings[1].position.should == 2
      weekly_rankings = Honor::Scorecard.leaderboard(user_ids, rank_by: 'weekly', sort_direction: 'desc')
      weekly_rankings[0].position.should == 1
      weekly_rankings[1].position.should == 1
    end
  end

  describe "Methods" do
    describe "#reset_daily_scores" do
      it "should set the daily attribute to 0 if no updates have been made today" do
        Honor::Scorecard.reset_daily_scores
        sc = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc.daily.should == 0
        sc.weekly.should == 100
        sc.monthly.should == 350
        sc.yearly.should == 1250
      end

      it "should NOT change the daily attribute if an update was made today" do
        sc_before = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc_before.update_attribute(:daily, 30)
        Honor::Scorecard.reset_daily_scores
        sc_after = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc_after.daily.should == 30
        sc_after.weekly.should == 100
        sc_after.monthly.should == 350
        sc_after.yearly.should == 1250
      end
    end
    describe "#reset_weekly_scores" do
      it "should set the weekly attribute to 0 if no updates have been made this week" do
        Honor::Scorecard.reset_weekly_scores
        sc = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc.daily.should == 25
        sc.weekly.should == 0
        sc.monthly.should == 350
        sc.yearly.should == 1250
      end

      it "should NOT change the weekly attribute if an update was made this week" do
        sc_before = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc_before.update_attribute(:weekly, 125)
        Honor::Scorecard.reset_weekly_scores
        sc_after = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc_after.daily.should == 25
        sc_after.weekly.should == 125
        sc_after.monthly.should == 350
        sc_after.yearly.should == 1250
      end
    end
    describe "#reset_monthly_scores" do
      it "should set the monthly attribute to 0 if no updates have been made this month" do
        Honor::Scorecard.reset_monthly_scores
        sc = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc.daily.should == 25
        sc.weekly.should == 100
        sc.monthly.should == 0
        sc.yearly.should == 1250
      end

      it "should NOT change the monthly attribute if an update was made this month" do
        sc_before = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc_before.update_attribute(:monthly, 400)
        Honor::Scorecard.reset_monthly_scores
        sc_after = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc_after.daily.should == 25
        sc_after.weekly.should == 100
        sc_after.monthly.should == 400
        sc_after.yearly.should == 1250
      end
    end
    describe "#reset_yearly_scores" do
      it "should set the yearly attribute to 0 if no updates have been made this year" do
        Honor::Scorecard.reset_yearly_scores
        sc = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc.daily.should == 25
        sc.weekly.should == 100
        sc.monthly.should == 350
        sc.yearly.should == 0
      end

      it "should NOT change the yearly attribute if an update was made this year" do
        sc_before = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc_before.update_attribute(:yearly, 1300)
        Honor::Scorecard.reset_yearly_scores
        sc_after = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc_after.daily.should == 25
        sc_after.weekly.should == 100
        sc_after.monthly.should == 350
        sc_after.yearly.should == 1300
      end
    end
  end
end
