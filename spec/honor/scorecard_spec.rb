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
    expect(Honor::Scorecard.new).to respond_to(:user)
  end

  describe "Ranking" do
    it "should produce rankings with correctly calculated tied positions" do
      user_ids = [@user_2.id, @user_1.id]
      daily_rankings = Honor::Scorecard.leaderboard(user_ids, rank_by: 'daily', sort_direction: 'desc')
      expect(daily_rankings[0].position).to equal(1)
      expect(daily_rankings[1].position).to equal(2)
      weekly_rankings = Honor::Scorecard.leaderboard(user_ids, rank_by: 'weekly', sort_direction: 'desc')
      expect(weekly_rankings[0].position).to equal(1)
      expect(weekly_rankings[1].position).to equal(1)
    end
  end

  describe "Methods" do
    describe "#reset_daily_scores" do
      it "should set the daily attribute to 0 if no updates have been made today" do
        Honor::Scorecard.reset_daily_scores
        sc = Honor::Scorecard.find_by_user_id(@user_1.id)
        expect(sc.daily).to equal(0)
        expect(sc.weekly).to equal(100)
        expect(sc.monthly).to equal(350)
        expect(sc.yearly).to equal(1250)
      end

      it "should NOT change the daily attribute if an update was made today" do
        sc_before = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc_before.update_attribute(:daily, 30)
        Honor::Scorecard.reset_daily_scores
        sc_after = Honor::Scorecard.find_by_user_id(@user_1.id)
        expect(sc_after.daily).to equal(30)
        expect(sc_after.weekly).to equal(100)
        expect(sc_after.monthly).to equal(350)
        expect(sc_after.yearly).to equal(1250)
      end
    end
    describe "#reset_weekly_scores" do
      it "should set the weekly attribute to 0 if no updates have been made this week" do
        Honor::Scorecard.reset_weekly_scores
        sc = Honor::Scorecard.find_by_user_id(@user_1.id)
        expect(sc.daily).to equal(25)
        expect(sc.weekly).to equal(0)
        expect(sc.monthly).to equal(350)
        expect(sc.yearly).to equal(1250)
      end

      it "should NOT change the weekly attribute if an update was made this week" do
        sc_before = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc_before.update_attribute(:weekly, 125)
        Honor::Scorecard.reset_weekly_scores
        sc_after = Honor::Scorecard.find_by_user_id(@user_1.id)
        expect(sc_after.daily).to equal(25)
        expect(sc_after.weekly).to equal(125)
        expect(sc_after.monthly).to equal(350)
        expect(sc_after.yearly).to equal(1250)
      end
    end
    describe "#reset_monthly_scores" do
      it "should set the monthly attribute to 0 if no updates have been made this month" do
        Honor::Scorecard.reset_monthly_scores
        sc = Honor::Scorecard.find_by_user_id(@user_1.id)
        expect(sc.daily).to equal(25)
        expect(sc.weekly).to equal(100)
        expect(sc.monthly).to equal(0)
        expect(sc.yearly).to equal(1250)
      end

      it "should NOT change the monthly attribute if an update was made this month" do
        sc_before = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc_before.update_attribute(:monthly, 400)
        Honor::Scorecard.reset_monthly_scores
        sc_after = Honor::Scorecard.find_by_user_id(@user_1.id)
        expect(sc_after.daily).to equal(25)
        expect(sc_after.weekly).to equal(100)
        expect(sc_after.monthly).to equal(400)
        expect(sc_after.yearly).to equal(1250)
      end
    end
    describe "#reset_yearly_scores" do
      it "should set the yearly attribute to 0 if no updates have been made this year" do
        Honor::Scorecard.reset_yearly_scores
        sc = Honor::Scorecard.find_by_user_id(@user_1.id)
        expect(sc.daily).to equal(25)
        expect(sc.weekly).to equal(100)
        expect(sc.monthly).to equal(350)
        expect(sc.yearly).to equal(0)
      end

      it "should NOT change the yearly attribute if an update was made this year" do
        sc_before = Honor::Scorecard.find_by_user_id(@user_1.id)
        sc_before.update_attribute(:yearly, 1300)
        Honor::Scorecard.reset_yearly_scores
        sc_after = Honor::Scorecard.find_by_user_id(@user_1.id)
        expect(sc_after.daily).to equal(25)
        expect(sc_after.weekly).to equal(100)
        expect(sc_after.monthly).to equal(350)
        expect(sc_after.yearly).to equal(1300)
      end
    end
  end
end
