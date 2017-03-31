module ApplicationHelper
  def review_rating_options
    (1..5).map{|x| ["#{x} #{'star'.pluralize(x)}", x]}
  end
end
