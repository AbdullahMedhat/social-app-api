require 'rails_helper'

RSpec.describe 'Lists', type: :request do
  before(:each) do
    @admin = create(:admin)
    @admin1 = create(:admin)
    @member = create(:member)
    @list = create(:list, user: @admin)
  end

  describe 'GET /lists' do
    context '#index  [Admin view]' do
      it 'returns a all lists' do
        sign_in_as(@admin)
        user_headers = response_headers
        get '/lists', user_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ lists: [@list] }.to_json)
      end
    end

    context '#index  [Member view]' do
      it 'return all lists assgined to member' do
        sign_in_as(@member)
        user_headers = response_headers
        get '/lists', user_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ lists: @member.user_lists }.to_json)
      end
    end
  end

  describe 'GET /list/:id' do
    context '#show  [Admin view]' do
      it 'returns a list' do
        sign_in_as(@admin)
        user_headers = response_headers
        get "/lists/#{@list.id}", user_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({
          list: @list, list_cards: @list.cards
        }.to_json)
      end
    end
    context '#show  [Member view]' do
      it 'Not allow for member user' do
        sign_in_as(@member)
        user_headers = response_headers
        get "/lists/#{@list.id}", user_headers
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({
          error: I18n.t('permissions.member_limition')
        }.to_json)
      end
    end
  end

  describe 'POST /lists' do
    context '#create [Admin view]' do
      it 'create a new list' do
        sign_in_as(@admin)
        user_headers = response_headers
        post('/lists', { list: { title: 'title' } }, user_headers)
        expect(response).to have_http_status(:created)
        expect(response.body).to eq({ list: List.last }.to_json)
      end

      it 'wrong params' do
        sign_in_as(@admin)
        user_headers = response_headers
        @wrong_list = { title:  '' }
        post('/lists', { list: @wrong_list }, user_headers)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context '#create [Member view]' do
      it 'Not allow for member user' do
        sign_in_as(@member)
        user_headers = response_headers
        post('/lists', { list: { title: 'title' } }, user_headers)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({
          error: I18n.t('permissions.member_limition')
        }.to_json)
      end
    end
  end

  describe 'PUT /lists/:id' do
    context '#update [Admin view]' do
      it 'update a list' do
        sign_in_as(@admin)
        user_headers = response_headers
        put("/lists/#{@list.id}",
            { list: { title: 'new title' } },
            user_headers)
        @new_list = List.find_by(id: @list.id)
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ list: @new_list }.to_json)
      end

      it 'update a list with wrong params' do
        sign_in_as(@admin)
        user_headers = response_headers
        put("/lists/#{@list.id}",
            { list: { title: '' } },
            user_headers)
        @new_list = List.find_by(id: @list.id)
        expect(response).to have_http_status(:bad_request)
      end

      it "Admin can't update other admin's list" do
        sign_in_as(@admin1)
        user_headers = response_headers
        put("/lists/#{@list.id}",
            { list: { title: 'new title' } },
            user_headers)
        @new_list = List.find_by(id: @list.id)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({
          error: I18n.t('permissions.access_denied')
        }.to_json)
      end

      it 'Not allow for member user' do
        sign_in_as(@member)
        user_headers = response_headers
        put("/lists/#{@list.id}",
               { list: { title: 'new title' } },
               user_headers)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({
          error: I18n.t('permissions.member_limition')
        }.to_json)
      end
    end
  end

  describe 'DELETE /lists/:id' do
    context '#delete [Admin view]' do
      it 'delete a new list' do
        sign_in_as(@admin)
        user_headers = response_headers
        delete("/lists/#{@list.id}", user_headers)
        expect(response).to have_http_status(:no_content)
        expect(response.body).to eq('')
      end

      it 'delete a list not exsist' do
        sign_in_as(@admin)
        user_headers = response_headers
        delete("/lists/20", user_headers)
        expect(response).to have_http_status(:bad_request)
      end
    end
    context '#delete [Member view]' do
      it 'Not allow for member user' do
        sign_in_as(@member)
        user_headers = response_headers
        delete("/lists/#{@list.id}",
               { list: { title: 'new title' } },
               user_headers)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({
          error: I18n.t('permissions.member_limition')
        }.to_json)
      end
    end
  end
end
