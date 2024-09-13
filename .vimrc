if isdirectory("/home/linuxbrew/.linuxbrew/opt/fzf")
    set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
elseif isdirectory("/opt/homebrew/opt/fzf")
    set rtp+=/opt/homebrew/opt/fzf
elseif isdirectory("/usr/local/opt/fzf")
    set rtp+=/usr/local/opt/fzf
endif