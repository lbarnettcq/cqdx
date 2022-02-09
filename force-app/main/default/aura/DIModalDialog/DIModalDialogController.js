({
   scriptsLoaded: function(component, event, helper) {
      helper.processingProcess(component, 'scriptsLoaded');
   },
   doInit: function(component, event, helper) {
      helper.processingProcess(component, 'init');
   },
   openModal: function(component, event, helper) {
      helper.openModal(component);
   },
   closeModal: function(component, event, helper) {
      helper.closeModal(component);
   },
   submit: function(component, event, helper) {
      helper.updateStatus(component, event, (component.get('v.type') === 'approve'));
   },
   handleChange: function(component, event, helper) {
      console.log('DEBUG: onCheck: value: ', event.getSource());
      helper.updateSubmit(component);
   },
   update: function (component, event, helper) {
      let params = event.getParam('arguments');
      let data = params['data'];
      helper.update(component, data);
   }
 })