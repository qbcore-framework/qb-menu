fx_version 'cerulean'
game 'common'

ui_page 'html/index.html'

shared_script {
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
    'client/*.lua'
}

files {
    'html/*.html',
    'html/js/*.js',
    'html/css/*.css'
}

dependencies {
    'PolyZone',
    'qb-core'
}