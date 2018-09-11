require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  before(:each) do
    @admin = create(:admin)
    @admin1 = create(:admin)
    @member = create(:member)
    @member1 = create(:member)
    @list = create(:list, user: @admin)
    @list1 = create(:list, user: @admin1)
    @assign_member = ListUser.create(user: @member, list: @list)
    @card = create(:card, user: @admin, list: @list)
    @comment = create(:comment, user: @admin)
  end
  
  describe 'GET /comments' do
    context '#index  [Admin view]' do
      it 'returns a all comments for a card' do
        sign_in_as(@admin)
        user_headers = response_headers
        get "/lists/#{@list.id}/cards/#{@card.id}/comments", user_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ comments: @card.comments }.to_json)
      end

      it 'returns a all replaies for a comment' do
        sign_in_as(@admin)
        user_headers = response_headers
        get "/lists/#{@list.id}/cards/#{@card.id}/comments?comment_id=#{@comment.id}",
            user_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({
          comment: @comment, replaies: @comment.replaies
        }.to_json)
      end
    end

    context '#index  [Member view]' do
      it 'Return all comments for the user list' do
        sign_in_as(@member)
        user_headers = response_headers
        get "/lists/#{@list.id}/cards/#{@card.id}/comments", user_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ comments: @card.comments }.to_json)
      end
    end
  end

  describe 'GET /comments/:id' do
    context '#show  [Admin view]' do
      it 'returns a comment with replaies' do
        sign_in_as(@admin)
        user_headers = response_headers
        get "/lists/#{@list.id}/cards/#{@card.id}/comments/#{@comment.id}",
            user_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({
          comment: @comment, replaies: @comment.replaies
        }.to_json)
      end
    end
    context '#show  [Member view]' do
      it 'returns a comment with replaies' do
        sign_in_as(@member)
        user_headers = response_headers
        get "/lists/#{@list.id}/cards/#{@card.id}/comments/#{@comment.id}",
            user_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({
          comment: @comment, replaies: @comment.replaies
        }.to_json)
      end
    end
  end
  describe 'POST /comments' do
    context '#create [Admin view]' do
      it 'create a new comment' do
        sign_in_as(@admin)
        user_headers = response_headers
        post("/lists/#{@list.id}/cards/#{@card.id}/comments",
             { comment: { content: 'random comment' } },
             user_headers)
        expect(response).to have_http_status(:created)
        expect(response.body).to eq({ comment: Comment.last }.to_json)
      end

      it 'create a new comment with invalid attributes' do
        sign_in_as(@admin)
        user_headers = response_headers
        post("/lists/#{@list.id}/cards/#{@card.id}/comments",
             { comment: { content: '' } },
             user_headers)
        expect(response).to have_http_status(:bad_request)
      end

      it 'create a new replay' do
        sign_in_as(@admin)
        user_headers = response_headers
        post(
          "/lists/#{@list.id}/cards/#{@card.id}/comments?comment_id=#{@comment.id}",
          { comment: { content: 'random comment' } },
          user_headers
        )
        expect(response).to have_http_status(:created)
        expect(response.body).to eq({ comment: Comment.last }.to_json)
      end
    end

    context '#create [Member view]' do
      it 'Create a new card' do
        sign_in_as(@member)
        user_headers = response_headers
        post("/lists/#{@list.id}/cards/#{@card.id}/comments",
             { comment: { content: 'random comment' } },
             user_headers)
        expect(response).to have_http_status(:created)
        expect(response.body).to eq({ comment: Comment.last }.to_json)
      end

      it 'Not allow to create card in not own list' do
        sign_in_as(@member1)
        user_headers = response_headers
        post("/lists/#{@list.id}/cards/#{@card.id}/comments",
             { comment: { content: 'random comment' } },
             user_headers)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({
          error: I18n.t('permissions.access_denied')
        }.to_json)
      end
    end
  end

  describe 'PUT /comments/:id' do
    context '#update [Admin view]' do
      it 'update a card' do
        sign_in_as(@admin)
        user_headers = response_headers
        put(
          "/lists/#{@list.id}/cards/#{@card.id}/comments/#{@comment.id}",
          { comment: { content: 'random comment' } },
          user_headers
        )
        @new_comment = Comment.find_by(id: @comment.id)
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ comment: @new_comment }.to_json)
      end

      it 'update a card with invalid attributes' do
        sign_in_as(@admin)
        user_headers = response_headers
        put(
          "/lists/#{@list.id}/cards/#{@card.id}/comments/#{@comment.id}",
          { comment: { content: '' } },
          user_headers
        )
        expect(response).to have_http_status(:bad_request)
      end

      it 'Not allow for member to edit others comments' do
        sign_in_as(@member)
        user_headers = response_headers
        put(
          "/lists/#{@list.id}/cards/#{@card.id}/comments/#{@comment.id}",
          { comment: { content: 'random comment' } },
          user_headers
        )
        @new_comment = Comment.find_by(id: @comment.id)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({
          error: I18n.t('permissions.access_denied')
        }.to_json)
      end
    end
  end

  describe 'DELETE /comments/:id' do
    context '#delete [Admin view]' do
      it 'delete a comment' do
        sign_in_as(@admin)
        user_headers = response_headers
        delete(
          "/lists/#{@list.id}/cards/#{@card.id}/comments/#{@comment.id}",
          user_headers
        )
        expect(response).to have_http_status(:no_content)
        expect(response.body).to eq('')
      end

      it 'delete a replay' do
        sign_in_as(@admin)
        user_headers = response_headers
        delete(
          "/lists/#{@list.id}/cards/#{@card.id}/comments/#{@comment.id}",
          user_headers
        )
        expect(response).to have_http_status(:no_content)
        expect(response.body).to eq('')
      end

      it 'delete a card not exsist' do
        sign_in_as(@admin)
        user_headers = response_headers
        delete(
          "/lists/#{@list.id}/cards/#{@card.id}/comments/3000",
          user_headers
        )
        expect(response).to have_http_status(:not_found)
      end
    end
    context '#delete [Member view]' do
      it 'Not allow to delete other members cards' do
        sign_in_as(@member)
        user_headers = response_headers
        delete(
          "/lists/#{@list.id}/cards/#{@card.id}/comments/#{@comment.id}",
          user_headers
        )
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({
          error: I18n.t('permissions.access_denied')
        }.to_json)
      end
    end
  end
end
