module Cenit
  module TenantToken
    extend ActiveSupport::Concern

    include Token

    class << self

      delegate :all, :where, :create, to: :basic_tenant_token_class

      def basic_tenant_token_class
        Cenit::BasicTenantToken
      end
    end

    included do
      belongs_to :tenant, class_name: Cenit::MultiTenancy.tenant_model_name, inverse_of: nil

      before_save :catch_tenant
    end

    def catch_tenant
      self.tenant ||= Cenit::MultiTenancy.tenant_model.current_tenant if new_record?
      true
    end

    def set_current_tenant!
      set_current_tenant(force: true)
    end

    def set_current_tenant(options = {})
      tenant = get_tenant
      if Cenit::MultiTenancy.tenant_model.current.nil? || options[:force]
        Cenit::MultiTenancy.tenant_model.current = tenant
      end
      tenant
    end

    def get_tenant
      tenant
    end
  end
end