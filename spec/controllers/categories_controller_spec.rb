require 'spec_helper' 

describe CategoriesController do 
  context "with authenticated user" do 
    let(:category) { Fabricate(:category) }
    let(:user) { Fabricate(:user) }
    
    before do 
      session[:user_id] = user.id
      get :show, name: category.name
    end
    
    it "should assign the @category variable" do 
      expect(assigns(:category)).to eq(category)
    end
  
  end
  
  context "without authenticated user" do 
    it "should redirect to root path" do 
      category = Fabricate(:category)
      get :show, name: category.name
      expect(response).to redirect_to root_path
    end
  end
end
  