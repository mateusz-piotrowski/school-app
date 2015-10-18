require 'rails_helper'

RSpec.describe 'UpgradesController authorization', type: :request do
  subject { response }
  let(:user) { create :user }
  let(:admin) { create :admin }

  describe 'POST #create' do
    let(:path) { upgrades_path }
    context 'when not singed in' do
      before { post path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      before do
        sign_in_as user
        post path
      end
      it { should redirect_to user_path(user) }
    end
  end

  describe 'PATCH #update' do
    let(:path) { upgrade_user_path(user) }
    context 'when not singed in' do
      before { patch path }
      it { should redirect_to signin_path }
    end

    context 'when singed in' do
      context 'as non-admin user' do
        before do
          sign_in_as user
          patch path
        end
        it { should redirect_to root_path }
      end

      context 'as admin' do
        before do
          sign_in_as admin
          patch path
        end
        it { should_not redirect_to root_path }
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:path) { upgrade_user_path(user) }
    context 'when not singed in' do
      before { delete path }
      it { should redirect_to signin_path }
    end

    context 'when singed in' do
      context 'as non-admin user' do
        before do
          sign_in_as user
          delete path
        end
        it { should redirect_to root_path }
      end

      context 'as admin' do
        before do
          sign_in_as admin
          delete path
        end
        it { should_not redirect_to root_path }
      end
    end
  end
end
