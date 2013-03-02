require "active_record"
require "active_record/version"
require "honor/version"
require "honor/model_additions"
require "honor/point"
require "honor/scorecard"

module Honor

  def self.included(receiver)
    receiver.class_eval %Q{
      has_many :points, :class_name => "Honor::Point", :foreign_key => "user_id", :dependent => :destroy
    }

    Point.class_eval %Q{
      belongs_to :#{receiver.to_s.underscore}, :class_name => "#{receiver.to_s}", :foreign_key => "user_id"
    }

    Scorecard.class_eval %Q{
      belongs_to :#{receiver.to_s.underscore}, :class_name => "#{receiver.to_s}", :foreign_key => "user_id"
    }
  end

end
