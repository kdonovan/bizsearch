class LibraryAquariumJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    url = 'http://www.libraryinsight.net/mpCalendar.asp?t=2644944&jx=y9p&pInstitution=Seattle%20Aquarium&mps=2160'
    response = HTTParty.get(url)
    doc = Nokogiri::HTML(response.body)
    if doc.css('.tablemonth tr:not(.days) td:not(.used):not(.days)').length > 0
      `open #{url}`
      raise "Do something here to report that we may be able to actually make a reservation"
    end
  end

end
