require 'spec_helper'

describe Honor do
  let(:user) { User.create!({ first_name: 'James', last_name: 'Bond' }) }

  before(:each) do
    Time.zone = "Central Time (US & Canada)"
  end

  it "should create an instance attribute for points" do
    expect(user).to respond_to(:points)
  end

  it "should create an instance attribute for scorecard" do
    expect(user).to respond_to(:scorecard)
  end

  describe "Method" do
    describe "add_points()" do
      it "should add points through the current user"  do
        expect {
          user.add_points(25, 'Manual Add', 'Test')
        }.to change(Honor::Point, :count).by(1)
      end
    end
    describe "subtract_points()" do
      it "should subtract points through the current user"  do
        expect {
          user.subtract_points(25, 'Manual Add', 'Test')
        }.to change(Honor::Point, :count).by(1)
      end
      it "should set the value to a negative number" do
        p = user.subtract_points(25, 'Manual Add', 'Test')
        expect(p.value).to equal(-25)
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

    context "User" do
      describe "points_total" do
        it "should return a sum of all of the user's points" do
          expect(user.points_total).to equal(150)
        end
        it "should return a sum of user points for a given category" do
          expect(user.points_total('Test 2')).to equal(75)
        end
      end

      describe "points_today" do
        it "should return a sum of all of the user's points" do
          expect(user.points_today).to equal(50)
        end
        it "should return a sum of user points for a given category" do
          expect(user.points_today('Test 2')).to equal(25)
        end
      end

      describe "points_this_week" do
        it "should return a sum of all of the user's points" do
          expect(user.points_this_week).to equal(50)
        end
        it "should return a sum of user points for a given category" do
          expect(user.points_this_week('Test 2')).to equal(25)
        end
      end

      describe "points_this_month" do
        it "should return a sum of all of the user's points" do
          expect(user.points_this_month).to equal(150)
        end
        it "should return a sum of user points for a given category" do
          expect(user.points_this_month('Test 2')).to equal(75)
        end
      end

      describe "points_this_year" do
        it "should return a sum of all of the user's points" do
          expect(user.points_this_year).to equal(150)
        end
        it "should return a sum of user points for a given category" do
          expect(user.points_this_year('Test 2')).to equal(75)
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
