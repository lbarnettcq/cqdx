({
   scriptsLoaded: function(component, event, helper) {
      helper.processingProcess(component, 'scriptsLoaded');
   },
   doInit: function(component, event, helper) {
      helper.processingProcess(component, 'init');
   },
   openModel: function(component, event, helper) {
      helper.openModal(component);
   },
   closeModel: function(component, event, helper) {
      helper.closeModal(component);
   },
   handleSelectPaymentType: function (component, event, helper) {
      helper.selectPaymentType(component, event.getParam('value'));
   },
   handleSelectReceiver: function (component, event, helper) {
      helper.selectReceiver(component, event.getParam('value'));
   },
   update: function (component, event, helper) {
      let params = event.getParam('arguments');
      let data = params['data'];
      
      if(distdlib.isObject(data)) {
         console.log('DEBUG: DiModalDialogController: update ', data.open, data.title, data.description, 
         data.view, data.userId, data.startDate,data.endDate);
         helper.updateView(component, data);        
      } else {
         console.log('DEBUG: DiModalDialogController: update: not is object');
      }
   },
   submit: function(component, event, helper) {
      helper.submit(component);
   }
 })