Pod::Spec.new do |s|
  s.name         = "STPathTextField"
  s.version      = "1.0.0"
  s.summary      = "NSTextField subclass for receiving and displaying a file system path, supporting path validation and autocompletion."
  s.description  = "NSTextField subclass for receiving and displaying a file system path, supporting path validation and autocompletion, expanding tilde in path etc."
  s.homepage     = "http://github.com/sveinbjornt/STPathTextField"
  s.license      = { :type => 'BSD' }
  s.author       = { "Sveinbjorn Thordarson" => "sveinbjornt@gmail.com" }
  s.osx.deployment_target = "10.6"
  s.source       = { :git => "https://github.com/sveinbjornt/STPathTextField.git", :tag => "1.0.1" }
  s.source_files = "STPathTextField.{h,m}"
  s.exclude_files = "STPathTextFieldExample"
  s.public_header_files = "STPathTextField.h"
  s.requires_arc = false
end
