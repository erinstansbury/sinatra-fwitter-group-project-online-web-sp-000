class TweetsController < ApplicationController

  get '/tweets' do 
    if logged_in?
      @tweets = Tweet.all
      @user = User.find_by_id(session[:user_id])
      erb :'tweets/tweets'
    else  
      redirect to '/login'       
    end
  end 

  get '/tweets/new' do
    if logged_in? 
      erb :'tweets/create_tweet'
    else
      redirect to '/login'
    end  
  end 

  post '/tweets' do
    if params[:content] == nil || params[:content] == "" 
      redirect to "/tweets/new"
    else       
      @tweet = Tweet.create(:content => params[:content], :user_id => session[:user_id])
      @tweet.user_id = session[:user_id]
      @tweet.save
      if params[:phone_number] != ""
        @client = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)        
        number = "#{params[:phone_number]}"
        @client.messages.create(
          from: 'Number goes here', 
          to: number,
          body: params[:content] + "\n - sent by #{@tweet.user.username} from Fwitter"
          )
      end
      redirect to "/tweets/#{@tweet.id}"
    end
  end
    
  get '/tweets/:id' do 
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      @user = User.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect to '/login'
    end    
  end   

  get '/tweets/:id/edit' do 
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      if self.current_user.id == @tweet.user_id
        erb :'tweets/edit_tweet'
      else
        redirect to '/tweets'  
      end
    else
      redirect to '/login'
    end 
  end

  patch '/tweets/:id' do 
    if params[:content] == nil || params[:content] == ""
      redirect to "/tweets/#{params[:id]}/edit"
    else   
      @tweet = Tweet.find_by_id(params[:id])
      @tweet.content = params[:content]
      @tweet.save
      redirect to "/tweets/#{@tweet.id}"
    end
  end  

  delete '/tweets/:id/delete' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      if self.current_user.id == @tweet.user_id
        @tweet.delete
        redirect to "/tweets"
      else
      redirect to "/tweets"
      end
    else 
      redirect to '/login'    
    end  
  end

helpers do 

    def logged_in?
      !!session[:user_id]
    end
    
    def current_user
      User.find(session[:user_id])
    end   
  end  

end  
