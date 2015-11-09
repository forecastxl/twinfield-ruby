module Twinfield

  class Invoice

    def initialize(conf)
      @session = Twinfield::LoginSession.new(conf)
      @session.logon
      @company = conf.company
    end
    # Klant moet als debiteur aangemaakt worden

    # Factuur aanmaken, finalizen

    # Onbetaalde facturen ophalen
    #  - Teruggeroepen incasso's checken ?

    # App bepaald factuurnr -> ForecastxlAccounts
    # Prefix ?

    # Creditfacturen
    def all
      Twinfield::Finder.new(@session).search(Twinfield::FinderSearch.new('IVT', '*', 0, 1, 0)).body[:search_response][:data]
    end

    def create(xml)
      Twinfield::Process.new(@session).request(:process_xml_document, xml).body[:process_xml_document_response][:process_xml_document_result]
    end

    def update(xml)
      Twinfield::Process.new(@session).request(:process_xml_document, xml).body[:process_xml_document_response][:process_xml_document_result]
    end


    def create_from_forecastxl_invoice(invoice, reseller = nil)

      #raise "Er bestaat al een factuur in Twinfield met code: #{invoice.invoice_nr}" if invoice.invoice_nr.present?

      # xml = Builder::XmlMarkup.new

      # xml = xml.salesinvoice(:result=>"1") do
      #   xml.header do
      #     xml.office(TWINFIELD_COMPANY)
      #     xml.invoicetype('FACTUUR')
      #     xml.invoicedate(invoice.created_at.strftime('%Y%m%d'))
      #     xml.duedate((invoice.created_at + 14.days).strftime('%Y%m%d'))
      #     if reseller
      #       xml.customer(invoice.reseller.twinfield_customer_code)
      #     else
      #       xml.customer(invoice.account.twinfield_customer_code)
      #     end
      #     xml.period(invoice.created_at.strftime('%Y/%m'))
      #     xml.currency('EUR')
      #     xml.status('final')
      #     xml.paymentmethod('bank')
      #     xml.invoiceaddressnumber('1')
      #     xml.deliveraddressnumber('1')
      #     xml.headertext()
      #     xml.footertext()
      #   end
      #   xml.lines do
      #     invoice.invoice_lines.each_with_index do |invoice_line, index|
      #       xml.line(id: index) do
      #         xml.article('0')
      #         xml.subarticle(001)
      #         xml.quantity(invoice_line.quantity)
      #         #xml.units(invoice_line.quantity)
      #         xml.allowdiscountorpremium(false)
      #         xml.performancedate()
      #         xml.performancetype()
      #         xml.description(invoice_line.name)
      #         #xml.freetext1(invoice_line.name)
      #         #xml.unitspriceinc(invoice_line.amount_net)
      #         xml.unitspriceexcl(invoice_line.amount_net)
      #         xml.vatcode('VH2')

      #         if reseller
      #           xml.dim1(8500)
      #         else
      #           xml.dim1(8000)
      #         end
      #       end
      #     end
      #   end
      # end
      Twinfield::Process.new(@session).request(:process_xml_document, xml).body[:process_xml_document_response][:process_xml_document_result]


      #invoice_number = response[:salesinvoice][:header][:invoicenumber]


      # # TODO FIXME: What to do when there is a sync error ? Update invoice_nr or not ?
      # if invoice_number.to_i != invoice.invoice_nr.to_i
      #   #
      #   # Exclude other ForecastXL invoices
      #   #
      #   unless invoice_number.to_s.starts_with?("2014")
      #     NewRelic::Agent.notice_error("Twinfield invoice_nr mismatch!", custom_params: { invoice: invoice.inspect, invoice_nr: invoice.invoice_nr, twinfield_invoice_nr: invoice_number})
      #   end
      #   #invoice.update_attribute(:invoice_nr, invoice_number)
      # else
      #   p "INVOICE SYNC SUCCESS!: #{invoice.inspect}"
      # end
      # #invoice.update_attribute(:invoice_nr, invoice_number) if invoice_number
    end


    def find_by_invoice_number(invoicenumber)
      Twinfield::Process.new(@session).request(:process_xml_document, get_dimension_xml(@company, { invoicenumber: invoicenumber })).body[:process_xml_document_response][:process_xml_document_result]
      #Twinfield::Finder.new(@session).search(Twinfield::FinderSearch.new('IVT', invoice_number, 0, 1, 0)).body[:search_response][:data]
    end

    def find_by_customer_code(customer)
      #Twinfield::Process.new(@session).request(:process_xml_document, get_dimension_xml('FM02A', { customer: customer })).body[:process_xml_document_response][:process_xml_document_result]
      Twinfield::Finder.new(@session).search(Twinfield::FinderSearch.new('IVT', customer, 0, 1, 0)).body[:search_response][:data]
    end


    # Check if invoices are paid
    # TODO: Check if this works for partial payments
    def invoice_paid?(invoicenumber)
      # Find invoice
      invoice = Twinfield::Process.new(@session).request(:process_xml_document, get_dimension_xml(@company, { invoicenumber: invoicenumber })).body[:process_xml_document_response][:process_xml_document_result]

      p "INVOICE : #{invoice}"
      # Find corresponding transaction
      transaction = Twinfield::Invoice.new.find_transaction(invoice[:salesinvoice][:financials][:number])

      # Check matchstatus of transaction
      p transaction


      # TODO: Check overpaid :matchstatus=>"available", :matchlevel=>"2"
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
      Twinfield::Finder.new(@session).search(Twinfield::FinderSearch.new('IVT', '*', 0, 1, 0)).body[:search_response][:data][:items][:array_of_string]
      # [{:string=>["1", "38.10", "1082", "Test re\\atie's v00r $pec|al character\"s", "C"]},
      # {:string=>["100", "5541.56", "1087", "L Nutma", "C"]},
      # {:string=>["101", "5541.80", "1087", "L Nutma", "C"]}]
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