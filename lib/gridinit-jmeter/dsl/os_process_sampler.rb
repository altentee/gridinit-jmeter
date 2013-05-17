module Gridinit
  module Jmeter

    class DSL
      def os_process_sampler(params={}, &block)
        node = Gridinit::Jmeter::OsProcessSampler.new(params)
        attach_node(node, &block)
      end
    end

    class OsProcessSampler
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'OsProcessSampler'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<SystemSampler guiclass="SystemSamplerGui" testclass="SystemSampler" testname="#{params[:name]}" enabled="true">
  <boolProp name="SystemSampler.checkReturnCode">false</boolProp>
  <stringProp name="SystemSampler.expectedReturnCode">0</stringProp>
  <stringProp name="SystemSampler.command"/>
  <elementProp name="SystemSampler.arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{params[:name]}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <elementProp name="SystemSampler.environment" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{params[:name]}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <stringProp name="SystemSampler.directory"/>
</SystemSampler>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
