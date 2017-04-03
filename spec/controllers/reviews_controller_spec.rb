require 'spec_helper'

describe ReviewsController do 
  before { set_current_user }
  
  describe "POST create" do 
    let(:video) { Fabricate(:video) }

    context "with authenticated user" do 
      context "when review doesn't already exist" do 
        context "with valid input" do 
          before do 
            post :create, video_id: video.id, review: {rating: 3, 
              content: "some content" }
          end
          
          it "should create a review" do 
            expect(Review.count).to eq(1)
          end
          
          it "should associate the review with video" do 
            expect(Review.first.video).to eq(video)
          end
          
          it "should associate the review with current user" do 
            expect(Review.first.user).to eq(current_user)
          end
          
          it "should show a message in the flash" do 
            expect(flash).to be_present
          end
          
          it "should redirect to current video page" do 
            expect(response).to redirect_to video_path(video.id)
          end
        end
        
        context "with invalid input" do 
          before do 
            post :create, video_id: video.id, review: {content: "some content"}
          end
          
          it "should not create the review" do 
            expect(Review.count).to eq(0) 
          end
          
          it "should show a message in the flash" do 
            expect(flash.now).to be_present
          end
          
          it "should create the @video variable for the current video" do 
            expect(assigns(:video)).to eq(video)
          end
          
          it "should render the current video page" do 
            expect(response).to render_template('videos/show')
          end
        end
      end
      
      context "with existing review" do 
        before do 
          Fabricate(:review, user: current_user, video: video) 
          post :create, video_id: video.id, review: {rating: 3, 
            content: "some content" }
        end
        
        it "should not create another review" do 
          expect(Review.count).to eq(1)
        end
        
        it "should show a message in the flash" do 
          expect(flash.now).to be_present 
        end
        
        it "should render the video page" do 
          expect(response).to render_template('videos/show')
        end
      end
    end
    
    context "without authenticated user" do 
      it_behaves_like "require_sign_in" do 
        let(:action) { post :create, video_id: video.id, review: {rating: 3, 
          content: "some content" } }
      end
    end
  end
end