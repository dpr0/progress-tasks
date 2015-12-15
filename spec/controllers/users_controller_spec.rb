require 'rails_helper'

RSpec.describe UsersController, type: :controller do
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
    let(:user) { create(:user) }
    sign_in_user
    before { get :show, id: user }
    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq user
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
end
