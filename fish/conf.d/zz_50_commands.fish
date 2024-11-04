# Usage: mirror_obsidian_config <source_dir>

# Shift the arguments to get the list of files
set obsidian_files \
  .obsidian.vimrc \
  .obsidian/snippets/custom.css \
  .obsidian/app.json \
  .obsidian/appearance.json \
  .obsidian/command-palette.json \
  .obsidian/community-plugins.json \
  .obsidian/core-plugins.json \
  .obsidian/hotkeys.json

function mirror_obsidian_config
  # Get source and target directories from the arguments
  set src_dir $argv[1]

  # If src_dir is not provided, exit
  if test -z $src_dir
    echo "Usage: mirror_obsidian_config <source_dir>"
    return 1
  end

  # Strip extra slashes from the end of the source directory
  set src_dir (string match -r '(.*)/' $src_dir)[2]

  set target_dir ~/.dot/obsidian

  # Loop through each file path
  for file in $obsidian_files
    # Define the source file path
    set src_file "$src_dir/$file"

    # Define the target file path (preserving folder structure)
    set target_file "$target_dir/$file"

    # Ensure the target directory structure exists
    mkdir -p (dirname "$target_file")

    # Copy the file
    cp "$src_file" "$target_file"
    echo "Copied $file"
  end
end
