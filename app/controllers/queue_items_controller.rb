class QueueItemsController < ApplicationController 
  def index 
    @queue_items = current_user.queue_items.order(:ranking)
  end
  
  def create 
    if video_doesnt_exist || video_already_in_users_queue
      flash[:danger] = "Sorry we couldn't add that video." 
      redirect_to my_queue_path
    else 
      create_new_queue_item
      flash[:success] = "Video added to queue."
      redirect_to my_queue_path
    end
  end
  
  def destroy 
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    current_user.normalise_queue_item_rankings
    
    flash[:success] = "Queue item has been removed."
    redirect_to my_queue_path
  end
  
  def update_queue
    begin 
      update_queue_items
      current_user.normalise_queue_item_rankings
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid position numbers."
    end

    redirect_to my_queue_path
  end
  
  private 
  
    def video_doesnt_exist
      !Video.exists?(id: params[:video_id])
    end
    
    def video_already_in_users_queue
      current_user.queue_items.map(&:video_id).include?(params[:video_id].to_i) 
    end
    
    def create_new_queue_item 
      current_user.queue_items.create(video_id: params[:video_id], 
        ranking: current_user.queue_items.count + 1)
    end
    
    def update_queue_items
      ActiveRecord::Base.transaction do 
        params[:queue_items].each do |queue_item_data|
          queue_item = QueueItem.find(queue_item_data["id"])
          queue_item.update_attributes!(ranking: queue_item_data["ranking"], rating: queue_item_data["rating"]) if 
            queue_item.user == current_user
        end
      end
    end
    
    
end