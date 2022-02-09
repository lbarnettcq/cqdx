({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    handleCreatePayment: function(component, event, helper) {
        helper.showModalDialog(component, event, 'create');       
    },
    handleSendPayment: function(component, event, helper) {
        helper.showModalDialog(component, event, 'send');       
    },
    handleMarkPaidPayment: function(component, event, helper) {
        helper.showModalDialog(component, event, 'mark_paid'); 
    },
    handleEditPayment: function(component, event, helper) {
        helper.showModalDialog(component, event, 'edit');       
    },
    handleRemovePayment: function(component, event, helper) {
        helper.showModalDialog(component, event, 'delete');       
    },
    handleChangeModalDialogConfirm: function(component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        let data = event.getParam('data');

        console.log('DEBUG:PaymentsHeader:Controller:handleChange', data['id'], data['action'], data['view']);

        helper.handleChange(component, data);
    },
    update: function (component, event, helper) {
        console.log('DEBUG:PaymentsHeader:update');

        let params = event.getParam('arguments');
        let data = params['data'];

        console.log('Debug:PaymentsHeader:Controller:update:data', data.id, data.data, data.data.state);

        helper.update(component, data);
    }
})