require 'active_support/inflector'

module BasicPresenter
  module Concern
    def presenter
      if @presenter_class.nil?
        @old_presenter_class = self.presenter_class = presenter_class
        return @presenter = presenter_class.new(self)
      end
      return @presenter if presenter_class_not_changed?
      @presenter = presenter_class.new(self)
      @old_presenter_class = @presenter_class
      @presenter
    end

    def default_presenter
      "#{self.class}Presenter".constantize
    end

    def presenter_class
      @presenter_class || default_presenter
    end

    def presenter_class=(vd)
      @old_presenter_class = @presenter_class
      @presenter_class = vd
    end

    def presenter_class_changed?
      !(presenter_class_not_changed?)
    end

    def presenter_class_not_changed?
      (@old_presenter_class == @presenter_class)
    end
  end
end
