module Twinfield
  class Customer
    def initialize(conf)
      @session = Twinfield::LoginSession.new(conf)
      @session.logon
      @company = conf.company

      Twinfield::Session.new(@session).select_company(@company)
    end

    # Find all customers
    def all
      Twinfield::Process.new(@session).
        request(:process_xml_document, get_dimension_xml(@company, 'DEB')).
        body[:process_xml_document_response][:process_xml_document_result][:dimensions][:dimension]
    end

    # Find customer by twinfield customer code
    def find_by_code(code)
      Twinfield::Process.new(@session).
        request(:process_xml_document, get_dimension_xml(@company, 'DEB', { code: code })).
        body[:process_xml_document_response][:process_xml_document_result][:dimension]
    end

    # Find customer by name
    def find_by_name(name)
      Twinfield::Finder.new(@session).
        search(Twinfield::FinderSearch.new('DIM', name, 0, 1, 0, { office: @company, dimtype: 'DEB'} )).
        body[:search_response][:data]
    end

    # Create new customer with xml
    def sync(xml)
      Twinfield::Process.new(@session).
        request(:process_xml_document, xml).
        body[:process_xml_document_response][:process_xml_document_result]
    end

    # The request for getting all elements in a Twinfield dimension
    def get_dimension_xml(office, dimtype, opts = {})
      xml = Builder::XmlMarkup.new

      xml = xml.read do
        xml.type('dimensions')
        xml.office(office)
        xml.dimtype(dimtype)
        xml.code(opts.fetch(:code){})
      end
    end
  end
end
