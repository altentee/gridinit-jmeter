module Gridinit
  module Jmeter

    class DSL
      def counter(params={}, &block)
        node = Gridinit::Jmeter::Counter.new(params)
        attach_node(node, &block)
      end
    end

    class Counter
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'Counter'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<CounterConfig guiclass="CounterConfigGui" testclass="CounterConfig" testname="#{params[:name]}" enabled="true">
  <stringProp name="CounterConfig.start"/>
  <stringProp name="CounterConfig.end"/>
  <stringProp name="CounterConfig.incr"/>
  <stringProp name="CounterConfig.name"/>
  <stringProp name="CounterConfig.format"/>
  <boolProp name="CounterConfig.per_user">false</boolProp>
</CounterConfig>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
