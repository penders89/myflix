require 'spec_helper' 

describe CategoriesController do 
  before { set_current_user }
  
  context "with authenticated user" do 
    let(:category) { Fabricate(:category) }
    let(:user) { Fabricate(:user) }
    
    before do 
      get :show, name: category.name
    end
    
    it "should assign the @category variable" do 
      expect(assigns(:category)).to eq(category)
    end
  
  end
  
  context "without authenticated user" do 
    it_behaves_like "require_sign_in" do 
      let(:action) { get :show, name: "anything" }
    end
  end
end
  