require 'spec_helper' 

describe VideosController do 
  before { set_current_user } 
  
  describe "GET index" do 
    context "with authenticated user" do 
      let(:cat1) { Fabricate(:category) }
      let(:cat2) { Fabricate(:category) }

      before do 
        get :index
      end
      
      it "should set @categories variable" do 
        expect(assigns(:categories)).to eq([cat1, cat2])
      end
      
    end
    
    context "without authenticated user" do
      it_behaves_like "require_sign_in" do 
        let(:action) { get :index }
      end
    end
  end
  
  describe "GET show" do 
    context "with authenticated user" do 
      let(:video) { Fabricate(:video) }
      let(:review1) { Fabricate(:review, video: video, created_at: 2.days.ago) }
      let(:review2) { Fabricate(:review, video: video, created_at: 1.days.ago) }

      before do 
        get :show, id: video.id
      end
      
      it "should set @video variable" do 
        expect(assigns(:video)).to eq(video)
      end
      
      it "should set @reviews variable in reverse chronological order" do 
        expect(assigns(:reviews)).to eq([review2, review1])
      end
      
    end
    context "without authenticated user" do 
      it_behaves_like "require_sign_in" do 
        let(:action) { get :show, id: 1 }
      end
    end
  end
  
  describe "GET search" do 
    context "with authenticated user" do 
      let(:video1) { Fabricate(:video, title: "Title1") }
      let(:video2) { Fabricate(:video, title: "Title2") }

      before do 
        get :search, search_string: "itl"
      end
      
      it "should set @videos variable" do 
        expect(assigns(:videos)).to eq([video1, video2])
      end
      
    end
    context "without authenticated user" do 
      it_behaves_like "require_sign_in" do 
        let(:action) { get :search, search_string: "string" } 
      end
    end
  end

end