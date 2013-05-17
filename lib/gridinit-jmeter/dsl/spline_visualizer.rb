module Gridinit
  module Jmeter

    class DSL
      def spline_visualizer(params={}, &block)
        node = Gridinit::Jmeter::SplineVisualizer.new(params)
        attach_node(node, &block)
      end
    end

    class SplineVisualizer
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ResultCollector guiclass="SplineVisualizer" testclass="ResultCollector" testname="#{name}" enabled="true">
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
      <message>false</message>
      <threadName>true</threadName>
      <dataType>false</dataType>
      <encoding>false</encoding>
      <assertions>false</assertions>
      <subresults>false</subresults>
      <responseData>false</responseData>
      <samplerData>false</samplerData>
      <xml>false</xml>
      <fieldNames>false</fieldNames>
      <responseHeaders>false</responseHeaders>
      <requestHeaders>false</requestHeaders>
      <responseDataOnError>false</responseDataOnError>
      <saveAssertionResultsFailureMessage>false</saveAssertionResultsFailureMessage>
      <assertionsResultsToSave>0</assertionsResultsToSave>
      <bytes>true</bytes>
      <threadCounts>true</threadCounts>
      <sampleCount>true</sampleCount>
    </value>
  </objProp>
  <stringProp name="filename"/>
</ResultCollector>)
        EOS
        update params
      end
    end

  end
end