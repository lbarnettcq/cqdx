({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    handleSelectItemList : function(component, event, helper) {
        console.log('DEBUG:HEADER:handleSelectItemList', event.getParam('data'));
        helper.notify(component, 'diMenu');
    },
    handleSelectDate : function(component, event, helper) {
        console.log('DEBUG:HEADER:handleSelectDate', event.getParam('data'));
        helper.notify(component, 'diDatePicker');
    },
    handleChange: function(component, event, helper) {
        let data = event.getParam('data');

        console.log('DEBUG:HEADER:handleChange', data['id']);

        helper.notify(component, data['id']);
    }
})