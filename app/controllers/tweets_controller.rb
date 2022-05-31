class TweetsController < ApplicationController
    before_action :set_tweet, only: [:edit, :show]
    before_action :move_to_index, except: [:show, :index, :search]

    def index
        @tweets = Tweet.includes(:user).order("created_at DESC")
    end
    def new
        @tweet = Tweet.new
    end
    def create
        Tweet.create(tweet_params)
        format.turbo_stream
        # redirect_to tweets_path
    end
    def destroy
        tweet = Tweet.find(params[:id])
        tweet.destroy
        #redirect_to tweet_path(tweet.id)
    end
    def edit
    end
    def update
        tweet = Tweet.find(params[:id])
        tweet.update(tweet_params)
        redirect_to tweets_path
    end
    def show 
        @comment = Comment.new
        @comments = @tweet.comments.includes(:user)

    end
    def search
        @tweets = Tweet.search(params[:keyword])
        #render action: "search"
    end
    private
    
    def tweet_params
        params.require(:tweet).permit(:id, :image, :text).merge(user_id: current_user.id)
    end
    def set_tweet
        @tweet = Tweet.find(params[:id])
    end
    def move_to_index
        unless user_signed_in?
            redirect_to action: :index
        end
    end
end
