require_relative 'features_helper'

feature 'Create task.' do
  start_button    = 'Start task!'
  finish_button   = 'End task!'
  revision_button = 'Remake!'
  given(:user)  { create(:user) }
  given(:user2) { create(:user) }
  given!(:task) { create(:task) }
  given(:task2) { create(:task) }
  given(:tasks) { create_list(:task, 5) }

  background do
    task.users << user
    task2.users << user2
  end

  scenario 'Authenticated user creates task' do
    sign_in(user)
    visit tasks_path
    click_on 'New task'
    fill_in 'Title:', with: 'ййй'
    fill_in 'Description:', with: 'й й й й й'
    click_on 'Add task!'
    # save_and_open_page
    expect(page).to have_content 'Description: й й й й й'
    expect(page).to have_content 'State: new'
  end

  scenario 'Authenticated user edit task' do
    sign_in(user)
    visit task_path(task)
    click_on 'Edit task?'
    select 'user3@progress.ru', from: 'Users:'
    select 'user4@progress.ru', from: 'Users:'
    click_on 'Edit task'
    expect(page).to have_content 'user3@progress.ru'
    expect(page).to have_content 'user4@progress.ru'
  end

  scenario 'Non-authenticated user try to create task' do
    visit new_task_path
    expect(page).to_not have_content 'New task'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'user can view task list' do
    tasks
    visit tasks_path
    tasks.each { |q| expect(page).to have_content q.title }
  end

  scenario 'Owner can delete task' do
    sign_in(user)
    visit task_path(task)
    click_on 'Delete?'
    # save_and_open_page
    expect(page).to have_content 'Tasks:'
  end

  scenario 'user can start someone task', js: true do
    sign_in(user2)
    within "#task_#{task.id}" do
      expect(page).to_not have_content start_button
      expect(page).to_not have_content finish_button
      expect(page).to_not have_content revision_button
    end
  end

  describe 'authorized user:', js: true do
    background { sign_in(user) }

    scenario 'user can start their task' do
      within "#task_#{task.id}" do
        click_on start_button
        expect(page).to have_content finish_button
      end
    end

    scenario 'user can start their task' do
      within "#task_#{task.id}" do
        click_on start_button
        click_on finish_button
        expect(page).to have_content revision_button
      end
    end
  end
end
