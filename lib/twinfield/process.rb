module Twinfield
  class Process
    def initialize(session)
      @session = session
      setup session
    end

    def setup(session)
      @client = Savon.client(
        wsdl: "#{session.cluster}#{Twinfield::WSDLS[:process]}",
        convert_request_keys_to: :camelcase,
        soap_header: {
          'Header' => {'SessionID' => session.session_id},
          :attributes! => {
            'Header' => { xmlns: 'http://www.twinfield.com/'}
          }
        }
      )
    end

    def request(action, data)
      if actions.include?(action)
        if @session.connected?
          data = "<tns:xmlRequest>#{data}</tns:xmlRequest>"
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
