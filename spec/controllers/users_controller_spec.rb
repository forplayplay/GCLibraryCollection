require 'spec_helper'

describe UsersController do

  before do 
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @user = create :user
    @librarian = create :librarian
    @admin = create :admin 
  end 

  after do 
    DatabaseCleaner.clean
  end 

  after :each do 
    Warden.test_reset! 
  end 

  describe 'as non-admin' do

    before { sign_in @user }

    it 'redirects unauthorized users' do
      expect(get :index).to redirect_to(root_path)
      expect(get :edit, id: @user.id).to redirect_to(root_path)
      expect(post :update, id: @user.id).to redirect_to(root_path)
      expect(delete :destroy, id: @user.id).to redirect_to(root_path)
    end
  end


  describe 'as librarian' do

    before { sign_in @librarian }

    it 'redirects unauthorized users' do
      expect(delete :destroy, id: @user.id).to redirect_to(root_path)
      expect(@user.add_role(:admin)).to redirect_to(root_path)
    end

    it "GET 'index'" do
      get :index
      expect(assigns[:users]).to include @user
    end

    it "PUT 'update'" do
      put :update, id: @user, user: FactoryGirl.attributes_for(:user, email: "new@mewgle.com")
      @user.reload
      expect(@user.email).to eq("new@mewgle.com")
    end

    it "GET 'edit'" do
      get :edit, id: @user
      expect(response.status).to eq(200) 
    end
  end


  describe 'as admin' do

    before { sign_in @admin }

    it "can change user roles" do
      @user.add_role(:admin)
      expect(@user.has_role?(:admin)).to eq(true)
    end

    it "DELETE 'destroy'" do
      expect{delete :destroy, id: @user}.to change{User.count}.by(-1)
    end

    it "GET 'index'" do
      get :index
      expect(assigns[:users]).to include @user
    end

    it "PUT 'update'" do
      put :update, id: @user, user: FactoryGirl.attributes_for(:user, email: "new@mewgle.com")
      @user.reload
      expect(@user.email).to eq("new@mewgle.com")
    end

    it "GET 'edit'" do
      get :edit, id: @user
      expect(response.status).to eq(200) 
    end
  end
end