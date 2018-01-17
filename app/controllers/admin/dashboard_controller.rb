class Admin::DashboardController < Admin::AdminController

  add_breadcrumb _('Dashboard'), :admin_dashboard_path

  def dashboard
    authorize :dashboard
  end

end