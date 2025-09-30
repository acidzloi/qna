# Pin npm packages by running ./bin/importmap

pin "application"
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
