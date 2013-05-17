module Gridinit
  module Jmeter

    class DSL
      def http_cookie_manager(params={}, &block)
        node = Gridinit::Jmeter::HttpCookieManager.new(params)
        attach_node(node, &block)
      end
    end

    class HttpCookieManager
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'HttpCookieManager'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<CookieManager guiclass="CookiePanel" testclass="CookieManager" testname="#{params[:name]}" enabled="true">
  <collectionProp name="CookieManager.cookies"/>
  <boolProp name="CookieManager.clearEachIteration">false</boolProp>
  <stringProp name="CookieManager.policy">default</stringProp>
</CookieManager>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
