({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    handleApprove: function(component, event, helper) {
        console.log('DEBUG:TeamTimeTrackingHeader:handleApprove');
        helper.showModalDialog(component, event, 'approve');
    },
    handleUnlock: function(component, event, helper) {
        console.log('DEBUG:TeamTimeTrackingHeader:handleUnlock');
        helper.showModalDialog(component, event, 'unlock');
    },
    handleFilterButtonClick : function(component, event, helper) {
        console.log('handleFilterButtonClick:');
        helper.toogleFilter(component);
    },
    update: function (component, event, helper) {
        console.log('DEBUG:TeamTimeTrackingHeader:update');

        let params = event.getParam('arguments');
        let data = params['data'];

        console.log('Debug:TeamTimeTrackingHeader:update:data', data.id, data.data, data.data.state);

        helper.update(component, data);  
    }
})