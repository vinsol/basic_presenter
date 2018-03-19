require 'spec_helper'
#require 'forwardable'

class DomainClass
  include BasicPresenter::Concern

  attr_accessor :first_name, :last_name

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end
end

#class BasePresenter
#  # extend Forwardable
#  # Presenter Class should allow DomainClass instance
#  # to be initialized
#
#  attr_reader :domain_object
#
#  def initialize(domain_object)
#    @domain_object = domain_object
#  end
#
#  class << self
#    def presents(name)
#      define_method(name) do
#        @domain_object
#      end
#    end
#  end
#end

class DomainClassPresenter < BasicPresenter::BasePresenter
  presents :domain_class

  @delegation_methods = [:first_name, :last_name]

  # def_delegators :domain_class, *@delegation_methods
  delegate *@delegation_methods, to: :domain_class

  def full_name
    first_name + last_name
  end
end

class AnotherPresenter < BasicPresenter::BasePresenter
  presents :domain_class

  def full_name
    domain_class.first_name + domain_class.last_name
  end
end

module BasicPresenter
  describe Concern do
    let(:dummy_domain_object) { DomainClass.new('Welcome', 'Presenter') }

    context "Presenter Class Modification Interface" do
      it "should determine default presenter class by the Domain Class" do
        expect(dummy_domain_object.default_presenter).to eq(DomainClassPresenter)
      end

      it "should tell current presenter class" do
        expect(dummy_domain_object.presenter_class).to eq(DomainClassPresenter)
      end

      it "should assume default presenter class as presenter class when not set" do
        expect(dummy_domain_object.presenter_class).to eq(DomainClassPresenter)
      end

      it "should recognize presenter class when set" do
        expect(dummy_domain_object.presenter_class).to eq(DomainClassPresenter)
        dummy_domain_object.presenter_class = AnotherPresenter
        expect(dummy_domain_object.presenter_class).to eq(AnotherPresenter)
      end
    end

    context "Helper Methods" do
      it "should be able to inform change in Presenter Class" do
        expect(dummy_domain_object.presenter_class).to eq(DomainClassPresenter)
        expect(dummy_domain_object).to be_presenter_class_not_changed
        dummy_domain_object.presenter_class = AnotherPresenter
        expect(dummy_domain_object).to be_presenter_class_changed
        expect(dummy_domain_object.presenter_class).to eq(AnotherPresenter)
      end
    end

    context "Presenter Instance Creation to allow delegation of Presenter Methods" do
      it "should delegate presenter methods on Default Presenter when not set" do
        expect(dummy_domain_object.presenter).to be_an_instance_of(DomainClassPresenter)
      end

      it "should delegate presenter methods on Explicit Presenter if set" do
        dummy_domain_object.presenter_class = AnotherPresenter
        expect(dummy_domain_object.presenter).to be_an_instance_of(AnotherPresenter)
      end

      context "Create Presenter Instance Once and return same if Presenter Class not changed" do
        it "when no Presenter Class set" do
          dummy_domain_object_presenter = dummy_domain_object.presenter
          expect(dummy_domain_object.presenter).to eq(dummy_domain_object_presenter)
          expect(dummy_domain_object.presenter).to eq(dummy_domain_object_presenter)
          expect(dummy_domain_object.presenter).to eq(dummy_domain_object_presenter)
        end

        it "when Presenter Class changed" do
          dummy_domain_object_presenter = dummy_domain_object.presenter
          dummy_domain_object.presenter_class = AnotherPresenter
          new_dummy_domain_object_presenter = dummy_domain_object.presenter
          expect(dummy_domain_object_presenter).to be_an_instance_of(DomainClassPresenter)
          expect(new_dummy_domain_object_presenter).to be_an_instance_of(AnotherPresenter)
          expect(dummy_domain_object.presenter).to eq(new_dummy_domain_object_presenter)
          expect(dummy_domain_object.presenter).to eq(new_dummy_domain_object_presenter)
          expect(dummy_domain_object.presenter).to eq(new_dummy_domain_object_presenter)
        end
      end
    end

    describe "Presenter Methods Available on Domain Object through #presenter" do
      it "should allow presenter methods to be called through #presenter" do
        expect(dummy_domain_object.presenter.full_name).to eq('WelcomePresenter')
      end

      it "should allow domain_object to be accessed through #domain_object" do
        expect(dummy_domain_object.presenter.domain_object).to eq(dummy_domain_object)
      end
    end
  end
end
