require 'spec_helper'

describe PodcastsController do

  login_admin

  describe "GET index" do
    it "assigns all podcasts as @podcasts" do
      podcast = create(:podcast)
      get :index, {}
      assigns(:podcasts).should eq([podcast])
    end
  end

  describe "GET show" do
    it "assigns the requested podcast as @podcast" do
      podcast = create(:podcast)
      get :show, {:id => podcast.to_param}
      assigns(:podcast).should eq(podcast)
    end
  end

  describe "GET new" do
    it "assigns a new podcast as @podcast" do
      get :new, {}
      assigns(:podcast).should be_a_new(Podcast)
    end
  end

  describe "GET edit" do
    it "assigns the requested podcast as @podcast" do
      podcast = create(:podcast)
      get :edit, {:id => podcast.to_param}
      assigns(:podcast).should eq(podcast)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Podcast" do
        pending "This creates a sidekiq worker process, so does not save directly"
        expect {
          post :create, {:podcast => attributes_for(:podcast)}
        }.to change(Podcast, :count).by(1)
      end

      it "assigns a newly created podcast as @podcast" do
        pending "This creates a sidekiq worker process, so does not save directly"
        post :create, {:podcast => attributes_for(:podcast)}
        assigns(:podcast).should be_a(Podcast)
        assigns(:podcast).should be_persisted
      end

      it "redirects to the created podcast" do
        pending "This creates a sidekiq worker process, so does not save directly"
        post :create, {:podcast => attributes_for(:podcast)}
        response.should redirect_to(Podcast.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved podcast as @podcast" do
        pending "This creates a sidekiq worker process, so does not save directly"
        # Trigger the behavior that occurs when invalid params are submitted
        Podcast.any_instance.stub(:save).and_return(false)
        post :create, {:podcast => { "feed" => "" }}
        assigns(:podcast).should be_a_new(Podcast)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        post :create, {:podcast => attributes_for(:podcast, feed: '')}
        response.should redirect_to(new_podcast_url)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested podcast" do
        podcast = create(:podcast)
        # Assuming there are no other podcasts in the database, this
        # specifies that the Podcast created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Podcast.any_instance.should_receive(:update).with({ "title" => "MyString" })
        put :update, {:id => podcast.to_param, :podcast => { "title" => "MyString" }}
      end

      it "assigns the requested podcast as @podcast" do
        podcast = create(:podcast)
        put :update, {:id => podcast.to_param, :podcast => attributes_for(:podcast)}
        assigns(:podcast).should eq(podcast)
      end

      it "redirects to the podcast" do
        podcast = create(:podcast)
        put :update, {:id => podcast.to_param, :podcast => attributes_for(:podcast)}
        response.should redirect_to(podcast)
      end
    end

    describe "with invalid params" do
      it "assigns the podcast as @podcast" do
        podcast = create(:podcast)
        # Trigger the behavior that occurs when invalid params are submitted
        Podcast.any_instance.stub(:save).and_return(false)
        put :update, {:id => podcast.to_param, :podcast => { "feed" => "" }}
        assigns(:podcast).should eq(podcast)
      end

      it "re-renders the 'edit' template" do
        podcast = create(:podcast)
        # Trigger the behavior that occurs when invalid params are submitted
        Podcast.any_instance.stub(:save).and_return(false)
        put :update, {:id => podcast.to_param, :podcast => { "feed" => "" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested podcast" do
      podcast = create(:podcast)
      expect {
        delete :destroy, {:id => podcast.to_param}
      }.to change(Podcast, :count).by(-1)
    end

    it "redirects to the podcasts list" do
      podcast = create(:podcast)
      delete :destroy, {:id => podcast.to_param}
      response.should redirect_to(podcasts_url)
    end
  end

end
