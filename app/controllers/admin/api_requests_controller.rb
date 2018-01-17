class Admin::ApiRequestsController < Admin::AdminController

  include SortableTable

  add_breadcrumb _('Peticiones al API'), :admin_api_requests_path

  def index
    authorize ApiRequest
    @user_id = params[:user_id] if !params[:user_id].blank?
    @login_id = params[:login_id] if !params[:login_id].blank?
    @api_requests = ::ApiRequests::Search.call(
      user: @user_id,
      login: @login_id)
      .page(params[:page])
      .includes(:user, :login)
      .order(sort_column + ' ' + sort_direction)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @api_request = ApiRequest.find(params[:id])
    authorize @api_request
    add_breadcrumb @api_request.id.to_s, admin_api_request_path(@api_request)
  end

  private

    def sortable_columns
      %w[id logins.id users.email path ip network_type state created_at]
    end

end