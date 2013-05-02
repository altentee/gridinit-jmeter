module Gridinit
  module Jmeter

    class DSL
      def result_status_action_handler(params={}, &block)
        node = Gridinit::Jmeter::ResultStatusActionHandler.new(params)
        attach_node(node, &block)
      end
    end

    class ResultStatusActionHandler
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ResultAction guiclass="ResultActionGui" testclass="ResultAction" testname="#{name}" enabled="true">
  <intProp name="OnError.action">0</intProp>
</ResultAction>)
        EOS
        update params
      end
    end

  end
end
