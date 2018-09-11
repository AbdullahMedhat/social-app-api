require 'rails_helper'

RSpec.describe 'Cards', type: :request do
  before(:each) do
    @admin = create(:admin)
    @admin1 = create(:admin)
    @member = create(:member)
    @list = create(:list, user: @admin)
    @list1 = create(:list, user: @admin1)
    @assign_member = ListUser.create(user: @member, list: @list)
    @card = create(:card, user: @admin, list: @list)
  end

  describe 'GET /cards' do
    context '#index  [Admin view]' do
      it 'returns a all cards in order' do
        sign_in_as(@admin)
        user_headers = response_headers
        get "/lists/#{@list.id}/cards", user_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ cards: @list.cards }.to_json)
      end
    end

    context '#index  [Member view]' do
      it 'Return all cards for the user list' do
        sign_in_as(@member)
        user_headers = response_headers
        get "/lists/#{@list.id}/cards", user_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ cards: @list.cards }.to_json)
      end
    end
  end

  describe 'GET /cards/:id' do
    context '#show  [Admin view]' do
      it 'returns a card' do
        sign_in_as(@admin)
        user_headers = response_headers
        get "/lists/#{@list.id}/cards/#{@card.id}", user_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({
          card: @card, card_comments: @card.comments.first_three
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

  describe 'POST /cards' do
    context '#create [Admin view]' do
      it 'create a new card' do
        sign_in_as(@admin)
        user_headers = response_headers
        post("/lists/#{@list.id}/cards",
             { card: { title: 'title', description: 'description' } },
             user_headers)
        expect(response).to have_http_status(:created)
        expect(response.body).to eq({ card: Card.last }.to_json)
      end

      it 'create a new card with invalid attributes' do
        sign_in_as(@admin)
        user_headers = response_headers
        post("/lists/#{@list.id}/cards",
             { card: { title: '', description: '' } },
             user_headers)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context '#create [Member view]' do
      it 'Create a new card' do
        sign_in_as(@member)
        user_headers = response_headers
        post("/lists/#{@list.id}/cards",
             { card: { title: 'title', description: 'description' } },
             user_headers)
        expect(response).to have_http_status(:created)
        expect(response.body).to eq({ card: Card.last }.to_json)
      end

      it 'Not allow to create card in not own list' do
        sign_in_as(@member)
        user_headers = response_headers
        post("/lists/#{@list1.id}/cards",
             { card: { title: 'title', description: 'description' } },
             user_headers)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({
          error: I18n.t('permissions.access_denied')
        }.to_json)
      end
    end
  end

  describe 'PUT /cards/:id' do
    context '#update [Admin view]' do
      it 'update a card' do
        sign_in_as(@admin)
        user_headers = response_headers
        put("/lists/#{@list.id}/cards/#{@card.id}",
            { card: { title: 'title', description: 'description' } },
            user_headers)
        @new_card = Card.find_by(id: @card.id)
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ card: @new_card }.to_json)
      end

      it 'update a card with invalid attributes' do
        sign_in_as(@admin)
        user_headers = response_headers
        put("/lists/#{@list.id}/cards/#{@card.id}",
            { card: { title: '', description: '' } },
            user_headers)
        @new_card = Card.find_by(id: @card.id)
        expect(response).to have_http_status(:bad_request)
      end

      it 'Not allow for member user' do
        sign_in_as(@member)
        user_headers = response_headers
        put("/lists/#{@list.id}/cards/#{@card.id}",
            { card: { title: 'title', description: 'description' } },
            user_headers)
        @new_card = Card.find_by(id: @list.id)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({
          error: I18n.t('permissions.access_denied')
        }.to_json)
      end
    end
  end

  describe 'DELETE /cards/:id' do
    context '#delete [Admin view]' do
      it 'delete a card' do
        sign_in_as(@admin)
        user_headers = response_headers
        delete("/lists/#{@list.id}/cards/#{@card.id}", user_headers)
        expect(response).to have_http_status(:no_content)
        expect(response.body).to eq('')
      end

      it 'delete a card not exsist' do
        sign_in_as(@admin)
        user_headers = response_headers
        delete("/lists/#{@list.id}/cards/2000", user_headers)
        expect(response).to have_http_status(:not_found)
      end
    end
    context '#delete [Member view]' do
      it 'Not allow to delete other members cards' do
        sign_in_as(@member)
        user_headers = response_headers
        delete("/lists/#{@list.id}/cards/#{@card.id}", user_headers)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({
          error: I18n.t('permissions.access_denied')
        }.to_json)
      end
    end
  end
end
