module BasicPresenter
  module Generators
    class PresenterGenerator < Rails::Generators::NamedBase

      check_class_collision suffix: "Presenter"

      def create_presenter_file
        create_file "app/presenters/#{file_name}_presenter.rb", <<~FILE
  class #{class_name}Presenter < ApplicationPresenter
    presents :#{plural_name.singularize}

    # Methods delegated to Presented Class #{class_name} object's #{plural_name.singularize}
    @delegation_methods = []

    delegate *@delegation_methods, to: :#{plural_name.singularize}

    # Start the methods
    # def full_name
    #   first_name + last_name
    # end
  end
        FILE
      end
    end
  end
end
