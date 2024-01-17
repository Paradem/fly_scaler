require "test_helper"

module FlyScaler
  class FlyApiTest < ActiveSupport::TestCase
    setup do
      @api = Mocktail.of(FlyApi::Api)
      stubs { @api.machines }.with {
        [
          FlyApi::Machine.new("abbabba", "started", "job"),
          FlyApi::Machine.new("aaazzzddd", "stopped", "job")
        ]
      }
      stubs { |m| @api.start_machine(m.any) }.with { true }
    end

    test "#machines" do
      fly = FlyApi.new(api: @api)
      assert_equal 2, fly.job_machines.count
      assert_equal "abbabba", fly.job_machines.first.id
    end

    test "#start_machine: id is not machine that exists" do
      fly = FlyApi.new(api: @api)
      assert_not fly.start_machine("asetasetaet")
    end

    test "#start_machine: id is a machine" do
      fly = FlyApi.new(api: @api)
      assert fly.start_machine("abbabba")
    end

    test "#total_machines" do
      fly = FlyApi.new(api: @api)
      assert_equal 2, fly.total_machines
    end

    test "#get_machine_id" do
      fly = FlyApi.new(api: @api)
      assert_equal "aaazzzddd", fly.get_machine_id
    end

    test "#running_machines" do
      fly = FlyApi.new(api: @api)
      assert_equal 1, fly.running_machines
    end
  end
end
