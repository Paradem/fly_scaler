class Scaler
  attr_reader :fly

  def initialize(fly: nil)
    @fly = fly || FlyApi.new
  end

  def scaleable?
    Rails.respond_to?(:env) && (Rails.env.production? || Rails.env.staging?)
  end

  def up
    if fly.running_machines < fly.total_machines
      fly.start_machine(fly.get_machine_id)
    end
  end
end
