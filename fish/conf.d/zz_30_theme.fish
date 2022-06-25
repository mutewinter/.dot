set -g theme_display_node yes
set -g theme_newline_cursor yes


function bobthefish_colors -S -d 'Define a custom bobthefish color scheme'

  # Terminal color reference
  # black, red, green, yellow, blue, magenta, cyan, white
  # brblack, brred, brgreen, bryellow, brblue, brmagenta, brcyan, brwhite

  set -x color_repo_dirty                 yellow black
  set -x color_repo_staged                bryellow black
  set -x color_repo                       green black     --bold
  set -x color_vi_mode_default            blue black      --bold
  set -x color_vi_mode_insert             green black     --bold
  set -x color_vi_mode_visual             magenta black   --bold
  set -x color_node                       brgreen black   --bold

  # Default theme for reference
  # set -x color_initial_segment_exit     #ffffff #ce000f --bold
  # set -x color_initial_segment_private  #ffffff #255e87
  # set -x color_initial_segment_su       #ffffff #189303 --bold
  # set -x color_initial_segment_jobs     #ffffff #255e87 --bold
  # set -x color_path                     #333333 #999999
  # set -x color_path_basename            #333333 #ffffff --bold
  # set -x color_path_nowrite             #660000 #cc9999
  # set -x color_path_nowrite_basename    #660000 #cc9999 --bold
  # set -x color_repo                     #addc10 #0c4801
  # set -x color_repo_work_tree           #333333 #ffffff --bold
  # set -x color_repo_dirty               #ce000f #ffffff
  # set -x color_repo_staged              #f6b117 #3a2a03
  # set -x color_vi_mode_default          #999999 #333333 --bold
  # set -x color_vi_mode_insert           #189303 #333333 --bold
  # set -x color_vi_mode_visual           #f6b117 #3a2a03 --bold
  # set -x color_vagrant                  #48b4fb #ffffff --bold
  # set -x color_aws_vault
  # set -x color_aws_vault_expired
  # set -x color_username                 #cccccc #255e87 --bold
  # set -x color_hostname                 #cccccc #255e87
  # set -x color_rvm                      #af0000 #cccccc --bold
  # set -x color_virtualfish              #005faf #cccccc --bold
  # set -x color_virtualgo                #005faf #cccccc --bold
  # set -x color_desk                     #005faf #cccccc --bold
  # set -x color_nix                      #005faf #cccccc --bold
end
