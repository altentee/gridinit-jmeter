module Gridinit
  module Jmeter

    class DSL
      def keystore_configuration(params={}, &block)
        node = Gridinit::Jmeter::KeystoreConfiguration.new(params)
        attach_node(node, &block)
      end
    end

    class KeystoreConfiguration
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'KeystoreConfiguration'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<KeystoreConfig guiclass="TestBeanGUI" testclass="KeystoreConfig" testname="#{params[:name]}" enabled="true">
  <stringProp name="endIndex"/>
  <stringProp name="preload">True</stringProp>
  <stringProp name="startIndex"/>
</KeystoreConfig>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
