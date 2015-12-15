require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:task) { create(:task) }
  let(:task2) { create(:task) }

  before do
    task.users << user
    task2.users << user2
  end

  describe 'POST #change_state' do
    sign_in_user
    it 'start task' do
      post :change_state, task_id: task, format: :js
      task.reload
      expect(task.state).to eq 'started'
    end
    it 'finish task' do
      post :change_state, task_id: task, format: :js
      post :change_state, task_id: task, format: :js
      task.reload
      expect(task.state).to eq 'finished'
    end
    it 'Render task :change_state' do
      expect(post :change_state, task_id: task, format: :js).to render_template :change_state
    end
  end

  describe 'GET #index' do
    let(:tasks) { create_list(:task, 5) }
    before do
      tasks << task
      tasks << task2
      get :index
    end
    it 'populates an array of all tasks' do
      expect(assigns(:tasks)).to match_array(tasks)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: task }
    it 'assigns the requested task to @task' do
      expect(assigns(:task)).to eq task
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }
    it 'assigns a new Task to @task' do
      expect(assigns(:task)).to be_a_new(Task)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before do
      task.users << @user
      get :edit, id: task
    end
    it 'assings the requested task to @task' do
      expect(assigns(:task)).to eq task
    end
    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    it 'task assigns to user' do
      expect { post :create, task: attributes_for(:task) }.to change(Task, :count).by(1)
    end
    it 'redirects to show view' do
      post :create, task: attributes_for(:task)
      expect(response).to redirect_to task_path(assigns(:task))
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    before { task.users << @user }
    it 'assigns the requested task to @task' do
      patch :update, id: task, task: attributes_for(:task)
      expect(assigns(:task)).to eq task
    end
    it 'changes task attributes' do
      patch :update, id: task, task: { title: 'new title', description: 'new description' }
      task.reload
      expect(task.title).to eq 'new title'
      expect(task.description).to eq 'new description'
    end
    it 'redirects to the updated task' do
      patch :update, id: task, task: attributes_for(:task)
      expect(response).to redirect_to task
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:task1) { create(:task) }
    before { task1.users << @user }
    it 'deletes task' do
      expect { delete :destroy, id: task1 }.to change(Task, :count).by(-1)
    end
    it 'redirect to index view' do
      delete :destroy, id: task1
      expect(response).to redirect_to tasks_path
    end
    it 'user cant delete another user task' do
      task2
      expect { delete :destroy, id: task2 }.to_not change(Task, :count)
    end
  end
end
