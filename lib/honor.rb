require "active_record"
require "active_record/version"
require "honor/version"
require "honor/model_additions"
require "honor/point"
require "honor/scorecard"

module Honor

  def self.included(receiver)
    receiver.class_eval do
      has_many :points, :class_name => "Honor::Point", :foreign_key => "user_id", :dependent => :destroy
      has_one :scorecard, :class_name => "Honor::Scorecard", :foreign_key => "user_id", :dependent => :destroy
    end

    Honor::Point.class_eval do
      belongs_to "#{receiver.to_s.underscore}".to_sym, :class_name => "#{receiver.to_s}", :foreign_key => "user_id"
    end

    Honor::Scorecard.class_eval do
      belongs_to "#{receiver.to_s.underscore}".to_sym, :class_name => "#{receiver.to_s}", :foreign_key => "user_id"
    end
  end

end
