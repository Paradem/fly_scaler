require "test_helper"

module FlyScaler
  class TestFlyApi < Minitest::Test
    def setup
      @api = Mocktail.of(FlyApi::Api)
      stubs { @api.machines }.with {
        [
          FlyApi::Machine.new("abbabba", "started", "job"),
          FlyApi::Machine.new("aaazzzddd", "stopped", "job")
        ]
      }
      stubs { |m| @api.start_machine(m.any) }.with { true }
    end

    def test_machines
      fly = FlyApi.new(api: @api)
      assert_equal 2, fly.job_machines.count
      assert_equal "abbabba", fly.job_machines.first.id
    end

    def test_start_machine_that_doesnt_exist
      fly = FlyApi.new(api: @api)
      assert_not fly.start_machine("asetasetaet")
    end

    def test_start_machine_that_exists
      fly = FlyApi.new(api: @api)
      assert fly.start_machine("abbabba")
    end

    def test_total_machines
      fly = FlyApi.new(api: @api)
      assert_equal 2, fly.total_machines
    end

    def test_get_machine_id
      fly = FlyApi.new(api: @api)
      assert_equal "aaazzzddd", fly.get_machine_id
    end

    def test_running_machines
      fly = FlyApi.new(api: @api)
      assert_equal 1, fly.running_machines
    end
  end
end
