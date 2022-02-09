({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    handleChange: function(component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        let data = event.getParam('data');

        console.log('DEBUG:EVENT:CHAINS:TimeTrackingContainer:Controller:', data['id'], data['state'], data['data'], data['dependencies'], data['status']);

        console.log('DEBUG:TIMESHEET:handleChange', data['id'], data['state'], data['data'], data['dependencies']);
        
        helper.handleChange(component, data);
    }
})