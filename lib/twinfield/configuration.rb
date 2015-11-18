module Twinfield

  class Configuration
    attr_accessor :username
    attr_accessor :password
    attr_accessor :organisation
    attr_accessor :company

    def initialize(username, password, organisation, company = nil)
      @username = username
      @password = password
      @organisation = organisation
      @company = company
    end

    def to_hash
      {
        "user" => @username,
        "password" => @password,
        "organisation" => @organisation
      }
    end
  end
end
