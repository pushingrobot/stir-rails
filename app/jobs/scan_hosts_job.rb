class ScanHostsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    Mapping.refresh
  end

end
