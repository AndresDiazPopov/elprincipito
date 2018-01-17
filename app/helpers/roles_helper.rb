module RolesHelper

  def linked_role_name_for(role)
    title = AdminRole.name_for(role.name)
    if role.authorizable_type == 'Shop'
      shop = Shops::Find.call(id: role.authorizable_id)
      title = title + ' ' + link_to(shop.name, admin_shop_path(shop))
    elsif role.authorizable_type == 'Company'
      company = Companies::Find.call(id: role.authorizable_id)
      title = title + ' ' + link_to(company.name, admin_company_path(company))
    end
    title
  end

end
