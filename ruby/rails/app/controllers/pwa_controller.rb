class PwaController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :service_worker ]

  def manifest
    response.headers["Content-Type"] = "application/manifest+json"
    render action: :manifest, layout: false
  end

  def service_worker
    response.headers["Content-Type"] = "application/javascript"
    render action: :service_worker, layout: false, formats: [ :js ]
  end
end
