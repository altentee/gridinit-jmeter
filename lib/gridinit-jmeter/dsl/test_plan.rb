module Gridinit
  module Jmeter

    class DSL
      def test_plan(params={}, &block)
        node = Gridinit::Jmeter::TestPlan.new(params)
        attach_node(node, &block)
      end
    end

    class TestPlan
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'TestPlan'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="#{params[:name]}" enabled="true">
  <stringProp name="TestPlan.comments"/>
  <boolProp name="TestPlan.functional_mode">false</boolProp>
  <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
  <elementProp name="TestPlan.user_defined_variables" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{params[:name]}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <stringProp name="TestPlan.user_define_classpath"/>
</TestPlan>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
