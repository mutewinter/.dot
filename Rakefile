# Rake tasks for my dot files

ZSH_PLUGINS = File.expand_path File.join %w{~ .oh-my-zsh custom plugins}
ZSH_THEMES = File.expand_path File.join %w{~ .oh-my-zsh custom themes}

desc 'Create symlinks for files beginning with _ in home directory'
task :link do
  begin
    dot_files = Dir['_*']
    dot_files.each do |file|
      source_file = File.expand_path file
      target_file = File.expand_path "~/.#{file.gsub(/^_/,'')}"

      if not File.exists? target_file
        File.symlink(source_file, target_file)
        puts "Made symlink in home for #{File.basename target_file}"
      else
        puts "#{target_file} already exists, skipping"
      end
    end

  rescue NotImplementedError
    puts "File.symlink not supported, you must do it manually."
    if RUBY_PLATFORM.downcase =~ /(mingw|win)(32|64)/
      puts 'Windows 7 use mklink, e.g.'
      puts '  mklink .dot_file .dot\_dot_file'
    end
  end
end

namespace :zsh do
  desc 'Create symlink for all custom zsh files'
  task :all => [:plugins, :themes]

  desc 'Create symlink for custom zsh plugins'
  task :plugins do
    if File.exists? ZSH_PLUGINS
      puts "#{ZSH_PLUGINS} zsh plugin already exists, skipping"
    else
      puts 'Making symlink for custom zsh plugins'
      File.symlink(File.expand_path('zsh/plugins'), ZSH_PLUGINS)
    end
  end

  desc 'Create symlink for custom zsh themes'
  task :themes do
    if File.exists? ZSH_THEMES
      puts "#{ZSH_THEMES} zsh themes already exists, skipping"
    else
      puts 'Making symlink for custom zsh themes'
      File.symlink(File.expand_path('zsh/themes'), ZSH_THEMES)
    end
  end
end
