require "spec_helper"

describe Admin::VideosController do 
  describe "GET new" do 
    it "should assign @video to new Video instance" do 
      set_current_admin
      get :new 
      expect(assigns(:video)).to be_an_instance_of Video
    end
    
    it_behaves_like "require_admin" do 
      let(:action) { post :create }
    end
    
    it "sets flash error message for regular user" do 
      set_current_user 
      get :new
      expect(flash[:danger]).to be_present
    end
    
    it_behaves_like "require_sign_in" do 
      let(:action) { get :new }
    end
  end
  
  describe "POST create" do 
    it_behaves_like "require_sign_in" do 
      let(:action) { post :create } 
    end
    
    it_behaves_like "require_admin" do 
      let(:action) { post :create }
    end
    
    context "with valid input" do 
      let(:category) { Fabricate(:category) } 
      
      before do 
        set_current_admin
        post :create, video: { title: "Title", description: "Description",
          small_cover: "small_cover.jpg", large_cover: "large_cover.jpg",
          category_id: category.id }
      end
        
      it "creates a video" do 
        expect(Video.count).to eq(1)
      end
      
      it "redirects to add new video page" do
        expect(response).to redirect_to new_admin_video_path
      end
      
      it "sets flash success message" do 
        expect(flash[:success]).to be_present 
      end
    end
    
    context "with invalid input" do 
      let(:category) { Fabricate(:category) } 
      
      before do 
        set_current_admin
        post :create, video: {description: "Description",
          small_cover: "small_cover.jpg", large_cover: "large_cover.jpg",
          category_id: category.id }
      end

      it "does not create a video" do 
        expect(Video.count).to eq(0)
      end
    
      it "renders new template" do 
        expect(response).to render_template :new
      end
      
      it "sets @video variable" do 
        expect(assigns(:video)).to be_an_instance_of Video 
      end
      
      it "sets flash error message" do 
        expect(flash[:danger]).to be_present 
      end
    end
  end
  
end
