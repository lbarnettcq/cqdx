({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    handleRowAction: function(component, event, helper) {
        let action = event.getParam('action');     

        switch (action.name) {
            case 'edit':
            case 'delete':
            case 'details':
                helper.showModalDialog(component, event, action.name);
                break;
        }
    },
    handleChangeModalDialogConfirm: function(component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        let data = event.getParam('data');

        console.log('DEBUG:DIExpensesContainer:Controller:handleChange', data['id'], data['action'], data['view']);

        helper.handleChange(component, data);
    },
    handleCreateExpense: function(component, event, helper) {
        helper.showModalDialog(component, event, 'create');       
    },
    handleChange: function(component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        let data = event.getParam('data');

        console.log('DEBUG:DIExpensesContainer:Controller:handleChange', data['id'], data['state']);
        
        helper.handleChange(component, data);
    },
    update: function (component, event, helper) {
        console.log('DEBUG:DIExpensesContainer:Controller:update');
        let params = event.getParam('arguments');
        let data = params['data'];
        
        helper.update(component, data);
    },
})