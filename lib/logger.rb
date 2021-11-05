class Logger
  def self.log(msg)
    return unless ENV.fetch('verbose',nil) == 'true'

    puts msg
  end
end