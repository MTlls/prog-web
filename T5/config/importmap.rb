# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "jquery", to: "https://code.jquery.com/jquery-3.7.1.min.js" 
pin "jquery-ui", to: "https://code.jquery.com/ui/1.13.3/jquery-ui.min.js"   
pin "autocomplete"
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true