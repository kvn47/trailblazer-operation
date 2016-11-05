require "test_helper"

class InheritanceTest < Minitest::Spec
  Song = Struct.new(:id, :title, :length) do
    def self.find_by(id:nil); id.nil? ? nil : new(id) end
  end

  class Create < Trailblazer::Operation
    self["a"] = "A"
    self["b"] = "B"
    self["c"] = "D"

    def self.class(*skills)
      Class.new(Trailblazer::Operation). tap do |klass|
        skills.each { |skill| klass.heritage.record(:[]=, skill, self[skill]) }
      end
    end
  end

  class Update < Create.class("a", "b")
  end

  it do
    Update["a"].must_equal "A"
    Update["b"].must_equal "B"
    Update["c"].must_equal nil
  end
end
