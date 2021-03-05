class TweetsController < ApplicationController
  get '/tweets/new' do
    if logged_in?
      erb :'/tweets/create_tweet'
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
    @tweet = current_user.tweets.create(content: params[:content])
    if @tweet.valid?
      redirect to '/tweets'
    else
      redirect to '/tweets/new'
    end
  end

  get '/tweets' do
    if logged_in?
      @user = current_user
      erb :'/tweets/tweets'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @user = current_user
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in? && current_user.tweets.include?(Tweet.find_by(id: params[:id]))
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/edit_tweet' if current_user.tweets.include?(@tweet)
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id' do
    if logged_in? && current_user.tweets.include?(Tweet.find_by(id: params[:id]))
      @tweet = Tweet.find(params[:id])
      @tweet.update(content: params[:content])
      if @tweet.valid?
        redirect to "/tweets/#{@tweet.id}"
      else
        redirect to "/tweets/#{params[:id]}/edit"
      end
    end
  end

  delete '/tweets/:id/delete' do
    tweet = current_user.tweets.find_by(id: params[:id])
    if tweet && tweet.destroy
      redirect to '/tweets'
    else
      redirect to "/tweets/#{params[:id]}"
    end
  end
end