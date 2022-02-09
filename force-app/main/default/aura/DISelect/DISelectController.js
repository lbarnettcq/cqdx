({
    init : function(component, event, helper) {
      helper.init(component, event);
    },
    handleSelectChange: function(component, event, helper) {
      let target = event.currentTarget;
      let compEvent = component.getEvent('selectChange');
      compEvent.setParams({ 'data': target.value });
      compEvent.fire();
      console.log('select changed: ' + target.value)
    }
  })