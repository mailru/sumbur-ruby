if RUBY_ENGINE == 'ruby'
  require 'mkmf'
  create_makefile("native_sumbur")
else
  File.open(File.dirname(__FILE__) + "/Makefile", 'w') do |f|
    f.write("install:\n\t#nothing to build")
  end
end
