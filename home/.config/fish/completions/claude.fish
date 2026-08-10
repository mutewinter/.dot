# fish completion for claude (Claude Code)
#
# Maintained by hand: the CLI ships no completion generator. Refresh the option
# lists from `claude --help` and `claude <command> --help` after an upgrade.

set -l cmds agents auth auto-mode doctor gateway import install mcp plugin plugins project setup-token ultrareview update upgrade
set -l auth_subs login logout status help
set -l automode_subs config critique defaults reset help
set -l mcp_subs add add-from-claude-desktop add-json get list login logout remove reset-project-choices serve help
set -l plugin_subs details disable enable eval init new install i list marketplace prune autoremove tag uninstall remove update validate help
set -l market_subs add list remove rm update help
set -l project_subs purge help
set -l efforts low medium high xhigh max
set -l modes acceptEdits auto bypassPermissions manual dontAsk plan

function __claude_scopes --description 'Configuration and installation scopes'
    printf '%s\t%s\n' local 'This project on this machine' user 'All projects for this user' project 'Shared via a checked-in file'
end

function __claude_transcript_dir --description 'Transcript directory for the current working directory'
    echo $HOME/.claude/projects/(string replace -ra -- '[^a-zA-Z0-9]' - $PWD)
end

function __claude_sessions --description 'Resumable session IDs recorded for this directory'
    for f in (__claude_transcript_dir)/*.jsonl
        printf '%s\t%s\n' (path change-extension '' (path basename $f)) (command stat -f '%Sm' -t '%b %e %H:%M' $f 2>/dev/null)
    end
end

function __claude_agents --description 'Agent names defined for the user or this project'
    command find $HOME/.claude/agents .claude/agents -maxdepth 1 -name '*.md' 2>/dev/null | while read -l f
        printf '%s\tagent\n' (path change-extension '' (path basename $f))
    end
end

function __claude_models --description 'Model aliases plus any models cached by the CLI'
    printf '%s\t%s\n' fable 'Latest Fable model' opus 'Latest Opus model' sonnet 'Latest Sonnet model' haiku 'Latest Haiku model'
    if command -q jq; and test -f $HOME/.claude.json
        command jq -r '.additionalModelOptionsCache[]? | "\(.value)\t\(.label)"' $HOME/.claude.json 2>/dev/null
    end
end

function __claude_plugins --description 'Installed plugin ids'
    command -q jq; or return
    command claude plugin list --json 2>/dev/null | command jq -r '[.[].id] | unique | .[]'
end

function __claude_marketplaces --description 'Configured marketplace names'
    command -q jq; or return
    command claude plugin marketplace list --json 2>/dev/null | command jq -r '.[].name'
end

function __claude_mcp_servers --description 'MCP server names from user and project config'
    command -q jq; or return
    test -f $HOME/.claude.json; and command jq -r --arg cwd $PWD '((.mcpServers // {}) | keys[]), ((.projects[$cwd].mcpServers // {}) | keys[])' $HOME/.claude.json 2>/dev/null
    test -f .mcp.json; and command jq -r '(.mcpServers // {}) | keys[]' .mcp.json 2>/dev/null
end

complete -c claude -f

##### commands #####

complete -c claude -n __fish_use_subcommand -a agents -d 'Manage background agents'
complete -c claude -n __fish_use_subcommand -a auth -d 'Manage authentication'
complete -c claude -n __fish_use_subcommand -a auto-mode -d 'Inspect or reset auto mode classifier configuration'
complete -c claude -n __fish_use_subcommand -a doctor -d 'Check the health of your Claude Code installation'
complete -c claude -n __fish_use_subcommand -a gateway -d 'Run the enterprise auth/telemetry gateway'
complete -c claude -n __fish_use_subcommand -a import -d 'Import config from another AI coding agent'
complete -c claude -n __fish_use_subcommand -a install -d 'Install Claude Code native build'
complete -c claude -n __fish_use_subcommand -a mcp -d 'Configure and manage MCP servers'
complete -c claude -n __fish_use_subcommand -a plugin -d 'Manage Claude Code plugins'
complete -c claude -n __fish_use_subcommand -a project -d 'Manage Claude Code project state'
complete -c claude -n __fish_use_subcommand -a setup-token -d 'Set up a long-lived authentication token'
complete -c claude -n __fish_use_subcommand -a ultrareview -d 'Run a cloud-hosted multi-agent code review'
complete -c claude -n __fish_use_subcommand -a update -d 'Check for updates and install if available'

##### root options #####

set -l root "not __fish_seen_subcommand_from $cmds"

complete -c claude -n $root -l add-dir -r -f -a '(__fish_complete_directories)' -d 'Additional directories to allow tool access to'
complete -c claude -n $root -l agent -r -f -a '(__claude_agents)' -d 'Agent for the current session'
complete -c claude -n $root -l agents -r -f -d 'JSON object defining custom agents'
complete -c claude -n $root -l allow-dangerously-skip-permissions -d 'Make bypassing all permission checks available'
complete -c claude -n $root -l allowedTools -l allowed-tools -r -f -d 'Tool names to allow'
complete -c claude -n $root -l append-system-prompt -r -f -d 'Append a system prompt to the default system prompt'
complete -c claude -n $root -l append-system-prompt-file -r -F -d 'Append a system prompt read from a file'
complete -c claude -n $root -l autocompact -r -f -a auto -d 'Auto-compact window size (auto, or 100k-1M tokens)'
complete -c claude -n $root -l ax-screen-reader -d 'Render screen-reader friendly output'
complete -c claude -n $root -l background -l bg -d 'Start the session as a background agent and return immediately'
complete -c claude -n $root -l bare -d 'Minimal mode: skip hooks, LSP, plugins, memory, CLAUDE.md discovery'
complete -c claude -n $root -l betas -r -f -d 'Beta headers to include in API requests'
complete -c claude -n $root -l brief -d 'Enable SendUserMessage tool for agent-to-user communication'
complete -c claude -n $root -l chrome -d 'Enable Claude in Chrome integration'
complete -c claude -n $root -l cloud -d 'Create or attach to a cloud session'
complete -c claude -n $root -s c -l continue -d 'Continue the most recent conversation in this directory'
complete -c claude -n $root -l dangerously-skip-permissions -d 'Bypass all permission checks'
complete -c claude -n $root -s d -l debug -d 'Enable debug mode with optional category filtering'
complete -c claude -n $root -l debug-file -r -F -d 'Write debug logs to a specific file path'
complete -c claude -n $root -l disable-slash-commands -d 'Disable all skills'
complete -c claude -n $root -l disallowedTools -l disallowed-tools -r -f -d 'Tool names to deny'
complete -c claude -n $root -l effort -r -f -a "$efforts" -d 'Effort level for the current session'
complete -c claude -n $root -l environment -r -f -d 'Run a new cloud session on the given self-hosted environment'
complete -c claude -n $root -l exclude-dynamic-system-prompt-sections -d 'Move per-machine sections into the first user message'
complete -c claude -n $root -l fallback-model -r -f -a '(__claude_models)' -d 'Models to fall back to when the default is overloaded'
complete -c claude -n $root -l file -r -f -d 'File resources to download at startup (file_id:relative_path)'
complete -c claude -n $root -l fork-session -d 'When resuming, create a new session ID instead of reusing the original'
complete -c claude -n $root -l forward-subagent-text -d 'Forward subagent text and thinking blocks as messages'
complete -c claude -n $root -l from-pr -d 'Resume a session linked to a PR by number or URL'
complete -c claude -n $root -s h -l help -d 'Display help for command'
complete -c claude -n $root -l ide -d 'Automatically connect to IDE on startup'
complete -c claude -n $root -l include-hook-events -d 'Include all hook lifecycle events in the output stream'
complete -c claude -n $root -l include-partial-messages -d 'Include partial message chunks as they arrive'
complete -c claude -n $root -l input-format -r -f -a 'text stream-json' -d 'Input format (only works with --print)'
complete -c claude -n $root -l json-schema -r -f -d 'JSON Schema for structured output validation'
complete -c claude -n $root -l max-budget-usd -r -f -d 'Maximum dollar amount to spend on API calls'
complete -c claude -n $root -l mcp-config -r -F -d 'Load MCP servers from JSON files or strings'
complete -c claude -n $root -l model -r -f -a '(__claude_models)' -d 'Model for the current session'
complete -c claude -n $root -s n -l name -r -f -d 'Display name for this session'
complete -c claude -n $root -l no-chrome -d 'Disable Claude in Chrome integration'
complete -c claude -n $root -l no-session-persistence -d 'Do not save the session to disk'
complete -c claude -n $root -l output-format -r -f -a 'text json stream-json' -d 'Output format (only works with --print)'
complete -c claude -n $root -l permission-mode -r -f -a "$modes" -d 'Permission mode for the session'
complete -c claude -n $root -l plugin-dir -r -F -d 'Load a plugin from a directory or .zip for this session only'
complete -c claude -n $root -l plugin-url -r -f -d 'Fetch a plugin .zip from a URL for this session only'
complete -c claude -n $root -s p -l print -d 'Print response and exit (useful for pipes)'
complete -c claude -n $root -l prompt-suggestions -d 'Enable prompt suggestions'
complete -c claude -n $root -l remote-control -d 'Start an interactive session with Remote Control enabled'
complete -c claude -n $root -l remote-control-session-name-prefix -r -f -d 'Prefix for auto-generated Remote Control session names'
complete -c claude -n $root -l replay-user-messages -d 'Re-emit user messages from stdin back on stdout'
complete -c claude -n $root -s r -l resume -r -f -a '(__claude_sessions)' -d 'Resume a conversation by session ID'
complete -c claude -n $root -l safe-mode -d 'Start with all customizations disabled'
complete -c claude -n $root -l session-id -r -f -d 'Use a specific session ID for the conversation'
complete -c claude -n $root -l setting-sources -r -f -a 'user project local' -d 'Setting sources to load'
complete -c claude -n $root -l settings -r -F -d 'Settings JSON file or JSON string to load'
complete -c claude -n $root -l strict-mcp-config -d 'Only use MCP servers from --mcp-config'
complete -c claude -n $root -l system-prompt -r -f -d 'System prompt to use for the session'
complete -c claude -n $root -l system-prompt-file -r -F -d 'System prompt read from a file'
complete -c claude -n $root -l teleport -r -f -a '(__claude_sessions)' -d 'Resume a teleport session'
complete -c claude -n $root -l tmux -d 'Create a tmux session for the worktree (requires --worktree)'
complete -c claude -n $root -l tools -r -f -d 'Available tools from the built-in set'
complete -c claude -n $root -l verbose -d 'Override verbose mode setting from config'
complete -c claude -n $root -s v -l version -d 'Output the version number'
complete -c claude -n $root -s w -l worktree -d 'Create a new git worktree for this session'

##### agents #####

set -l agents_cmd __fish_seen_subcommand_from\ agents

complete -c claude -n $agents_cmd -l add-dir -r -f -a '(__fish_complete_directories)' -d 'Additional directory for dispatched sessions'
complete -c claude -n $agents_cmd -l agent -r -f -a '(__claude_agents)' -d 'Default agent for dispatched sessions'
complete -c claude -n $agents_cmd -l all -d 'With --json: also include completed background sessions'
complete -c claude -n $agents_cmd -l allow-dangerously-skip-permissions -d 'Make bypass-permissions mode available to dispatched sessions'
complete -c claude -n $agents_cmd -l cwd -r -f -a '(__fish_complete_directories)' -d 'Show only background sessions started under this path'
complete -c claude -n $agents_cmd -l dangerously-skip-permissions -d 'Alias for --permission-mode bypassPermissions'
complete -c claude -n $agents_cmd -l effort -r -f -a "$efforts" -d 'Default effort level for dispatched sessions'
complete -c claude -n $agents_cmd -l json -d 'Print active sessions as a JSON array and exit'
complete -c claude -n $agents_cmd -l mcp-config -r -F -d 'MCP server configuration for dispatched sessions'
complete -c claude -n $agents_cmd -l model -r -f -a '(__claude_models)' -d 'Default model for dispatched sessions'
complete -c claude -n $agents_cmd -l permission-mode -r -f -a "$modes" -d 'Default permission mode for dispatched sessions'
complete -c claude -n $agents_cmd -l plugin-dir -r -F -d 'Load plugins from a directory for dispatched sessions'
complete -c claude -n $agents_cmd -l setting-sources -r -f -a 'user project local' -d 'Setting sources to load'
complete -c claude -n $agents_cmd -l settings -r -F -d 'Settings file or JSON string for dispatched sessions'
complete -c claude -n $agents_cmd -l strict-mcp-config -d 'Only use MCP servers from --mcp-config in dispatched sessions'

##### auth #####

set -l auth_root "__fish_seen_subcommand_from auth; and not __fish_seen_subcommand_from $auth_subs"

complete -c claude -n $auth_root -a login -d 'Sign in to your Anthropic account'
complete -c claude -n $auth_root -a logout -d 'Log out from your Anthropic account'
complete -c claude -n $auth_root -a status -d 'Show authentication status'

complete -c claude -n '__fish_seen_subcommand_from auth; and __fish_seen_subcommand_from login' -l claudeai -d 'Use Claude subscription (default)'
complete -c claude -n '__fish_seen_subcommand_from auth; and __fish_seen_subcommand_from login' -l console -d 'Use Anthropic Console (API usage billing)'
complete -c claude -n '__fish_seen_subcommand_from auth; and __fish_seen_subcommand_from login' -l email -r -f -d 'Pre-populate email address on the login page'
complete -c claude -n '__fish_seen_subcommand_from auth; and __fish_seen_subcommand_from login' -l sso -d 'Force SSO login flow'
complete -c claude -n '__fish_seen_subcommand_from auth; and __fish_seen_subcommand_from status' -l json -d 'Output as JSON (default)'
complete -c claude -n '__fish_seen_subcommand_from auth; and __fish_seen_subcommand_from status' -l text -d 'Output as human-readable text'

##### auto-mode #####

set -l automode_root "__fish_seen_subcommand_from auto-mode; and not __fish_seen_subcommand_from $automode_subs"

complete -c claude -n $automode_root -a config -d 'Print the effective auto mode config as JSON'
complete -c claude -n $automode_root -a critique -d 'Get AI feedback on your custom auto mode rules'
complete -c claude -n $automode_root -a defaults -d 'Print the default auto mode rules as JSON'
complete -c claude -n $automode_root -a reset -d 'Reset auto mode configuration to the shipped defaults'

complete -c claude -n '__fish_seen_subcommand_from auto-mode; and __fish_seen_subcommand_from critique' -l model -r -f -a '(__claude_models)' -d 'Override which model is used'
complete -c claude -n '__fish_seen_subcommand_from auto-mode; and __fish_seen_subcommand_from defaults' -l label -r -f -d 'Show only rules whose label starts with this prefix'
complete -c claude -n '__fish_seen_subcommand_from auto-mode; and __fish_seen_subcommand_from reset' -s y -l yes -d 'Skip the confirmation prompt'

##### gateway / import / install / ultrareview #####

complete -c claude -n '__fish_seen_subcommand_from gateway' -l config -r -F -d 'Path to gateway YAML config'

complete -c claude -n '__fish_seen_subcommand_from import; and not __fish_seen_subcommand_from codex gemini' -a 'codex gemini' -d 'Agent to import from'
complete -c claude -n '__fish_seen_subcommand_from import' -l dry-run -d 'Show what would be imported without writing anything'
complete -c claude -n '__fish_seen_subcommand_from import' -l yes -d 'Skip the interactive picker'

complete -c claude -n '__fish_seen_subcommand_from install' -a 'stable latest' -d 'Version to install'
complete -c claude -n '__fish_seen_subcommand_from install' -l force -d 'Force installation even if already installed'

complete -c claude -n '__fish_seen_subcommand_from ultrareview' -l json -d 'Print the raw bugs.json payload instead of formatted findings'
complete -c claude -n '__fish_seen_subcommand_from ultrareview' -l timeout -r -f -d 'Maximum minutes to wait for the review to finish'

##### mcp #####

set -l mcp_root "__fish_seen_subcommand_from mcp; and not __fish_seen_subcommand_from $mcp_subs"

complete -c claude -n $mcp_root -a add -d 'Add an MCP server to Claude Code'
complete -c claude -n $mcp_root -a add-from-claude-desktop -d 'Import MCP servers from Claude Desktop'
complete -c claude -n $mcp_root -a add-json -d 'Add an MCP server with a JSON string'
complete -c claude -n $mcp_root -a get -d 'Get details about an MCP server'
complete -c claude -n $mcp_root -a list -d 'List configured MCP servers'
complete -c claude -n $mcp_root -a login -d 'Authenticate with an MCP server'
complete -c claude -n $mcp_root -a logout -d 'Clear stored OAuth credentials for an MCP server'
complete -c claude -n $mcp_root -a remove -d 'Remove an MCP server'
complete -c claude -n $mcp_root -a reset-project-choices -d 'Reset approved and rejected project-scoped servers'
complete -c claude -n $mcp_root -a serve -d 'Start the Claude Code MCP server'

complete -c claude -n '__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from get login logout remove' -a '(__claude_mcp_servers)' -d 'MCP server'

complete -c claude -n '__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add' -l callback-port -r -f -d 'Fixed port for OAuth callback'
complete -c claude -n '__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add' -l client-id -r -f -d 'OAuth client ID for HTTP/SSE servers'
complete -c claude -n '__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add add-json' -l client-secret -d 'Prompt for OAuth client secret'
complete -c claude -n '__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add' -s e -l env -r -f -d 'Set environment variables (KEY=value)'
complete -c claude -n '__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add' -s H -l header -r -f -d 'Set headers (Name: value)'
complete -c claude -n '__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add' -s t -l transport -r -f -a 'stdio sse http' -d 'Transport type'
complete -c claude -n '__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add add-json add-from-claude-desktop remove' -s s -l scope -r -f -a '(__claude_scopes)' -d 'Configuration scope'
complete -c claude -n '__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from login' -l no-browser -d 'Print the authorization URL instead of opening a browser'
complete -c claude -n '__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from serve' -s d -l debug -d 'Enable debug mode'
complete -c claude -n '__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from serve' -l verbose -d 'Override verbose mode setting from config'

##### plugin #####

set -l plugin_root "__fish_seen_subcommand_from plugin plugins; and not __fish_seen_subcommand_from $plugin_subs"
set -l plugin_sub "__fish_seen_subcommand_from plugin plugins; and not __fish_seen_subcommand_from marketplace"

complete -c claude -n $plugin_root -a details -d 'Show a plugin component inventory and projected token cost'
complete -c claude -n $plugin_root -a disable -d 'Disable an enabled plugin'
complete -c claude -n $plugin_root -a enable -d 'Enable a disabled plugin'
complete -c claude -n $plugin_root -a eval -d 'Run eval cases against a plugin and report scored results'
complete -c claude -n $plugin_root -a init -d 'Scaffold a new plugin'
complete -c claude -n $plugin_root -a install -d 'Install a plugin from available marketplaces'
complete -c claude -n $plugin_root -a list -d 'List installed plugins'
complete -c claude -n $plugin_root -a marketplace -d 'Manage Claude Code marketplaces'
complete -c claude -n $plugin_root -a prune -d 'Remove auto-installed dependencies that are no longer needed'
complete -c claude -n $plugin_root -a tag -d 'Create a release git tag for a plugin'
complete -c claude -n $plugin_root -a uninstall -d 'Uninstall an installed plugin'
complete -c claude -n $plugin_root -a update -d 'Update a plugin to the latest version'
complete -c claude -n $plugin_root -a validate -d 'Validate a plugin or marketplace manifest'

complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from details disable enable uninstall remove update" -a '(__claude_plugins)' -d 'Installed plugin'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from disable" -s a -l all -d 'Disable all enabled plugins'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from disable enable install i uninstall remove update prune autoremove" -s s -l scope -r -f -a '(__claude_scopes)' -d 'Installation scope'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from install i" -l config -r -f -d 'Set a userConfig option declared in the plugin manifest'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from list" -l available -d 'Include available plugins from marketplaces (requires --json)'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from list" -l json -d 'Output as JSON'
complete -c claude -n "$plugin_sub; and not __fish_seen_subcommand_from eval; and __fish_seen_subcommand_from init new" -l author -r -f -d 'Author name'
complete -c claude -n "$plugin_sub; and not __fish_seen_subcommand_from eval; and __fish_seen_subcommand_from init new" -l author-email -r -f -d 'Author email'
complete -c claude -n "$plugin_sub; and not __fish_seen_subcommand_from eval; and __fish_seen_subcommand_from init new" -l description -r -f -d 'Manifest description'
complete -c claude -n "$plugin_sub; and not __fish_seen_subcommand_from eval; and __fish_seen_subcommand_from init new" -s f -l force -d 'Overwrite an existing .claude-plugin/ at the target'
complete -c claude -n "$plugin_sub; and not __fish_seen_subcommand_from eval; and __fish_seen_subcommand_from init new" -l with -r -f -a 'skills agents hooks mcp lsp output-style channel' -d 'Also scaffold these components'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from prune autoremove tag" -l dry-run -d 'List what would happen without doing it'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from prune autoremove uninstall remove" -s y -l yes -d 'Skip the confirmation prompt'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from uninstall remove" -l keep-data -d 'Preserve the plugin persistent data directory'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from uninstall remove" -l prune -d 'Also remove auto-installed dependencies no longer needed'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from tag validate" -F -d 'Path'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from tag" -s f -l force -d 'Skip the dirty-tree and tag-exists checks'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from tag" -s m -l message -r -f -d 'Tag annotation message (%s for the version)'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from tag" -l push -d 'Push the tag to --remote after creating it'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from tag" -l remote -r -f -a '(__fish_git_remotes)' -d 'Remote to push to with --push'
complete -c claude -n "$plugin_sub; and __fish_seen_subcommand_from validate" -l strict -d 'Treat warnings as errors'

##### plugin eval #####

set -l plugin_eval "__fish_seen_subcommand_from plugin plugins; and __fish_seen_subcommand_from eval; and not __fish_seen_subcommand_from init"

complete -c claude -n "$plugin_eval" -a init -d 'Author an eval suite under evals/'
complete -c claude -n "$plugin_eval" -a '(__claude_plugins)' -d 'Eval target'
complete -c claude -n "$plugin_eval" -l ablation -r -f -a 'none with-without' -d 'Run a no-plugin baseline arm and report the score delta'
complete -c claude -n "$plugin_eval" -l allow-tools -r -f -d 'Operator grant for gated tools'
complete -c claude -n "$plugin_eval" -l case -r -f -d 'Filter cases by name glob'
complete -c claude -n "$plugin_eval" -l json -r -F -d 'Print or write the full run result as JSON'
complete -c claude -n "$plugin_eval" -l judge-model -r -f -a '(__claude_models)' -d 'Override LLM-grader model'
complete -c claude -n "$plugin_eval" -l keep-temp -d 'Preserve scaffold dirs for debugging'
complete -c claude -n "$plugin_eval" -l max-cost-usd -r -f -d 'Hard cost ceiling'
complete -c claude -n "$plugin_eval" -l model -r -f -a '(__claude_models)' -d 'Override model for all cases'
complete -c claude -n "$plugin_eval" -l no-publish -d 'Keep the HTML report local only'
complete -c claude -n "$plugin_eval" -l no-scaffold -d 'Explicitly skip scaffold_script'
complete -c claude -n "$plugin_eval" -l output-dir -r -f -a '(__fish_complete_directories)' -d 'Directory for aggregate-result.json'
complete -c claude -n "$plugin_eval" -l publish-report -d 'Also require publishing the report to claude.ai'
complete -c claude -n "$plugin_eval" -l report -r -F -d 'Write the HTML report to this path'
complete -c claude -n "$plugin_eval" -l runs -r -f -d 'Override per-case runs'
complete -c claude -n "$plugin_eval" -l scaffold -d 'Run each case scaffold_script'
complete -c claude -n "$plugin_eval" -l tag -r -f -d 'Filter cases by tag'
complete -c claude -n "$plugin_eval" -l threshold -r -f -d 'Exit 1 if any case score is below this threshold'
complete -c claude -n "$plugin_eval" -l verbose -d 'Stream the trace as it runs'

set -l plugin_eval_init "__fish_seen_subcommand_from plugin plugins; and __fish_seen_subcommand_from eval; and __fish_seen_subcommand_from init"

complete -c claude -n "$plugin_eval_init" -l bare -d 'Write a blank template instead of running the interview'
complete -c claude -n "$plugin_eval_init" -s i -l interactive -d 'Run the authoring interview'

##### plugin marketplace #####

set -l market "__fish_seen_subcommand_from plugin plugins; and __fish_seen_subcommand_from marketplace"

complete -c claude -n "$market; and not __fish_seen_subcommand_from $market_subs" -a add -d 'Add a marketplace from a URL, path, or GitHub repo'
complete -c claude -n "$market; and not __fish_seen_subcommand_from $market_subs" -a list -d 'List all configured marketplaces'
complete -c claude -n "$market; and not __fish_seen_subcommand_from $market_subs" -a remove -d 'Remove a configured marketplace'
complete -c claude -n "$market; and not __fish_seen_subcommand_from $market_subs" -a update -d 'Update marketplaces from their source'

complete -c claude -n "$market; and __fish_seen_subcommand_from remove rm update" -a '(__claude_marketplaces)' -d 'Marketplace'
complete -c claude -n "$market; and __fish_seen_subcommand_from add remove rm" -l scope -r -f -a '(__claude_scopes)' -d 'Settings scope for the marketplace declaration'
complete -c claude -n "$market; and __fish_seen_subcommand_from add" -l sparse -r -f -a '(__fish_complete_directories)' -d 'Limit checkout to specific directories'
complete -c claude -n "$market; and __fish_seen_subcommand_from list" -l json -d 'Output as JSON'

##### project #####

set -l project_root "__fish_seen_subcommand_from project; and not __fish_seen_subcommand_from $project_subs"
set -l project_purge '__fish_seen_subcommand_from project; and __fish_seen_subcommand_from purge'

complete -c claude -n $project_root -a purge -d 'Delete all Claude Code state for a project'

complete -c claude -n $project_purge -a '(__fish_complete_directories)' -d 'Project path'
complete -c claude -n $project_purge -l all -d 'Purge state for every project'
complete -c claude -n $project_purge -l dry-run -d 'List what would be deleted without deleting anything'
complete -c claude -n $project_purge -s i -l interactive -d 'Prompt for each item before deleting'
complete -c claude -n $project_purge -s y -l yes -d 'Skip confirmation prompt'

##### every command takes --help #####

complete -c claude -n "__fish_seen_subcommand_from $cmds" -s h -l help -d 'Display help for command'
