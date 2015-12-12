namespace :scrape do
  desc "Starts scraping all product pages for price changes."
  task start: :environment do
    log = ActiveSupport::Logger.new("log/scraper.log");

    start_time = Time.now
    log.info "Task started at #{start_time}."

    # fetch over all product pages and scrape each
    ProductPage.find_each do |p|
      log.info "Loading page <id:#{p.id} <url:#{p.url}>..."

      begin
        Scraper::fetch(p)
      rescue Exception => e
        log.error "Failed! Exception reason: #{e.message}."
        next
      end
    end

    end_time = Time.now
    duration = end_time - start_time
    log.info "Task finished at #{end_time} and lasted #{duration} seconds."
    log.close
  end
end
