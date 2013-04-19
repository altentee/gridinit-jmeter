module Gridinit
  module Jmeter

    class SimpleDataWriter
      attr_accessor :doc
      include Helper
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <ResultCollector guiclass="SimpleDataWriter" testclass="ResultCollector" testname="#{name}" enabled="#{enabled(params)}">
            <boolProp name="ResultCollector.error_logging">false</boolProp>
            <objProp>
              <name>saveConfig</name>
              <value class="SampleSaveConfiguration">
                <time>true</time>
                <latency>true</latency>
                <timestamp>true</timestamp>
                <success>true</success>
                <label>true</label>
                <code>true</code>
                <message>true</message>
                <threadName>true</threadName>
                <dataType>false</dataType>
                <encoding>false</encoding>
                <assertions>false</assertions>
                <subresults>true</subresults>
                <responseData>false</responseData>
                <samplerData>false</samplerData>
                <xml>true</xml>
                <fieldNames>false</fieldNames>
                <responseHeaders>true</responseHeaders>
                <requestHeaders>false</requestHeaders>
                <responseDataOnError>false</responseDataOnError>
                <saveAssertionResultsFailureMessage>false</saveAssertionResultsFailureMessage>
                <assertionsResultsToSave>0</assertionsResultsToSave>
                <bytes>true</bytes>
                <url>true</url>
                <hostname>true</hostname>
                <threadCounts>true</threadCounts>
                <sampleCount>true</sampleCount>
                <idleTime>true</idleTime>
              </value>
            </objProp>
            <stringProp name="filename">/var/log/gridnode/stderr.log</stringProp>
          </ResultCollector>
        EOF
        update params
      end
    end  

  end
end
