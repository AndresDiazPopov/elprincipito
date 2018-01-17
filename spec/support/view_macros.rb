module ViewMacros
  def create_admin_user_and_stub_policies
    let(:admin_user) { create(:admin_user) }

    before do

      admin_user.has_role!(:admin)

      def view.policy(the_class)
      end

      def view.policy_scope(the_class)
      end

      allow(view).to receive(:policy) do |the_class|
        Pundit.policy(admin_user, the_class)
      end

      allow(view).to receive(:policy_scope) do |the_class|
        Pundit.policy_scope(admin_user, the_class)
      end
      
    end
  end
end