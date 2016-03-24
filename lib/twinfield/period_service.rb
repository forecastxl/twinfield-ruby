module Twinfield
  class PeriodService

    def initialize(configuration)
      @session = Twinfield::LoginSession.new(configuration)
      @session.logon
      setup(@session)
    end

    def setup(session)
      @client = Savon.client(
        wsdl: "#{session.cluster}#{Twinfield::WSDLS[:period_service]}",
        convert_request_keys_to: :camelcase,
        soap_header: {
          "Header" => {"SessionID" => session.session_id},
          :attributes! => {
            "Header" => {:xmlns => "http://www.twinfield.com/"}
          }
        }
      )
    end

    def get_periods(year)
      xml = %Q|
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:twin="http://www.twinfield.com/">
           <soapenv:Header>
              <twin:SessionId>#{@session.session_id}</twin:SessionId>
           </soapenv:Header>
           <soapenv:Body>
              <Query i:type="a:GetPeriods" xmlns="http://www.twinfield.com/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns:a="http://schemas.datacontract.org/2004/07/Twinfield.WebServices.PeriodService">
              <a:Year>#{year}</a:Year>
            </Query>
           </soapenv:Body>
        </soapenv:Envelope>
      |
      @client.call(:query, xml: xml)
    end
  end
end