fx_version 'adamant'
game 'common'

author 'RME'
description 'Transparent chat theme for RME - removes the dark/blue chat background block while keeping messages readable.'
version '1.0.0'

file 'style.css'

chat_theme 'rmeclean' {
    styleSheet = 'style.css',
    msgTemplates = {
        default = '<b>{0}</b><span>{1}</span>'
    }
}
