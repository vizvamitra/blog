require 'rails_helper'

RSpec.describe "Posts", type: :request do
  
  describe 'GET /posts' do
    before(:each){ get posts_path }
    subject{ response }

    it{ should have_http_status(:success) }
    it{ should render_template('posts/index') }
  end

  describe 'GET /posts/:id' do
    let(:published_post){ create(:post, :published) }
    let(:planned_post){ create(:post, :planned) }
    let(:expired_post){ create(:post, :expired) }
    let(:draft_post){ create(:post, :draft) }
    let(:not_published_posts){ [planned_post, expired_post, draft_post] }

    let(:request){ ->(id){ get post_path(id)} }
    before(:each){ request.call(id) }
    subject{ response }

    context 'when post is published' do
      let(:id){published_post.id}

      it { should have_http_status(:success) }
      it { should render_template('posts/show') }
    end

    context 'when post is not published' do
      let(:id){not_published_posts.sample.id}

      it { should have_http_status(:not_found) }
    end

    context 'when post doesn\'t exist' do
      let(:id){'no_such_post'}

      it { should have_http_status(:not_found) }
    end
  end

  describe 'GET /posts/new' do
    let(:request){ ->{ get new_post_path} }
    subject{ response }

    describe 'for signed in user' do
      before(:each) do
        sign_in
        request.call
      end

      it{ should have_http_status(:success) }
      it{ should render_template('posts/new') }
    end

    describe 'for guest' do
      before(:each){ request.call }

      it{ should have_http_status(302) }
    end
  end


  describe 'POST /posts' do
    let(:request){ ->{post posts_path, post: params} }
    subject{ response }

    describe 'for signed in user' do
      before(:each) do
        sign_in
        request.call
      end

      context 'when post params are valid' do
        let(:params){attributes_for(:post)}

        it{ should redirect_to(posts_path) }

        it 'creates a new post' do
          post = Post.last
          params.each{ |k,v| expect(post[k]).to eq v }
        end
      end

      context 'when post params are invalid' do
        let(:params){ attributes_for(:invalid_post) }

        it{ should render_template('posts/new') }
      end
    end

    describe 'for guest' do
      let(:params){ attributes_for(:post) }
      before(:each){ request.call }

      it{ should have_http_status(302) }
    end
  end

end