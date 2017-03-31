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
    QueueItem.find(params[:id]).destroy
    flash[:success] = "Queue item has been removed."
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
end