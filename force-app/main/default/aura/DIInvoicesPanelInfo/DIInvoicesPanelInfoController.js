({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    update: function (component, event, helper) {
        console.log('DEBUG:TimesheetsPanelInfo:update');

        let params = event.getParam('arguments');
        let data = params['data'];

        console.log('Debug:TimesheetsPanelInfo:update:data', data.id, data.data, data.data.state);

        helper.update(component, data);
    }
})