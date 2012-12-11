# Rake tasks for my dot files

ZSH_PLUGINS = File.expand_path File.join %w{~ .oh-my-zsh custom plugins}

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

desc 'Create symlinks for all zsh plugins'
task :zsh_plugins do
  if File.exists? 'zsh'
    # Make the plugins folder if it isn't there.
    puts ZSH_PLUGINS
    Dir.mkdir ZSH_PLUGINS unless File.exists? ZSH_PLUGINS

    Dir['zsh/*'].select { |d| File.directory? d }.each do |directory|
      directory = File.expand_path directory
      destination = File.join ZSH_PLUGINS, File.basename(directory)
      if !File.exists?(destination)
        File.symlink("#{directory}", destination)
        puts "Created symlink for zsh plugin #{directory}"
      else
        puts "#{directory} zsh plugin already exists, skipping"
      end
    end
  end
end
