require 'spec_helper' 

describe VideosController do 
  describe "GET index" do 
    context "with authenticated user" do 
      let(:cat1) { Fabricate(:category) }
      let(:cat2) { Fabricate(:category) }
      let(:user) { Fabricate(:user) }
      
      before do 
        session[:user_id] = user.id
        get :index
      end
      
      it "should set @categories variable" do 
        expect(assigns(:categories)).to eq([cat1, cat2])
      end
      
    end
    
    context "without authenticated user" do
      it "should redirect to root path" do 
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "GET show" do 
    context "with authenticated user" do 
      let(:video) { Fabricate(:video) }
      let(:user) { Fabricate(:user) }

      before do 
        session[:user_id] = user.id
        get :show, id: video.id
      end
      
      it "should set @video variable" do 
        expect(assigns(:video)).to eq(video)
      end
      
    end
    context "without authenticated user" do 
      it "should redirect to root path" do 
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "GET search" do 
    context "with authenticated user" do 
      let(:video1) { Fabricate(:video, title: "Title1") }
      let(:video2) { Fabricate(:video, title: "Title2") }
      let(:user) { Fabricate(:user) }

      before do 
        session[:user_id] = user.id
        get :search, search_string: "itl"
      end
      
      it "should set @videos variable" do 
        expect(assigns(:videos)).to eq([video1, video2])
      end
      
    end
    context "without authenticated user" do 
      it "should redirect to root path" do 
        get :search, search_string: "string" 
        expect(response).to redirect_to root_path
      end
    end
  end

end