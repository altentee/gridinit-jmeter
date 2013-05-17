module Gridinit
  module Jmeter

    class DSL
      def ftp_request_defaults(params={}, &block)
        node = Gridinit::Jmeter::FtpRequestDefaults.new(params)
        attach_node(node, &block)
      end
    end

    class FtpRequestDefaults
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'FtpRequestDefaults'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConfigTestElement guiclass="FtpConfigGui" testclass="ConfigTestElement" testname="#{params[:name]}" enabled="true">
  <stringProp name="FTPSampler.server"/>
  <stringProp name="FTPSampler.port"/>
  <stringProp name="FTPSampler.filename"/>
  <stringProp name="FTPSampler.localfilename"/>
  <stringProp name="FTPSampler.inputdata"/>
  <boolProp name="FTPSampler.binarymode">false</boolProp>
  <boolProp name="FTPSampler.saveresponse">false</boolProp>
  <boolProp name="FTPSampler.upload">false</boolProp>
</ConfigTestElement>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
