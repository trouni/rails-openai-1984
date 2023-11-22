module ApplicationHelper
  def featured?(illustration_id, index)
    if params[:featured].present?
      illustration_id == params[:featured].to_i
    else
      index == 0
    end
  end
end
