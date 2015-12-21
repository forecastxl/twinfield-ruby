module Twinfield
  class Finder

    ERRORS = {
      1 => "You don't have access to office {office_code}",
      2 => "Option {option_name} is not allowed",
      3 => "Options {options_name} must be 0 or 1",
      4 => "Options {options_name} must be an integer value",
      5 => "Options {options_name} must be an decimal value",
      6 => "Options {options_name} must be one of {list_of_values}",
      7 => "Options {options_name} must be between {lower_value} and {upper_value}"
      # TODO
    }

    def initialize(session)
      @session = session
      setup session
    end

    def setup(session)
      @client = Savon.client(
        wsdl: "#{session.cluster}#{Twinfield::WSDLS[:finder]}",
        convert_request_keys_to: :camelcase,
        soap_header: {
          "Header" => {"SessionID" => session.session_id},
          :attributes! => {
            "Header" => {:xmlns => "http://www.twinfield.com/"}
          }
        }
      )
    end

    # Main action, call with FinderSearch object
    def search(search_object)
      request(:search, search_object.to_xml)
    end

    def request(action, data)
      if actions.include?(action)
        if @session.connected?
          @response = @session.request(self, @client, action, data)
        else
          "Session connection error"
        end
      else
        "Action not found"
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