# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w[*.ico *.eot *.woff *.ttf *.svg *.oft *.png *jpg *jpeg *.gif
                                                 application.css lazy.css
                                                 mdb.min.js
                                                 mdb4.7.6/mdb.min.js
                                                 common.js
                                                 mdb.scss
                                                 cable.jp
                                                 dropzone.js dropzone/*.css
                                                 gmaps_google.js
                                                 i18n.js
                                                 i18n/*.js
                                                 translations.js
                                                 jquery.timepicker.min.js
                                                 jquery.datepair.min.js
                                                 jquery.matchHeight.js
                                                 selectionDialogControl.js
                                                 message-loader.js
                                                 message.css
                                                 message.js
                                                 admin_users/*.css
                                                 selectionDialogControl.js
                                                 wysiwyg.js
                                                 wysiwyg.css
                                                 autosize.js
                                                 ie-shim.js
                                                 font-awesome.css]

Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'font', 'roboto')
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf|woff2)\z/
