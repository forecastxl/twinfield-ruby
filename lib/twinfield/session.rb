module Twinfield
  class Session

    def initialize(session)
      @session = session
      setup session
    end

    def setup(session)
      @client = Savon.client(
        wsdl: "#{session.cluster}#{Twinfield::WSDLS[:session]}",
        convert_request_keys_to: :camelcase,
        soap_header: {
          'Header' => { 'SessionID' => session.session_id },
          :attributes! => {
            'Header' => { xmlns: 'http://www.twinfield.com/'}
          }
        }
      )
    end

    def select_company(company_code)
      request(:select_company, "<tns:company>#{company_code}</tns:company>")
      last_response.body[:select_company_response][:select_company_result]
    end

    def request(action, data)
      if actions.include?(action)
        if @session.connected?
          @response = @session.request(self, @client, action, data)
        else
          'Session connection error'
        end
      else
        'Action not found'
      end
    end

    def last_response
      @response
    end

    def actions
      @client.operations
    end
  end
end
