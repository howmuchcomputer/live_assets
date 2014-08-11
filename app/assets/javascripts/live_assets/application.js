//= require_self

window.onload = function() {
  console.log("loaded javascript from live assets engine");
  // 1. Connect to our event-stream
  var source = new EventSource('/live_assets/sse');
  // 2. This callback will be triggered on every reloadCSS event

  source.addEventListener('reloadCSS', function(e) {

      console.log("checking sheets");
    // 3. Load all CSS entries
    var sheets = document.querySelectorAll("[rel=stylesheet]");
    var forEach = Array.prototype.forEach;
    // 4. For each entry, clone it, add it to the
    // document and remove the original after
    forEach.call(sheets, function(sheet){
      var clone = sheet.cloneNode();
      clone.addEventListener('load', function() {
        sheet.parentNode.removeChild(sheet);
      });
      console.log("appending clone...");
      document.head.appendChild(clone);
    });
  });
};
