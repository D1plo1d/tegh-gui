# Tegh Brower Plugins

## Dev Requirements

1. Install node and npm
2. `npm install -g bower && npm install -g brunch`

## Development

The Tegh Browser Plugins uses brunch to automatically compile and reload any changes to the source files.

This does not always work. To make sure the page is reloaded as expected always resave:
* **app/styles/app.styl** if you are editing a css or styl file
* **app/index.jade** if you are editing a jade file
* **app/scripts/app.coffee** if you are editing a coffee file

* Source files are located in the `app` directory.
* Compiled files are located in `_public`. Do not edit these directly. They are generated from the `app` directory files.

### Running Brunch

1. run `bower install` to download any new client side libraries
2. run `brunch watch --server` from the tegh browser plugin folder
3. open **_public/index.html** in chrome. This page will automatically reload changes.
