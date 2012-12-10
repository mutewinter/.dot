# Rake tasks for my dot files

desc 'Create symlinks for files beginning with _ in home directory'
task :link do
  begin
    dot_files = Dir['_*']
    dot_files.each do |file|
      dot_file ="~/.#{file.gsub(/^_/,'')}"
      if File.exists? dot_file
        File.symlink("#{Dir.pwd}/#{file}", File.expand_path(dot_file))
        puts "Made symlink in home for #{file}"
      else
        puts "#{dot_file} already exists, skipping"
      end
    end
  rescue NotImplementedError
    puts "File.symlink not supported, you must do it manually."
    if RUBY_PLATFORM.downcase =~ /(mingw|win)(32|64)/
      puts 'Windows 7 use mklink, e.g.'
      puts '  mklink .dot_file dot_files\_dot_file'
    end
  end
end
