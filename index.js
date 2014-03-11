#!/usr/bin/env node
path = require('path');
fs   = require('fs');

// Coffeescript 1.0 and 2.0 respectively. Comment out the one you aren't using.
require('coffee-script/register');
// require('coffee-script-redux/register');

require(path.join(__dirname, "backend"));
