({
   scriptsLoaded: function(component, event, helper) {
      helper.processingProcess(component, 'scriptsLoaded');
   },
   doInit: function(component, event, helper) {
      helper.processingProcess(component, 'init');
   },
   update: function (component, event, helper) {
      let params = event.getParam('arguments');
      let data = params['data'];

      //console.log('DEBUG: DiModalDialogController: update:before ');
      /*let params = event.getParam('arguments');
      let data = params['data'];

      console.log('DEBUG: onCheck: value: ', data.view, data.starDate, data.endDate, date.userId);*/
      if(distdlib.isObject(data)) {
         console.log('DEBUG: DiModalDialogController: update ', data.open, data.title, data.description, data.view, data.userId, data.startDate,data.endDate);
         helper.updateView(component, data);        
      } else {
         console.log('DEBUG: DiModalDialogController: update: not is object');
      }
   },
   openModel: function(component, event, helper) {
      helper.openModal(component);
   },
   closeModel: function(component, event, helper) {
      helper.closeModal(component);
   },
   handleSelectClient: function (component, event, helper) {
      helper.selectClient(component, event.getParam('value'));
   },
   handleSelectEmployee: function(component, event, helper) {
      helper.selectEmployee(component, event.getParam('value'));
   },
   handleChangeDateRange: function(component, event, helper) {
      let data = event.getParam('data');
      //helper.createClients(component);
      console.log('DEBUG:DIModalDialogTimesheetController:handleChangeDateRange', data.data['id'], data.data['selectedDate'],  data.data['startDate'], data.data['endDate']);

      if(data.data['startDate']) {
         helper.setView(component, 'startDate', data.data['startDate']);
      }

      if(data.data['endDate']) {
         helper.setView(component, 'endDate', data.data['endDate']);
      }
   },
   submit: function(component, event, helper) {
      helper.submit(component);
   }
 })