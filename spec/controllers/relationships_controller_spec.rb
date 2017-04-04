require 'spec_helper'

describe RelationshipsController do 
  describe "GET index" do 
    
    it "sets relationships to the current user's following relationships" do 
      set_current_user
      second_user = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: second_user, follower: current_user)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    
    it_behaves_like "require_sign_in" do 
      let(:action) { get :index } 
    end
    
  end
  
  describe "DELETE destroy" do 
    context "where current user is follower" do 
      before do 
        set_current_user
        second_user = Fabricate(:user)
        relationship = Fabricate(:relationship, follower: current_user, leader: second_user)
        delete :destroy, id: relationship.id 
      end
      
      it "deletes relationship " do 
        expect(Relationship.count).to eq(0)
      end
      
      it "redirects to the people page" do 
        expect(response).to redirect_to people_path
      end
    end
      
    context "where current user is not follower" do 
      it "does not delete the relationship" do 
        set_current_user
        second_user = Fabricate(:user)
        third_user = Fabricate(:user)
        relationship = Fabricate(:relationship, follower: second_user, leader: third_user)
        delete :destroy, id: relationship.id
        expect(Relationship.count).to eq(1)
     end
    end
    
    it_behaves_like "require_sign_in" do 
      let(:action) { delete :destroy, id: 1 }
    end
    
  end
  
  describe "POST create" do 
    before { set_current_user } 
    let(:leader_user) { Fabricate(:user) } 
    
    it_behaves_like "require_sign_in" do 
      let(:action) { post :create, id: 1 } 
    end
    
    it "creates a relationship where current user followers user" do 
      post :create, leader_id: leader_user.id
      expect(current_user.following_relationships.first.leader).to eq(leader_user)
    end
    
    it "redirects to people page" do 
      post :create, leader_id: leader_user.id
      expect(response).to redirect_to people_path
    end

    it "doesn't not create a relationship if current user already follows leader" do 
      Fabricate(:relationship, leader: leader_user, follower: current_user)
      post :create, leader_id: leader_user.id
      expect(Relationship.count).to eq(1)
    end
    
    it "does not allow user to follow themselves" do 
      post :create, leader_id: current_user.id
      expect(Relationship.count).to eq(0)
    end
  end
end