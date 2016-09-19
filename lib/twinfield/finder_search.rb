module Twinfield
  class FinderSearch
    # All finder types
    TYPES = %w(ART ASM BDS CDA COL CTR CUR DIM DMT DVT FLT FMT GRP HIE HND INV IVT MAT OFF OFG OIC
               PAY PTY REP REW RMD ROL SMP SPM SPP TEQ TRS TRT USR VAT VGM XLT)

    OPTIONS = {
      '' => { 'office' => nil },
      'ART' => { 'vat' => ['inclusive', 'exclusive'] },
      'CTR' => { 'ctrtype' => ['vatnl'] }
    }

    attr_accessor :type, :pattern, :fields, :first_row, :max_rows, :options

    def initialize(type, pattern, fields, first_row = 1, max_rows = 0, options = {})
      @type = type
      @pattern = pattern
      @fields = fields
      @first_row = first_row
      @max_rows = max_rows
      @options = options
    end

    def options_to_xml_string(options)
      @options.map do |k, v|
        text = Hash === v ? options_to_xml_string(v) : v
        # "<%s>%s</%s>" % [k, text, k]
        "<tns:ArrayOfString><tns:string>%s</tns:string><tns:string>%s</tns:string></tns:ArrayOfString>" % [k, text]
      end.join
    end

    # The payload for the SOAP call
    def to_xml
      return "unknown type #{@type}" unless TYPES.include? @type

      payload = "<tns:type>#{@type}</tns:type>\
<tns:pattern>#{@pattern}</tns:pattern>\
<tns:fields>#{@fields}</tns:fields>\
<tns:firstRow>#{@first_row}</tns:firstRow>\
<tns:maxRows>#{@max_rows}</tns:maxRows>"

      unless @options.empty?
        payload += "<tns:options>\
#{options_to_xml_string(@options)}\
</tns:options>"
      end

      payload
    end
  end
end
