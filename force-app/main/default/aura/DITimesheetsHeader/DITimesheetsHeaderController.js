({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    handleCreateTimesheet: function(component, event, helper) {
        helper.showModalDialog(component, event, 'create');       
    },
    handleSendTimesheet: function(component, event, helper) {
        helper.showModalDialog(component, event, 'send');       
    },
    handleRefreshTimesheet: function(component, event, helper) {
        helper.refreshTimesheet(component);       
    },    
    handleMarkApprovedTimesheet: function(component, event, helper) {
        helper.showModalDialog(component, event, 'approve'); 
    },
    handleEditTimesheet: function(component, event, helper) {
        helper.showModalDialog(component, event, 'edit');       
    },
    handleRemoveTimesheet: function(component, event, helper) {
        helper.showModalDialog(component, event, 'delete');       
    },
    handleChangeModalDialogConfirm: function(component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        let data = event.getParam('data');

        console.log('DEBUG:TimesheetsHeader:Controller:handleChange', data['id'], data['action'], data['view']);

        helper.handleChange(component, data);
    },
    update: function (component, event, helper) {
        console.log('DEBUG:TimesheetsHeader:update');

        let params = event.getParam('arguments');
        let data = params['data'];

        console.log('Debug:TimesheetsHeader:Controller:update:data', data.id, data.data, data.data.state);

        helper.update(component, data);
    }
})