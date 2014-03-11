// (function() {
//   window.brunch = {};
//   window.brunch['auto-reload'] = {};

//   var disabled = window.brunch['auto-reload'].disabled;
//   window.brunch['auto-reload'].disabled = true;

//   var WebSocket = window.WebSocket || window.MozWebSocket;
//   var br = window.brunch = (window.brunch || {});
//   var ar = br['auto-reload'] = (br['auto-reload'] || {});
//   if (!WebSocket || disabled) return;

//   var cacheBuster = function(url){
//     var date = Math.round(Date.now() / 1000).toString();
//     url = url.replace(/(\&|\\?)cacheBuster=\d*/, '');
//     return url + (url.indexOf('?') >= 0 ? '&' : '?') +'cacheBuster=' + date;
//   };

//   var reloaders = {
//     page: function(){
//       if (chrome && chrome.runtime && chrome.runtime.reload) {
//         chrome.runtime.reload();
//       }
//       else {
//         window.location.reload(true);
//       }
//     },

//     stylesheet: function(){
//       [].slice
//         .call(document.querySelectorAll('link[rel="stylesheet"]'))
//         .filter(function(link){
//           return (link != null && link.href != null);
//         })
//         .forEach(function(link) {
//           link.href = cacheBuster(link.href);
//         });
//     }
//   };
//   var port = ar.port || 9485;
//   var host = (!br['server']) ? "127.0.0.1" : br['server'];
//   var connect = function(){
//     var connection = new WebSocket('ws://' + host + ':' + port);
//     connection.onmessage = function(event){
//       var message = event.data;
//       if (disabled) return;
//       if (reloaders[message] != null) {
//         reloaders[message]();
//       } else {
//         reloaders.page();
//       }
//     };
//     connection.onerror = function(){
//       if (connection.readyState) connection.close();
//     };
//     connection.onclose = function(){
//       window.setTimeout(connect, 1000);
//     };
//   };
//   connect();
// })();
