#!/usr/bin/env bash

# https://github.com/kvndrsslr/sketchybar-app-font

### START-OF-ICON-MAP
function __icon_map() {
    case "$1" in
   "App Store")
        icon_result=":app_store:"
        ;;
   "Calendar" | "日历" | "Fantastical" | "Cron" | "Amie")
        icon_result=":calendar:"
        ;;
   "Code" | "Code - Insiders")
        icon_result=":code:"
        ;;
   "Default")
        icon_result=":default:"
        ;;
   "Docker" | "Docker Desktop")
        icon_result=":docker:"
        ;;
   "Finder" | "访达")
        icon_result=":finder:"
        ;;
   "Firefox")
        icon_result=":firefox:"
        ;;
   "Firefox Developer Edition" | "Firefox Nightly")
        icon_result=":firefox_developer_edition:"
        ;;
   "System Preferences" | "System Settings" | "系统设置")
        icon_result=":gear:"
        ;;
   "Chromium" | "Google Chrome" | "Google Chrome Canary")
        icon_result=":google_chrome:"
        ;;
   "iTerm" | "iTerm2")
        icon_result=":iterm:"
        ;;
   "Canary Mail" | "HEY" | "Mail" | "Mailspring" | "MailMate" | "邮件")
        icon_result=":mail:"
        ;;
   "Maps" | "Google Maps")
        icon_result=":maps:"
        ;;
   "Microsoft Excel")
        icon_result=":microsoft_excel:"
        ;;
   "Microsoft Outlook")
        icon_result=":microsoft_outlook:"
        ;;
   "Microsoft PowerPoint")
        icon_result=":microsoft_power_point:"
        ;;
   "Microsoft Teams" | "Microsoft Teams (work or school)")
        icon_result=":microsoft_teams:"
        ;;
   "Microsoft Word")
        icon_result=":microsoft_word:"
        ;;
   "Notes" | "备忘录" | "Notizen")
        icon_result=":notes:"
        ;;
   "Preview" | "预览" | "Skim" | "zathura")
        icon_result=":pdf:"
        ;;
   "Reminders" | "提醒事项")
        icon_result=":reminders:"
        ;;
   "Safari" | "Safari浏览器" | "Safari Technology Preview")
        icon_result=":safari:"
        ;;
   "Slack")
        icon_result=":slack:"
        ;;
   "Spotify")
        icon_result=":spotify:"
        ;;
   "Spotlight")
        icon_result=":spotlight:"
        ;;
   "Terminal" | "终端")
        icon_result=":terminal:"
        ;;
   "Neovide" | "MacVim" | "Vim" | "VimR")
        icon_result=":vim:"
        ;;
   "WezTerm")
        icon_result=":wezterm:"
        ;;
    *)
        icon_result=":default:"
        ;;
    esac
}
### END-OF-ICON-MAP

__icon_map "$1"
echo "$icon_result"
