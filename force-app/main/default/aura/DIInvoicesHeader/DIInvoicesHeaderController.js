({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    handleCreateInvoice: function(component, event, helper) {
        helper.showModalDialog(component, event, 'create');       
    },
    handleSendInvoice: function(component, event, helper) {
        helper.showModalDialog(component, event, 'send');       
    },
    handleMarkPaidInvoice: function(component, event, helper) {
        helper.showModalDialog(component, event, 'mark_paid'); 
    },
    handleEditInvoice: function(component, event, helper) {
        helper.showModalDialog(component, event, 'edit');       
    },
    handleRemoveInvoice: function(component, event, helper) {
        helper.showModalDialog(component, event, 'delete');       
    },
    handleChangeModalDialogConfirm: function(component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        let data = event.getParam('data');

        console.log('DEBUG:InvoicesHeader:Controller:handleChange', data['id'], data['action'], data['view']);

        helper.handleChange(component, data);
    },
    update: function (component, event, helper) {
        console.log('DEBUG:InvoicesHeader:update');

        let params = event.getParam('arguments');
        let data = params['data'];

        console.log('Debug:InvoicesHeader:Controller:update:data', data.id, data.data, data.data.state);

        helper.update(component, data);
    }
})