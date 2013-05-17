module Gridinit
  module Jmeter

    class DSL
      def xpath_assertion(params={}, &block)
        node = Gridinit::Jmeter::XpathAssertion.new(params)
        attach_node(node, &block)
      end
    end

    class XpathAssertion
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'XpathAssertion'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<XPathAssertion guiclass="XPathAssertionGui" testclass="XPathAssertion" testname="#{params[:name]}" enabled="true">
  <boolProp name="XPath.negate">false</boolProp>
  <stringProp name="XPath.xpath">/</stringProp>
  <boolProp name="XPath.validate">false</boolProp>
  <boolProp name="XPath.whitespace">false</boolProp>
  <boolProp name="XPath.tolerant">false</boolProp>
  <boolProp name="XPath.namespace">false</boolProp>
</XPathAssertion>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
