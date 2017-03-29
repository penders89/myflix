require 'spec_helper' 

describe VideosController do 
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
    context "without authenticated user"
  end
  
  describe "GET show" do 
    context "with authenticated user" do 
      let(:video) { Fabricate(:video) }

      before do 
        get :show, id: video.id
      end
      
      it "should set @video variable" do 
        expect(assigns(:video)).to eq(video)
      end
      
    end
    context "without authenticated user"
  end

end