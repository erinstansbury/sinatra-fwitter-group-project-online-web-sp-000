class TweetsController < ApplicationController

	get '/tweets' do
		if !session[:user_id]
			redirect to '/login'
		else
			@user = User.find(session[:user_id])
			erb :'/tweets/tweets'
		end
	end

	get '/tweets/new' do
		if !session[:user_id]
			redirect to '/login'
		else
			@user = User.find(session[:user_id])
			erb :'/tweets/create_tweet'
		end
	end

	post '/tweets' do
		if !params[:content].empty?
			@tweet = Tweet.create(content: params[:content])
			@tweet.user_id = session[:user_id]
			@tweet.save			
			flash[:message] = "You have created a new tweet!"
			redirect to "/tweets"
		else
			redirect to "/tweets/new"
		end
	end

	get '/tweets/:id' do
		if !session[:user_id]
			redirect to "/login"
		else
			@tweet = Tweet.find_by_id(params[:id])
			erb :'/tweets/show_tweet'
		end
	end

	get '/tweets/:id/edit' do
		if !session[:user_id]
			redirect to "/login"
		else
			@tweet = Tweet.find_by_id(params[:id])
			erb :'/tweets/edit_tweet'
		end
	end

	patch '/tweets/:id' do
		#binding.pry
		@tweet = Tweet.find_by_id(params[:id])
		if params[:content].empty?
			flash[:message] = "Tweet can not be blank"
			redirect to "/tweets/#{@tweet.id}/edit"
		else
			@tweet.content = params[:content]
			@tweet.save
			flash[:message] = "Successfully updated your tweet!"
			redirect to "/tweets"
		end
	end

	delete '/tweets/:id/delete' do
		#binding.pry
		@tweet = Tweet.find_by_id(params[:id])
		if !session[:user_id]
			redirect to "/login"
		elsif
			@tweet.id != session[:user_id]
			flash[:message] = "You can only deleted tweets you've created."
			redirect to "/login"
		else
			@tweet = Tweet.find_by_id(params[:id])
			@tweet.delete
			flash[:message] = "Sucessfully deleted tweet!"
			redirect to "/tweets"
		end
	end

