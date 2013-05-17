require "spec_helper"
require "pry-debugger"

describe "DSL" do

  describe 'aliased DSL methods' do
    it "test plan should respond to aliased methods" do
      test {}.should respond_to :variables
      test {}.should respond_to :defaults
      test {}.should respond_to :cookies
      test {}.should respond_to :cache
      test {}.should respond_to :header
      test {}.should respond_to :auth
    end
  end


  describe 'write to stdout and file' do
    it "should output a test plan to stdout" do
      $stdout.should_receive(:puts).with(/jmeterTestPlan/i)
      test do
      end.out
    end

    it "should output a test plan to jmx file" do
      file = mock('file')
      File.should_receive(:open).with("jmeter.jmx", "w").and_yield(file)
      file.should_receive(:write).with(/jmeterTestPlan/i)
      test do
      end.jmx
    end
  end


  describe 'user agent' do
    let(:doc) do
      test do
        with_user_agent :chrome
        threads
      end.to_doc
    end

    let(:fragment) { doc.search("//HeaderManager").first }

    it 'should match on user_agent' do
      fragment.search(".//stringProp[@name='Header.name']").text.should == 'User-Agent'
      fragment.search(".//stringProp[@name='Header.value']").text.should == 
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.46 Safari/536.5'
    end
  end


  describe 'thread groups' do
    let(:doc) do
      test do
        threads count: 101, continue_forever: true, duration: 69
      end.to_doc
    end

    let(:fragment) { doc.search("//ThreadGroup").first }

    it 'should match on num_threads' do
      fragment.search(".//stringProp[@name='ThreadGroup.num_threads']").text.should == '101'
    end

    it 'should match on continue_forever' do
      fragment.search(".//boolProp[@name='LoopController.continue_forever']").text.should == 'true'
    end

    it 'should match on loops' do
      fragment.search(".//stringProp[@name='LoopController.loops']").text.should == '-1'
    end

    it 'should match on duration' do
      fragment.search(".//stringProp[@name='ThreadGroup.duration']").text.should == '69'
    end
  end


  describe 'transaction controller' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_01", parent: true, include_timers: true
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//TransactionController").first }

    it 'should match on parent' do
      fragment.search(".//boolProp[@name='TransactionController.parent']").text.should == 'true'
    end

    it 'should match on includeTimers' do
      fragment.search(".//boolProp[@name='TransactionController.includeTimers']").text.should == 'true'
    end
  end


  describe 'visit' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_01", parent: true, include_timers: true do
            visit url: "/home?location=melbourne", always_encode: true
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//HTTPSamplerProxy").first }

    it 'should match on path' do
      fragment.search(".//stringProp[@name='HTTPSampler.path']").text.should == '/home'
    end

    it 'should match on always_encode' do
      fragment.search(".//boolProp[@name='HTTPArgument.always_encode']").text.should == 'true'
    end
  end


  describe 'https' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_01", parent: true, include_timers: true do
            visit url: "https://example.com"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//HTTPSamplerProxy").first }

    it 'should match on protocol' do
      fragment.search(".//stringProp[@name='HTTPSampler.protocol']").text.should == 'https'
    end
  end


  describe 'xhr' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_02", parent: true, include_timers: true do
            visit url: "/" do
              with_xhr
            end
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//HeaderManager").first }

    it 'should match on XHR' do
      fragment.search(".//stringProp[@name='Header.value']").text.should == 'XMLHttpRequest'
    end
  end


  describe 'submit' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_03", parent: true, include_timers: true do
            submit url: "/", fill_in: { username: 'tim', password: 'password' }
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//HTTPSamplerProxy").first }

    it 'should match on POST' do
      fragment.search(".//stringProp[@name='HTTPSampler.method']").text.should == 'POST'
    end
  end


  describe 'If' do
    let(:doc) do
      test do
        threads do
          If condition: '2>1' do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//IfController").first }

    it 'should match on If' do
      fragment.search(".//stringProp[@name='IfController.condition']").text.should == '2>1'
    end
  end


  describe 'exists' do
    let(:doc) do
      test do
        threads do
          exists 'apple' do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//IfController").first }

    it 'should match on exists' do
      fragment.search(".//stringProp[@name='IfController.condition']").text.should == "'${apple}'.length > 0"
    end
  end


  describe 'While' do
    let(:doc) do
      test do
        threads do
          While condition: 'true' do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//WhileController").first }

    it 'should match on While' do
      fragment.search(".//stringProp[@name='WhileController.condition']").text.should == 'true'
    end
  end


  describe 'Loop' do
    let(:doc) do
      test do
        threads do
          Loop count: 5 do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//LoopController").first }

    it 'should match on Loops' do
      fragment.search(".//stringProp[@name='LoopController.loops']").text.should == '5'
    end
  end


  describe 'Counter' do
    let(:doc) do
      test do
        threads do
          visit url: "/" do
            counter start: 1, per_user: true
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//CounterConfig").first }

    it 'should match on 5 Loops' do
      fragment.search(".//boolProp[@name='CounterConfig.per_user']").text.should == 'true'
    end
  end


  describe 'Switch' do
    let(:doc) do
      test do
        threads do
          Switch value: 'cat' do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//SwitchController").first }

    it 'should match on Switch' do
      fragment.search(".//stringProp[@name='SwitchController.value']").text.should == 'cat'
    end
  end

  describe 'regex extract' do
    let(:doc) do
      test do
        extract regex: 'pattern', name: 'my_regex'
      end.to_doc
    end

    let(:fragment) { doc.search("//RegexExtractor").first }

    it 'should match on refname' do
      # puts doc.to_xml indent: 2
      fragment.search(".//stringProp[@name='RegexExtractor.refname']").text.should == 'my_regex'
    end
  end


  describe 'xpath extract' do
    let(:doc) do
      test do
        extract xpath: '//node', name: 'my_xpath'
      end.to_doc
    end

    let(:fragment) { doc.search("//XPathExtractor").first }

    it 'should match on refname' do
      # puts doc.to_xml indent: 2
      fragment.search(".//stringProp[@name='XPathExtractor.refname']").text.should == 'my_xpath'
    end
  end


  describe 'Nested controllers' do
    let(:doc) do
      test do
        Simple name: 'node1.1' do
          Simple name: 'node2.1'
          Simple name: 'node2.2' do
            Simple name: 'node3.1'
          end
          Simple name: 'node2.3'
        end
        Simple name: 'node1.2'
      end.to_doc
    end

    let(:node1_1) { doc.search("//GenericController[@testname='node1.1']").first }
    let(:node1_2) { doc.search("//GenericController[@testname='node1.2']").first }

    let(:node2_1) { doc.search("//GenericController[@testname='node2.1']").first }
    let(:node2_2) { doc.search("//GenericController[@testname='node2.2']").first }
    let(:node2_3) { doc.search("//GenericController[@testname='node2.3']").first }

    let(:node3_1) { doc.search("//GenericController[@testname='node3.1']").first }

    it 'nodes should have hashTree as its parent' do
      [node1_1, node1_2, node2_1, node2_2, node2_3, node3_1].each do |node|
        node.parent.name.should == 'hashTree'
      end
    end

    describe 'node3_1' do
      it 'parent parent should be node2_2' do
        node3_1.parent.should == node2_2.next
      end
    end

    describe 'node1_2' do
      it 'previous non hashTree sibling is node1_1' do
        node1_2.previous.previous.should == node1_1
      end
    end

  end
end
