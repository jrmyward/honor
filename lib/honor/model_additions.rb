module Honor
  extend ActiveSupport::Concern

  def add_points(number_of_points, message = "Manually granted through 'add_points'", category = 'default' )
    points.create!({value: number_of_points, message: message, category: category})
  end

  def subtract_points(number_of_points, message = "Manually granted through 'add_points'", category = 'default' )
    add_points -number_of_points, message, category
  end

  def points_total(category = nil)
    if category.nil?
      points.sum(:value)
    else
      points.where("points.category = ?", category).sum(:value)
    end
  end

  def points_today(category = nil)
    if category.nil?
      points.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).sum(:value)
    else
      points.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where("points.category = ?", category).sum(:value)
    end
  end

  def points_this_week(category = nil)
    if category.nil?
      points.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).sum(:value)
    else
      points.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).where("points.category = ?", category).sum(:value)
    end
  end

  def points_this_month(category = nil)
    if category.nil?
      points.where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month).sum(:value)
    else
      points.where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month).where("points.category = ?", category).sum(:value)
    end
  end

  def points_this_year(category = nil)
    if category.nil?
      points.where(created_at: Time.zone.now.beginning_of_year..Time.zone.now.end_of_year).sum(:value)
    else
      points.where(created_at: Time.zone.now.beginning_of_year..Time.zone.now.end_of_year).where("points.category = ?", category).sum(:value)
    end
  end
end
