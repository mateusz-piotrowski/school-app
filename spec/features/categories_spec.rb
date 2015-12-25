require 'rails_helper'

RSpec.feature 'Categories', type: :feature do
  subject { page }
  let(:admin) { create :admin }

  describe 'index page' do
    let(:cat1) { create :category }
    let(:cat2) { create :category }
    before do
      create_list :course, 3, category: cat1
      create_list :course, 2, category: cat2
      visit categories_path
    end

    it 'should display all categories' do
      should have_link 'Wróć', href: courses_path
      should have_content "#{cat1.name} ( #{cat1.courses.size} )"
      should have_content "#{cat2.name} ( #{cat2.courses.size} )"
      should have_link cat1.name, href: category_path(cat1)
      should have_link cat2.name, href: category_path(cat2)
    end

    context 'for admin' do
      before do
        sign_in_as admin
        visit categories_path
      end
      it { should have_link 'Dodaj nową kategorię', href: new_category_path }
    end
  end

  describe 'show' do
    let(:category) { create :category }
    before do
      create_list :course, 3, category: category
      visit category_path(category)
    end

    it 'should have link to courses from the category' do
      should have_link 'Wróć', href: categories_path
      should have_selector 'h1', text: category.name
      category.courses.each do |course|
        expect(page).to have_link course.name, href: course_path(course)
      end
    end

    context 'for admin' do
      before do
        sign_in_as admin
        visit category_path(category)
      end
      it 'should have proper links' do
        should have_link 'Edytuj', href: edit_category_path(category)
        should have_link 'Usuń', href: category_path(category)
      end
    end
  end

  describe 'creating new category' do
    before do
      sign_in_as admin
      visit new_category_path
    end

    describe 'page' do
      it do
        should have_selector 'h1', text: 'Utwórz nową kategorię'
        should have_link 'Wróć', href: categories_path
      end
    end

    context 'with invalid information' do
      it 'should not create a category' do
        expect { click_button 'Utwórz kategorię' }.not_to change(Category, :count)
      end

      describe 'after submission' do
        before { click_button 'Utwórz kategorię' }
        it 'should display error message' do
          should have_selector 'h1', text: 'Utwórz nową kategorię'
          should have_error_message
        end
      end
    end

    context 'with valid information' do
      let(:valid_category) { build :category }
      before do
        fill_in 'Nazwa', with: valid_category.name
      end

      it 'should create a category' do
        expect { click_button 'Utwórz kategorię' }.to change(Category, :count).by(1)
      end

      describe 'after submission' do
        before { click_button 'Utwórz kategorię' }
        it 'should display success message' do
          should have_selector 'h1', text: valid_category.name
          should have_success_message
        end
      end
    end
  end

  describe 'editing category' do
    let(:category) { create :category }
    before do
      sign_in_as admin
      visit edit_category_path(category)
    end

    describe 'page' do
      it do
        should have_selector 'h1', text: 'Edytuj kategorię'
        should have_link 'Wróć', href: category_path(category)
      end
    end

    context 'with invalid information' do
      before do
        fill_in 'Nazwa', with: ''
        click_button 'Zapisz zmiany'
      end
      it 'should display error message' do
        should have_selector 'h1', text: 'Edytuj kategorię'
        should have_error_message
      end
    end

    context 'with valid information' do
      let(:new_name) { 'History' }
      before do
        fill_in 'Nazwa', with: new_name
        click_button 'Zapisz zmiany'
      end

      it 'should display success message' do
        should have_selector 'h1', text: new_name
        should have_success_message
      end
    end
  end

  describe 'deleting category' do
    let(:category) { create :category }
    before do
      sign_in_as admin
      visit category_path(category)
    end

    it 'should delete the category' do
      expect { click_link 'Usuń' }.to change(Category, :count).by(-1)
    end

    context 'after deleting' do
      before { click_link 'Usuń' }
      it 'should display success message' do
        expect(current_path).to eq categories_path
        should have_success_message
      end
    end
  end
end
