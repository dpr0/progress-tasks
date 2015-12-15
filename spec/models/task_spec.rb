require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }

  it 'task.state' do
    expect(task.state).to eq 'new'
    task.change_state
    expect(task.state).to eq 'started'
    task.change_state
    expect(task.state).to eq 'finished'
    task.change_state
    expect(task.state).to eq 'started'
  end
end
