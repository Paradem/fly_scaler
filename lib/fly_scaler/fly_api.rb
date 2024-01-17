module FlyScaler
  class FlyApi
    Machine = Data.define(:id, :state, :group)

    # :nocov:
    class Api
      include HTTParty
      base_uri ENV["FLY_API_HOSTNAME"]

      def headers
        {
          "Authorization" => "Bearer #{ENV["FLY_API_TOKEN"]}",
          "Content-Type" => "application/json"
        }
      end

      def machines
        results = self.class.get("/v1/apps/#{ENV["FLY_APP_NAME"]}/machines", headers:)

        results.map do |m|
          Machine.new(m["id"],
            m["state"],
            m.dig("config", "metadata", "fly_process_group"))
        end
      end

      def start_machine(machine)
        self.class.post("/v1/apps/#{ENV["FLY_APP_NAME"]}/machines/#{machine}/start", headers:)
        true
      end
    end
    # :nocov:

    def initialize(api: nil)
      @api = api || Api.new
    end

    def job_machines
      @api.machines.select do |m|
        m.group == "job"
      end
    end

    def start_machine(machine)
      return false unless job_machines.map(&:id).include?(machine)
      @api.start_machine(machine)
    end

    def total_machines
      job_machines.count
    end

    def running_machines
      job_machines.count { |m| m.state == "started" }
    end

    def get_machine_id
      job_machines.select { |m| m.state == "stopped" }.sample&.id
    end
  end
end
