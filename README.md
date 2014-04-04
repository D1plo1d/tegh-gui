# Tegh GUI

## Dev Requirements

1. Install node, node-webkit, and npm
2. Install brunch >=1.7 and bower. If these are not in your distro's repo, they can also be installed using npm: `npm install -g bower && npm install -g brunch`

## Development

The Tegh GUI uses brunch to automatically compile and reload any changes to the source files.

This does not always work. To make sure the page is reloaded as expected always resave:
* **app/styles/app.styl** if you are editing a css or styl file
* **app/index.jade** if you are editing a jade file
* **app/scripts/app.coffee** if you are editing a coffee file

* Source files are located in the `app` directory.
* Compiled files are located in `_public`. Do not edit these directly. They are generated from the `app` directory files.
* The node-webkit toolbar can be enabled in **package.json**  Further debugging can be accomplished by adding `enable-logging --v=1` to the nw command line options.

### Running Tegh-GUI:

1. run `npm install && bower install` to download any new client side libraries
2. run `brunch watch` to build
3. run `nw .` to launch Tegh-GUI
