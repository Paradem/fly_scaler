require "test_helper"

module FlyScaler
  class TestScaler < Minitest::Test
    def setup
      @fly = Mocktail.of(FlyApi)
    end

    def test_scaleable
      scaler = Scaler.new(fly: @fly)
      assert !scaler.scaleable?
    end

    def test_up
      Mocktail.stubs { @fly.running_machines }.with { 1 }
      Mocktail.stubs { @fly.total_machines }.with { 2 }
      Mocktail.stubs { |m| @fly.start_machine(m.any) }.with { true }

      scaler = Scaler.new(fly: @fly)
      scaler.up

      Mocktail.verify { @fly.running_machines }
      Mocktail.verify { @fly.total_machines }
      Mocktail.verify { |m| @fly.start_machine(m.any) }
    end

    def test_up_too_many_machines
      Mocktail.stubs { @fly.running_machines }.with { 2 }
      Mocktail.stubs { @fly.total_machines }.with { 2 }

      scaler = Scaler.new(fly: @fly)
      scaler.up

      Mocktail.verify { @fly.running_machines }
      Mocktail.verify { @fly.total_machines }
      assert_equal 0, Mocktail.calls(@fly, :start_machine).count
    end

    def test_down
      # I don't know how to test this as it is using a lot of coupling.
    end
  end
end
