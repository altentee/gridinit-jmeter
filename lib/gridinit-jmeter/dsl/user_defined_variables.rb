module Gridinit
  module Jmeter

    class DSL
      def user_defined_variables(params={}, &block)
        node = Gridinit::Jmeter::UserDefinedVariables.new(params)
        attach_node(node, &block)
      end
    end

    class UserDefinedVariables
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'UserDefinedVariables'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<Arguments guiclass="ArgumentsPanel" testclass="Arguments" testname="#{params[:name]}" enabled="true">
  <collectionProp name="Arguments.arguments">
    <elementProp name="testguid" elementType="Argument">
      <stringProp name="Argument.name"/>
      <stringProp name="Argument.value"/>
      <stringProp name="Argument.metadata">=</stringProp>
    </elementProp>
  </collectionProp>
  <stringProp name="TestPlan.comments"/>
</Arguments>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
