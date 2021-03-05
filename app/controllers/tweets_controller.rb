class TweetsController < ApplicationController

  get '/tweets' do
    if session[:user_id]
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      redirect '/login'
    end
  end

  get '/tweets/new' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      erb :'tweets/new'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    if params[:content] == ""
      redirect '/tweets/new'
    else
      @tweet = Tweet.new(:content => params[:content])
      @user = User.find(session[:user_id])
      @user.tweets.push(@tweet)
      @user.save
      redirect '/tweets'
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