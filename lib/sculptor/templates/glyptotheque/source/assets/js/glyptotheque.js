//= require_tree ./glyptotheque

angular.module('glyptotheque', ['directives', 'controllers']);

function resizeIframe(obj) {
  var doc = obj.contentDocument;
  var height = Math.max(
      doc.body.scrollHeight, doc.documentElement.scrollHeight,
      doc.body.offsetHeight, doc.documentElement.offsetHeight,
      doc.body.clientHeight, doc.documentElement.clientHeight
  );
  obj.style.height = height + 'px';
}
