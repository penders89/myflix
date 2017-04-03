require 'spec_helper'

describe QueueItemsController do 
  describe "GET index" do 
    context "with authenticated user" do 
      let(:user) { Fabricate(:user) } 
      let(:video1) { Fabricate(:video) } 
      let(:video2) { Fabricate(:video) } 
      let(:queue_item1) { Fabricate(:queue_item, user: user, video: video1, ranking: 2) }
      let(:queue_item2) { Fabricate(:queue_item, user: user, video: video2, ranking: 1) }
      
      before do 
        session[:user_id] = user.id
        get :index
      end
      
      it "should assign the @queue_items variable in ranking order" do 
        expect(assigns(:queue_items)).to eq([queue_item2, queue_item1])
      end
    end  
    
    context "without authenticated user" do 
      it "should redirect to root path" do 
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "POST create" do 
    let(:user) { Fabricate(:user) }
    let(:video1) { Fabricate(:video) }
    let(:video2) { Fabricate(:video) } 
    let!(:queue_item) { Fabricate(:queue_item, user: user, video: video1, ranking: 1) }
    
    context "with authenticated user" do 
      context "with new video item" do 
        before do 
          session[:user_id] = user.id
          post :create, video_id: video2.id
        end
        
        it "should create new queue item" do 
          expect(QueueItem.count).to eq(2)
        end  
          
        it "should associate queue item with video" do 
          expect(QueueItem.last.video).to eq(video2)
        end
        
        it "should associate queue item with user" do 
          expect(QueueItem.last.user).to eq(user) 
        end
        
        it "should give queue item ranking one higher than before" do 
          expect(QueueItem.last.ranking).to eq(2)
        end
      end
      
      context "with video already in list" do 
        before do 
          session[:user_id] = user.id
          post :create, video_id: video1.id
        end
        
        it "should not add new video to queue" do 
          expect(QueueItem.count).to eq(1)
        end
        
        it "should show message in the flash" do 
          expect(flash).to be_present
        end
        
        it "should redirect to queue page" do 
          expect(response).to redirect_to my_queue_path
        end
      end
      
      context "with video which doesn't exist" do 
        before do 
          session[:user_id] = user.id
          post :create, video_id: "not an id"
        end
        
        it "should not add anything to the queue" do 
          expect(QueueItem.count).to eq(1)
        end
        
        it "should show a message in the flash" do 
          expect(flash).to be_present
        end
        
        it "should redirect to queue path" do 
          expect(response).to redirect_to my_queue_path
        end
      end
    end
    
    context "without authenticated user" do 
      it "should redirect to root path" do 
        post :create, video_id: 1
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "DELETE destroy" do 
    context "with authenticated user" do 
      let(:user) { Fabricate(:user) }
      let!(:queue_item) { Fabricate(:queue_item, user: user, ranking: 1) }
      
      before do 
        session[:user_id] = user.id
      end
      
      it "should remove the queue item" do 
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end
      
      it "should show a message in the flash" do 
        delete :destroy, id: queue_item.id
        expect(flash).to be_present 
      end
      
      it "should redirect to user's queue" do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end
      
      it "normalises remaining queue items" do 
        second_queue_item = Fabricate(:queue_item, user: user, ranking: 2)
        delete :destroy, id: queue_item.id 
        expect(second_queue_item.reload.ranking).to eq(1)
      end
      
      it "does not remove the queue item if not in current user's queue" do 
        second_user = Fabricate(:user)
        second_queue_item = Fabricate(:queue_item, user: second_user)
        delete :destroy, id: second_queue_item.id
        expect(QueueItem.count).to eq(2)
      end
    end
    
    context "without authenticated user" do 
      it "should redirect to root path" do 
        delete :destroy, id: 1
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "POST update_queue" do 
    context "with authenticated user" do 
      let(:user) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: user, ranking: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: user, ranking: 2) }
      
      before do 
        session[:user_id] = user.id
      end
      
      context "with valid inputs" do 
        before do 
          post :update_queue, queue_items: [{ id: queue_item1.id, ranking: 3},
            id: queue_item2.id, ranking: 1]
        end
          
        it "redirects to my queue page" do 
          expect(response).to redirect_to my_queue_path
        end
        
        it "reorders the queue items" do 
          expect(user.queue_items).to eq([queue_item2, queue_item1])
        end
        
        it "normalises the ranking numbers" do 
          expect(user.queue_items.map(&:ranking)).to eq([1,2])
        end
      end
      
      context "with invalid inputs" do 
        before do 
          post :update_queue, queue_items: [{ id: queue_item1.id, ranking: 3},
            id: queue_item2.id, ranking: 1.5]
        end

        it "redirects to my queue page" do 
          expect(response).to redirect_to my_queue_path
        end
        
        it "sets flash error message" do 
          expect(flash[:danger]).to be_present
        end
        
        it "does not change the queue items" do 
          expect(queue_item1.reload.ranking).to eq(1)
        end
      end
      
      context "with queue items that don't belong to the current user" do 
        it "does not change the queue items" do 
          other_user = Fabricate(:user) 
          other_queue_item = Fabricate(:queue_item, user: other_user, ranking: 5)
          post :update_queue, queue_items: [{id: other_queue_item.id, 
            ranking: 1}]  
          expect(other_queue_item.reload.ranking).to eq(5)
        end
      end
    end
    
    context "with unauthenticated user" do 
      it "redirects to root path" do 
       queue_item = Fabricate(:queue_item)
       post :update_queue, queue_items: [{id: queue_item.id, ranking: 5}]
       expect(response).to redirect_to root_path
      end
    end
  end
end