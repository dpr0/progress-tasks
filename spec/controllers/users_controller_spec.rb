require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:users) { create_list(:user, 2) }
    sign_in_admin
    before { get :index }
    it 'populates an array of all users' do
      users << User.first
      expect(assigns(:users)).to match_array(users)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    sign_in_user
    before { get :show, id: user }
    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq user
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'PATCH #update' do
    sign_in_admin
    before { user.update!(role: 'vip') }
    it 'assigns the requested user to @user' do
      patch :update, id: user, user: attributes_for(:user)
      expect(assigns(:user)).to eq user
    end
    it 'changes user attributes' do
      patch :update, id: user, user: { role: 'vip' }
      user.reload
      expect(user.role).to eq 'vip'
    end
    it 'redirects to the updated user' do
      patch :update, id: user, user: attributes_for(:user)
      expect(response).to redirect_to users_path
    end
  end

  describe 'DELETE #destroy' do
    sign_in_admin
    let!(:user1) { create(:user) }
    it 'deletes user' do
      expect { delete :destroy, id: user1 }.to change(User, :count).by(-1)
    end
    it 'redirect to index view' do
      delete :destroy, id: user1
      expect(response).to redirect_to users_path
    end
  end
end
