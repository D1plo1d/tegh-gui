opts =
  width: 1200
  height: 700
  minWidth: 800
  minHeight: 600
  left: 100
  top: 100
  type: 'shell'

chrome.app.runtime.onLaunched.addListener ->
  chrome.app.window.create '/index.html', opts
