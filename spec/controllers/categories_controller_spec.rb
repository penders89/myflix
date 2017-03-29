require 'spec_helper' 

describe CategoriesController do 
  context "with authenticated user" do 
    let(:category) { Fabricate(:category) }
    
    before do 
      get :show, name: category.name
    end
    
    it "should assign the @category variable" do 
      expect(assigns(:category)).to eq(category)
    end
  
  end
  
  context "without authenticated user"
  
  
end
  