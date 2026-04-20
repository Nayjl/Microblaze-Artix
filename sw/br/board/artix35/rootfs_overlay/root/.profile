if [ -n "$SSH_TTY" ]; then
    echo "Welcome, $USER | $(date '+%Y-%m-%d %H:%M:%S')"
    echo "SSH session | Host: $(hostname) | Kernel: $(uname -r)"
fi
