(function(global) {
  var module = function() {
    function subscribe(event) {
      Sfdc.canvas.parent.subscribe(event)
    }
    function unsubscribe(event) {
      Sfdc.canvas.parent.unsubscribe(event)
    }
    function publish(event) {
      Sfdc.canvas.parent.publish(event)
    }
    function resize(size, target) {
      Sfdc.canvas.parent.resize(size, target)
    }
    return{subscribe:subscribe, unsubscribe:unsubscribe, publish:publish, resize:resize}
  }();
  global.Sfdc = global.Sfdc || {};
  global.Sfdc.canvas = global.Sfdc.canvas || {};
  global.Sfdc.canvas.controller = module
})(this);