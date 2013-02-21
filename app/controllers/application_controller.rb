class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :oauth_client

  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :cached_providers

  private

  def cached_providers
    Rails.cache.fetch('providers', :expires_in => PROVIDERS_EXPIRE_IN) { @client.providers } if user_signed_in?
  end

  def cached_provider(id)
    cached_providers.each do |p|
      return p if p.id.eql? id
    end
  end

  def oauth_client
    options = {}
    options[:consumer_key] = CSB_CONSUMER_KEY
    options[:consumer_secret] = CSB_CONSUMER_SECRET
    options[:oauth_token] = session[:oauth_token]
    options[:oauth_token_secret] = session[:oauth_secret]
    @client = Csb::Client.new(options)
  end

  def current_user  
    @current_user ||= @client.user if session[:oauth_token] and session[:oauth_secret]
  end

  def user_signed_in?
    return 1 if current_user 
  end

  def authenticate_user!
    if !current_user
      flash[:error] = 'You need to sign in before accessing this page!'
      redirect_to signin_services_path
    end
  end
end
