({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    handleTimeCellChange: function(component, event, helper) {
        helper.changeCell(component, event);
    },
    onChildAttributeChange : function (component, event, helper) {
        console.log('Old value: ' + event.getParam('oldValue'));
        console.log('Current value: ' + event.getParam('value'));
    },
    handleButtonCancelClick: function(component, event, helper) {
        helper.handlerButtonCancelClick(component);
    },
    handleButtonSaveClick: function(component, event, helper) {
        helper.handlerButtonSaveClick(component);
    },
    update: function (component, event, helper) {
        let params = event.getParam('arguments');
        let data = params['data'];

        console.log('DEBUG:EVENT:CHAINS:TABLE', data.id,  data.state);
        helper.update(component, data);
    }
})