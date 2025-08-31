class StatusController < ApplicationController

  def index
    result = {
      :db_result     => ActiveRecord::Base.connection.execute("SELECT version()").column_values(0).first,
      :rails_env     => Rails.env,
      :rails_version => Rails.version,
      :ruby_version  => RUBY_VERSION,
      :status        => 'OK',
    }

    render :json => result
  end

end
