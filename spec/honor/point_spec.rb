require 'spec_helper'

describe Honor::Point do
  let(:user) { User.create!({ first_name: 'James', last_name: 'Bond' }) }

  before(:each) do
    Time.zone = "Central Time (US & Canada)"
  end

  it "should respond to the reciever" do
    expect(Honor::Point.new).to respond_to(:user)
  end

  describe "Method" do
    describe "#give_to()" do
      it "should add points to a given user" do
        expect {
          Honor::Point.give_to(user.id, 25, 'Manual give to', 'Test')
        }.to change(Honor::Point, :count).by(1)
      end
    end
    describe "#take_from()" do
      it "should add points to a given user"do
        expect {
          Honor::Point.take_from(user.id, 25, 'Manual take away', 'Test')
        }.to change(Honor::Point, :count).by(1)
      end
      it "should set the value to a negative number" do
        p = Honor::Point.take_from(user.id, 25, 'Manual take away', 'Test')
        expect(p.value).to equal(-25)
      end
    end
  end

  describe "Scorecard" do
    before(:each) do
      seed_points(user.id)
    end

    it "should update after Points are saved" do
      Timecop.freeze(2012, 12, 4, 16, 00)
      sc = Honor::Scorecard.find_by_user_id(user.id)
      expect(sc).not_to be_nil
      expect(sc.daily).to equal(50)
      expect(sc.weekly).to equal(50)
      expect(sc.monthly).to equal(50)
      expect(sc.yearly).to equal(150)
      expect(sc.lifetime).to equal(150)
      Timecop.return
    end

    describe "#update_scorecards" do
      it "should set appropriate values for all cards" do
        Timecop.freeze(2012, 12, 5, 16, 01)
        Honor::Scorecard.update_scorecards
        sc = Honor::Scorecard.find_by_user_id(user.id)
        expect(sc.daily).to equal(0)
        expect(sc.weekly).to equal(50)
        expect(sc.monthly).to equal(50)
        expect(sc.yearly).to equal(150)
        expect(sc.lifetime).to equal(150)
        Timecop.return
      end
    end
  end

  describe "Scopes" do
    before(:each) do
      seed_points(user.id)
      Timecop.freeze(2012, 11, 5, 16, 00)
    end

    after(:each) do
      Timecop.return
    end

    context "Self" do
      describe "user_points_total" do
        it "should return a sum of all of the user's points" do
          expect(Honor::Point.user_points_total(user.id)).to equal(150)
        end
      end

      describe "user_points_today" do
        it "should return a sum of all of the user's points" do
          expect(Honor::Point.user_points_today(user.id)).to equal(50)
        end
      end

      describe "user_points_this_week" do
        it "should return a sum of all of the user's points" do
          expect(Honor::Point.user_points_this_week(user.id)).to equal(50)
        end
      end

      describe "user_points_this_month" do
        it "should return a sum of all of the user's points" do
          expect(Honor::Point.user_points_this_month(user.id)).to equal(150)
        end
      end

      describe "user_points_this_year" do
        it "should return a sum of all of the user's points" do
          expect(Honor::Point.user_points_this_year(user.id)).to equal(150)
        end
      end
    end

  end
end

def seed_points(user_id)
  Timecop.freeze(2012, 1, 15, 12, 05)
  Honor::Point.create!({user_id: user_id, value: -25, category: 'Test', message: ''})
  Honor::Point.create!({user_id: user_id, value: -25, category: 'Test 2', message: ''})
  Timecop.freeze(2012, 11, 5, 12, 05)
  Honor::Point.create!({user_id: user_id, value: 25, category: 'Test', message: ''})
  Honor::Point.create!({user_id: user_id, value: 25, category: 'Test 2', message: ''})
  Timecop.freeze(2012, 11, 12, 12, 05)
  Honor::Point.create!({user_id: user_id, value: 25, category: 'Test', message: ''})
  Honor::Point.create!({user_id: user_id, value: 25, category: 'Test 2', message: ''})
  Timecop.freeze(2012, 11, 19, 12, 05)
  Honor::Point.create!({user_id: user_id, value: 25, category: 'Test', message: ''})
  Honor::Point.create!({user_id: user_id, value: 25, category: 'Test 2', message: ''})
  Timecop.freeze(2012, 12, 4, 12, 05)
  Honor::Point.create!({user_id: user_id, value: 25, category: 'Test', message: ''})
  Honor::Point.create!({user_id: user_id, value: 25, category: 'Test 2', message: ''})
end
