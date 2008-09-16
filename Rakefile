PACKAGE_VERSION = "1.0.0"
PACKAGE_NAME = "O3LayeredWindowForDelphi"
PACKAGE_DIR = "pkg"

# your setting
UPLOAD_DEST = "tobysoft@tobysoft.net:/home/tobysoft/www/tobysoft/archives/delphi/"
UPLOAD_URL_DIR = "http://tobysoft.net/archives/delphi/"

require 'rake/packagetask'

package_file_name = ""

# make .zip
Rake::PackageTask.new(PACKAGE_NAME, PACKAGE_VERSION) do |p|
  p.package_dir = PACKAGE_DIR
  p.package_files.include("**/*")
  p.package_files.exclude("**/*.dcu")
  p.package_files.exclude("**/*.dsk")
  p.package_files.exclude("**/*.local")
  p.package_files.exclude("**/*.identcache")
  p.package_files.exclude("pkg")
  p.package_files.exclude("**/__history")
  p.package_files.exclude("**/.git")
  p.package_files.exclude("**/.svn")
  p.need_zip = true
  package_file_name = p.package_dir_path + ".zip"
end


def set_clipboad(content)
  begin
    require 'win32/clipboard'

    Win32::Clipboard.set_data(content.to_s)
    puts "Set to clipboard."
  rescue LoadError
    puts "Could not set clipboard."
  end
end

def upload_file(src, dest)
  puts "uploading #{src} to #{dest}"
  sh "scp #{src} #{dest}"
  puts "uploaded!!"
  
  url = UPLOAD_URL_DIR + File.basename(src)
  puts "URL: #{url}"
  set_clipboad(url)
end

# upload to server
desc "upload package"
task :upload => :repackage do
  upload_file(package_file_name, UPLOAD_DEST)
end
