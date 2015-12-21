module Twinfield

  class Invoice

    def initialize(conf)
      @session = Twinfield::LoginSession.new(conf)
      @session.logon
      @company = conf.company
    end

    def all
      Twinfield::Finder.new(@session).search(Twinfield::FinderSearch.new('IVT', '*', 0, 1, 0, { office: @company })).body[:search_response][:data]
    end

    def sync(xml)
      Twinfield::Process.new(@session).request(:process_xml_document, xml).body[:process_xml_document_response][:process_xml_document_result]
    end

    def find_by_invoice_number(invoicenumber)
      Twinfield::Process.new(@session).request(:process_xml_document, get_dimension_xml(@company, { invoicenumber: invoicenumber })).body[:process_xml_document_response][:process_xml_document_result]
    end

    def find_by_customer_code(customer)
      Twinfield::Finder.new(@session).search(Twinfield::FinderSearch.new('IVT', customer, 0, 1, 0, { office: @company })).body[:search_response][:data]
    end

    # Check if invoices are paid
    # TODO: Check if this works for partial payments
    def invoice_paid?(invoicenumber)
      # Find invoice
      invoice = Twinfield::Process.new(@session).request(:process_xml_document, get_dimension_xml(@company, { invoicenumber: invoicenumber })).body[:process_xml_document_response][:process_xml_document_result]

      # Find corresponding transaction
      transaction = find_transaction(invoice[:salesinvoice][:financials][:number])

      begin
        if transaction && transaction[:transaction][:lines][:line].first[:matchstatus].eql?('matched')
          true
        else
          false
        end
      rescue
        false
      end
    end

    def find_transaction(transaction_number)
      Twinfield::Process.new(@session).request(:process_xml_document, get_financial_xml(@company, { transaction_number: transaction_number })).body[:process_xml_document_response][:process_xml_document_result]
    end

    def find_all_unpaid_invoices
      Twinfield::Finder.new(@session).search(Twinfield::FinderSearch.new('IVT', '*', 0, 1, 0, { office: @company })).body[:search_response][:data][:items][:array_of_string]
    end


    def get_dimension_xml(office, opts = {})
      xml = Builder::XmlMarkup.new

      xml = xml.read do
        xml.type('salesinvoice')
        xml.office(office)
        xml.code('FACTUUR')
        xml.customer(opts.fetch(:customer){})
        xml.invoicenumber(opts.fetch(:invoicenumber){})
      end
    end

    def get_financial_xml(office, opts = {})
      xml = Builder::XmlMarkup.new

      xml = xml.read do
        xml.type('transaction')
        xml.office(office)
        xml.code('VRK')
        xml.number(opts.fetch(:transaction_number){})
      end
    end
  end
end