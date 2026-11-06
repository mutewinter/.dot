# A shell whose login session is gone (the window server died and macOS built
# a new session) can no longer reach Mach services: the system resolver,
# notifyd, the keychain. node reports ENOTFOUND and pnpm hangs while dig still
# answers. The herdr server outlives that boundary and strands every pane it
# spawns, so say so the moment such a shell opens.
if status is-interactive; and test (uname) = Darwin; and set -q SECURITYSESSIONID
    set -l live (launchctl print gui/(id -u) 2>/dev/null | string match -r 'asid = (\d+)')[2]
    if test -n "$live"; and test (printf '%x' $live) != (string lower $SECURITYSESSIONID)
        set_color yellow
        echo "This shell belongs to a login session that no longer exists; DNS and other system services will hang or fail here."
        echo "Restart the herdr server from a fresh terminal: herdr server stop; and herdr"
        set_color normal
    end
end
