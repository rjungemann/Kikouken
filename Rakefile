require 'shellwords'

$project_name = "KikoukenExample"
$sdk_path = "/Applications/Adobe Flex Builder 3/sdks/4.0.0b1/".shellescape
$mxmlc_path = $sdk_path + "bin/mxmlc"
$bin_path = "bin/#{$project_name}.swf"

desc "Remove generated binary files."
task :clean do
  sh "rm #{$bin_path}" if File.exists? $bin_path
end

desc "Build a swf from source."
task :build do
  sh "#{$mxmlc_path} src/#{$project_name}.as -output #{$bin_path}"
end

desc "Run the swf in the browser"
task :run do
  sh "open bin/index.html"
end

desc "Clean, build, then run the project."
task :default => [:clean, :build, :run]