require 'active_support/core_ext/module/delegation.rb'

module BasicPresenter
  class BasePresenter
    # extend Forwardable
    # Presenter Class should allow DomainClass instance 
    # to be initialized

    attr_reader :domain_object

    def initialize(domain_object)
      @domain_object = domain_object
    end

    class << self
      def presents(name)
        define_method(name) do
          @domain_object
        end
      end
    end
  end
end
