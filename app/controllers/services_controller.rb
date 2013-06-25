require 'csb_error'

class ServicesController < ApplicationController
  before_filter :authenticate_user!, :except => [:create, :signin, :signup, :newaccount, :failure]
  protect_from_forgery :except => :create     

  # GET all authentication services assigned to the current user
  def index
  end

  # POST from signup view
  def newaccount
    admin = Csb::Client.new(
      :consumer_key    => CSB_CONSUMER_KEY,
      :consumer_secret => CSB_CONSUMER_SECRET,
      :oauth_token     => CSB_PORTAL_TOKEN,
      :oauth_token_secret    => CSB_PORTAL_SECRET
    )

    @csb_error = CsbError.new
    unless params[:password].eql? params[:password_confirmation]
      @csb_error.errors.add('', "password and password confirmation don't match")
    else
      admin.user_new(name: params[:name], email: params[:email], password: params[:password])
    end

    respond_to do |format|
      if @csb_error.errors.empty?
        format.html { redirect_to root_path }
      else
        format.html { render action: 'signup' }
      end
    end
  end

  def signup
    @csb_error = CsbError.new
  end

  # Sign out current user
  def signout 
    if current_user
      session[:oauth_token] = nil
      session[:oauth_secret] = nil
      session.delete :oauth_token
      session.delete :oauth_secret
      flash[:notice] = 'You have been signed out!'
    end  
    redirect_to root_url
  end

  # callback: success
  # This handles signing in and adding an authentication service to existing accounts itself
  # It renders a separate view if there is a new user to create
  def create
    # get the service parameter from the Rails router
    params[:service] ? service_route = params[:service] : service_route = 'No service recognized (invalid callback)'

    # get the full hash from omniauth
    omniauth = request.env['omniauth.auth']

    # continue only if hash and parameter exist
    if omniauth and params[:service]

      # map the returned hashes to our variables first - the hashes differs for every service

      # create a new hash
      @authhash = Hash.new

      if service_route == 'csb'
        omniauth['info']['email'] ? @authhash[:email] = omniauth['info']['email'] : @authhash[:email] = ''
        omniauth['info']['name'] ? @authhash[:name] = omniauth['info']['name'] : @authhash[:name] = ''
        omniauth['uid'] ? @authhash[:uid] = omniauth['uid'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
      else        
        # debug to output the hash that has been returned when adding new services
        render :text => omniauth.to_yaml
        return
      end 

      if @authhash[:uid] != '' and @authhash[:provider] != ''
        # if the user is currently signed in, he/she might want to add another account to signin
        if user_signed_in?
          redirect_to services_path
        else
          session[:oauth_token] = omniauth['credentials']['token']
          session[:oauth_secret] = omniauth['credentials']['secret']
          flash[:notice] = 'Signed in successfully via ' + @authhash[:provider].capitalize + '.'
          redirect_to root_url
        end
      else
        flash[:error] =  'Error while authenticating via ' + service_route + '/' + @authhash[:provider].capitalize + '. The service returned invalid data for the user id.'
        redirect_to signin_path
      end
    else
      flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '. The service did not return valid data.'
      redirect_to signin_path
    end
  end

  # callback: failure
  def failure
    flash[:error] = 'There was an error at the remote authentication service. You have not been signed in.'
    redirect_to root_url
  end
end
