module Gridinit
  module Jmeter

    class DSL
      def bsf_assertion(params={}, &block)
        node = Gridinit::Jmeter::BsfAssertion.new(params)
        attach_node(node, &block)
      end
    end

    class BsfAssertion
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'BsfAssertion'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFAssertion guiclass="TestBeanGUI" testclass="BSFAssertion" testname="#{params[:name]}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFAssertion>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
