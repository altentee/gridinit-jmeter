module Gridinit
  module Jmeter

    class DSL
      def xpath_extractor(params={}, &block)
        node = Gridinit::Jmeter::XpathExtractor.new(params)
        attach_node(node, &block)
      end
    end

    class XpathExtractor
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'XpathExtractor'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<XPathExtractor guiclass="XPathExtractorGui" testclass="XPathExtractor" testname="#{params[:name]}" enabled="true">
  <stringProp name="XPathExtractor.default"/>
  <stringProp name="XPathExtractor.refname"/>
  <stringProp name="XPathExtractor.xpathQuery"/>
  <boolProp name="XPathExtractor.validate">false</boolProp>
  <boolProp name="XPathExtractor.tolerant">false</boolProp>
  <boolProp name="XPathExtractor.namespace">false</boolProp>
</XPathExtractor>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
