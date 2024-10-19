# Rake tasks for my dot files

ZSH_PLUGINS = File.expand_path File.join %w{~ .oh-my-zsh custom plugins}
ZSH_THEMES = File.expand_path File.join %w{~ .oh-my-zsh custom themes}
KARABINER = File.expand_path File.join %w{~ .config karabiner karabiner.json}
LAZYGIT = File.expand_path File.join %w{~ Library Application\ Support lazygit config.yml}
CURSOR = File.expand_path File.join %w{~ Library Application\ Support Cursor User}
FISH = File.expand_path File.join %w{~ .config fish}

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

desc 'Create symlink for Karabiner'
task :karabiner do
  if File.exists? KARABINER
    puts "#{KARABINER} already exists, skipping"
  else
    puts 'Making symlink for karabiner'
    File.symlink(File.expand_path('karabiner/karabiner.json'), KARABINER)
  end
end

desc 'Create symlink for Lazygit'
task :lazygit do
  if File.exists? LAZYGIT
    puts "#{LAZYGIT} already exists, skipping"
  else
    # Get folder for lazygit config file
    lazygit_folder = File.dirname LAZYGIT
    # Check if lazygit directory exists and if not, create it
    if not File.exists? lazygit_folder
      puts "Making directory #{lazygit_folder}"
      Dir.mkdir lazygit_folder
    end
    puts 'Making symlink for lazygit'
    File.symlink(File.expand_path('lazygit/config.yml'), LAZYGIT)
  end
end

desc 'Create symlink for Fish'
task :fish do
  if File.exists? FISH
    puts "#{FISH} already exists, skipping"
  else
    puts 'Making symlink for fish'
    File.symlink(File.expand_path('fish'), FISH)
  end
end

cursor_files_and_folders = %w{keybindings.json settings.json snippets}

desc 'Create symlink for Cursor'
task :cursor do
  # Get folder for cursor config file
  cursor_folder = File.dirname CURSOR
  # Check if cursor directory exists and if not, create it
  if not File.exists? cursor_folder
    puts "Making directory #{cursor_folder}"
    Dir.mkdir cursor_folder
  end
  puts 'Making symlink for cursor'
  for file_or_folder_name in cursor_files_and_folders
    file_or_folder = File.expand_path("cursor/#{file_or_folder_name}")
    if File.exists? File.join(CURSOR, file_or_folder_name)
      puts "#{file_or_folder} already exists, skipping"
    else
      File.symlink(file_or_folder, File.join(CURSOR, file_or_folder_name))
      puts "Made symlink in cursor for #{file_or_folder_name}"
    end
  end
end
