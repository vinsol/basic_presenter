module BasicPresenter
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def create_presenter_file
        create_file "app/presenters/application_presenter.rb", <<~FILE
          class ApplicationPresenter < BasicPresenter::BasePresenter
            ## Shared Methods might come here
          end
        FILE
      end
    end
  end
end
