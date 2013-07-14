module Twinfield

  class Configuration
    attr_accessor :username
    attr_accessor :password
    attr_accessor :organisation

    def initialize(username, password, organisation)
      @username = username
      @password = password
      @organisation = organisation
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