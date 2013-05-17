$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads count: 1 do
    visit name: 'Home Page', url: 'http://google.com/'
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
