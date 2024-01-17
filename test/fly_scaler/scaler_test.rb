require "test_helper"

module FlyScaler
  class ScalerTest < ActiveSupport::TestCase
    setup do
      @fly = Mocktail.of(FlyApi)
    end

    test "#scaleable?" do
      scaler = Scaler.new(fly: @fly)
      assert_not scaler.scaleable?
    end

    test "#up" do
      stubs { @fly.running_machines }.with { 1 }
      stubs { @fly.total_machines }.with { 2 }
      stubs { |m| @fly.start_machine(m.any) }.with { true }

      scaler = Scaler.new(fly: @fly)
      scaler.up

      verify { @fly.running_machines }
      verify { @fly.total_machines }
      verify { |m| @fly.start_machine(m.any) }
    end

    test "#up too many machines" do
      stubs { @fly.running_machines }.with { 2 }
      stubs { @fly.total_machines }.with { 2 }

      scaler = Scaler.new(fly: @fly)
      scaler.up

      verify { @fly.running_machines }
      verify { @fly.total_machines }
      assert_equal 0, Mocktail.calls(@fly, :start_machine).count
    end

    test "#down" do
      # I don't know how to test this as it is using a lot of coupling.
    end
  end
end
