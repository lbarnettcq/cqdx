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
   cancel: function(component, event, helper) {
      helper.closeModal(component);
      helper.notify(component, 'cancel');
   },
   submit: function(component, event, helper) {
      helper.submit(component);
   },
   update: function (component, event, helper) {
      let params = event.getParam('arguments');
      let data = params['data'];
      helper.update(component, data);   
   }
 })