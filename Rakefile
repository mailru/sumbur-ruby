#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'
Rake::TestTask.new do |i|
  i.libs << 'ext'
  i.options = '-v'
  i.verbose = true
end

if RUBY_ENGINE=='jruby'
  task 'jbuild' do
    jruby_home = RbConfig::CONFIG['prefix']
    puts %x{javac -Xlint:deprecation -Xlint:unchecked -classpath #{jruby_home}/lib/jruby.jar ext/java/sumbur/*.java}
    Dir.chdir('ext/java') do
      puts %x{jar cf sumbur.jar ./sumbur/*.class}
    end
    FileUtils.mv 'ext/java/sumbur.jar', 'lib/sumbur/sumbur.jar'
  end
end
