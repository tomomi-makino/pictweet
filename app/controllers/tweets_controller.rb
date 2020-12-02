class TweetsController < ApplicationController

  before_action :move_to_index, except: :index
  before_action :set_tweet, only: [:destroy, :edit, :update, :show]

  def index
    @tweets = Tweet.includes(:user).page(params[:page]).per(5).order("created_at DESC")
  end

  def new
    @tweet = Tweet.new
  end

  def create
    Tweet.create(tweet_params)
  end

  def destroy
    if @tweet.user_id == current_user.id
      @tweet.destroy
    end
  end

  def edit
  end

  def update
    if @tweet.user_id == current_user.id
      @tweet.update(tweet_params)
    end
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user)
  end

  def search
    @tweets = Tweet.search(params[:keyword])
  end

  private
  def tweet_params
    params.require(:tweet).permit(:image, :text).merge(user_id: current_user.id)
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

end
