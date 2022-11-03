class ApplicationController < ActionController::Base
  before_action :set_online

  private

  # set to online
  def set_online
    if !!current_user
      # using separate Redis database
      # such as $redis_onlines = Redis.new db: 15
      # value not need, only key
      $redis_onlines.set( "user:#{current_user.id}", nil, ex: 10*60 )
      # 'ex: 10*60' - set time to live - 10 minutes
    else
      $redis_onlines.set( "ip:#{request.remote_ip}", nil, ex: 10*60 )
    end
  end

  def all_signed_in_in_touch
    ids = []
    $redis_onlines.scan_each( match: 'user*' ){|u| ids << u.gsub("user:", "") }
    ids
  end

  def all_anonymous_in_touch
    $redis_onlines.scan_each( match: 'ip*' ).to_a.size
  end

  def all_who_are_in_touch
    $redis_onlines.dbsize
  end
end
