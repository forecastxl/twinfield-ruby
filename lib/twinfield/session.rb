module Twinfield

  # Session to be re-used on configuration basis
  class Session
    attr_accessor :configuration, :session_id, :cluster

    def initialize(configuration)
      @configuration = configuration
      
      @client = Savon.client(
        wsdl: Twinfield::WSDLS[:session],
        convert_request_keys_to: :camelcase
      )
    end

    def connected?
      !!@session_id && !!@cluster
    end

    def actions
      @client.operations
    end

    def status
      @message
    end

    def reconnect
      @session_id = nil
      @cluster = nil
      @message = nil
      logon
    end

    def logon
      if connected?
        return @message
      end

      data = @configuration.to_hash
      response = @client.call(:logon, message: data)

      if response.body[:logon_response][:logon_result] == "Ok"
        @session_id = response.header[:header][:session_id]
        @cluster = response.body[:logon_response][:cluster]
      else
        @message = "Error connecting to Twinfield"
        unless response.body[:fault].nil?
          # Error during logon
          @message = response.body[:fault][:faultstring].to_s
        end
        raise @message
      end
      @message = response.body[:logon_response][:logon_result]
    end

    def request(service, client, action, data)
      begin
        client.call(action.to_sym, message: data)
      rescue Savon::SOAPFault => e
        if (Regexp.new(Twinfield::ERRORS[103]) =~ e.message || 
            Regexp.new(Twinfield::ERRORS[168]) =~ e.message)
          # Invalid session or Connected from other client: reconnect
          reconnect
          client = service.setup(self)
          # Perform request once more
          client.call(action.to_sym, message: data)
        end
      end
    end

  end
end