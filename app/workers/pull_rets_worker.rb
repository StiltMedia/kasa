class PullRetsWorker

  include Sidekiq::Worker
  sidekiq_options queue: "rets", :retry => false, :backtrace => true

  def perform()
  end

end
