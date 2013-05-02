module Gridinit
  module Jmeter

    class DSL
      def ldap_extended_request_defaults(params={}, &block)
        node = Gridinit::Jmeter::LdapExtendedRequestDefaults.new(params)
        attach_node(node, &block)
      end
    end

    class LdapExtendedRequestDefaults
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConfigTestElement guiclass="LdapExtConfigGui" testclass="ConfigTestElement" testname="#{name}" enabled="true">
  <stringProp name="servername"/>
  <stringProp name="port"/>
  <stringProp name="rootdn"/>
  <stringProp name="scope">2</stringProp>
  <stringProp name="countlimit"/>
  <stringProp name="timelimit"/>
  <stringProp name="attributes"/>
  <stringProp name="return_object">false</stringProp>
  <stringProp name="deref_aliases">false</stringProp>
  <stringProp name="connection_timeout"/>
  <stringProp name="parseflag">false</stringProp>
  <stringProp name="secure">false</stringProp>
  <stringProp name="user_dn"/>
  <stringProp name="user_pw"/>
  <stringProp name="comparedn"/>
  <stringProp name="comparefilt"/>
  <stringProp name="modddn"/>
  <stringProp name="newdn"/>
</ConfigTestElement>)
        EOS
        update params
      end
    end

  end
end
