# This isn't really a script, just a snippet for profiling zsh scripts.
# Surround the code you want profiled (the stuff here section), and when run,
# a logfile will be ouput to ~/tmp. Useful for lowering zsh startup times.
# From: https://kev.inburke.com/kevin/profiling-zsh-startup-time/

PS4=$'%D{%M%S%.} %N:%i> ' # set the trace prompt to include seconds, nanoseconds, script name and line number
exec 3>&2 2>$HOME/tmp/startlog.$$ # direct trace output to file with PID as extension
setopt xtrace prompt_subst # turn on tracing and expansion of commands

# stuff here

unsetopt xtrace
exec 2>&3 3>&- # restore stderr to the value saved in FD 3


# also helpful is zprof
# put this line where you want to start (perhaps top of .zshenv)
zmodload zsh/zprof

# then run the following once the shell has loaded
zprof
