({
    config: {
        create: {
            title: 'New Invoice',
            description: ['', '']
        },
        edit: {
            title: 'Edit Invoice',
            description: ['']
        },
        send: {
            title: 'Send Invoice',
            description: ['']
        }
    },
    errors: [],
    invoiceNumber: null,
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:ModalDialog:Create Invoice:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
        this.cleanClients(component);
        this.resetDates(component);
        this.resetErrors(component);
        this.createBasicInformation(component);

        if(this.showModalDialog(component)) {
            //this.load(component);
        }
    },
    load: function(component) {
        if(this.canLoad()) {
            this.createClients(component);
        } else {
            this.updateMessage(component, true, 'Data can not load. User or date range are absent');
        }
    },
    showModalDialog: function(component) {
        return (component.get('v.opened') == true);
    },
    canLoad: function() {
        return true;
    },
    createBasicInformation: function(component) {
        let view = this.getView(component, 'view');
        let title = '';
        let description = '';

        if(this.config[view]) {
            title = this.config[view]['title'];
            description = this.config[view]['description'];
        }

        this.setView(component, 'title', title);
        this.setView(component, 'description', description);
    },
    createClients: function(component) {
        let params = {};

        this.sendRequest(component, 'c.getAccounts', params)
        .then((data) => {
            console.log('DEBUG:DiMoalDialogInvoicesHelper: Load:Success:', data);

            if(distdlib.isObject(data.data) && Array.isArray(data.data.list)) {
                let items = [];

                data.data.list.forEach(account => {
                    let item = {
                        'label': account.name,
                        'value': account.id
                    };
                    items.push(item);
                });

                this.setView(component, 'clients', items);
            }  
        })
        .catch((errors) => {
            console.error('DEBUG:DiMoalDialogInvoicesHelper: Load:Error:', errors);
        });
    },
    cleanClients: function(component) {
        this.setView(component, 'clients', []);
        this.setView(component, 'accountId', null);
    },
    submit: function(component) {
        if(this.validate(component)) {
            this.resetErrors(component);

            switch(this.getView(component, 'view')) {
                case 'edit':
                    this.updateInvoice(component);
                    break;
                case 'create':
                    this.createInvoice(component);
                    break;
            }
        } else {
            this.setView(component, 'showError', true);
            this.setView(component, 'errortype', 'client');
            this.setView(component, 'errorsFields',  'These required fields must be completed: ' + this.errors.join(', '));
        }
    },
    createInvoice: function(component) {
        if(this.canCreateInvoice(component)) {            
            let params = {
                accountId: this.getView(component, 'accountId'),
                startDate: distdlib.date.addZero(this.createDate(this.getView(component, 'startDate'))),
                endDate: distdlib.date.addZero(this.createDate(this.getView(component, 'endDate'))),
                issueDate: distdlib.date.addZero(this.createDate(this.getView(component, 'issueDate'))),
                dueDate: distdlib.date.addZero(this.createDate(this.getView(component, 'dueDate'))),
            };

            console.log('DEBUG:DiMoalDialogInvoiceHelper: params:', params);
    
            this.disableSubmit(component);

            this.sendRequest(component, 'c.insertEntry', params)
            .then(result => {
                console.log('DEBUG:DiMoalDialogInvoiceHelper: Load:Success:', result);

                if(result.status == 'success') {
                    this.closeModal(component);
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.proccessServerErrors(component, result);
                }      
            })
            .catch(errors => {
                this.enableSubmit(component);
                console.error('DEBUG:DiMoalDialogInvoiceHelper: Load:Error:', errors);
            });
        }        
    },
    updateInvoice: function(component) {
        console.log('DEBUG:DiMoalDialogInvoiceHelper: updateInvoice:', this.canUpdateInvoice(component));
       if(this.canUpdateInvoice(component)) {
            let params = {
                invoiceId: this.getView(component, 'invoiceId'),
                accountId: this.getView(component, 'accountId'),
                startDate: distdlib.date.addZero(this.createDate(this.getView(component, 'startDate'))),
                endDate: distdlib.date.addZero(this.createDate(this.getView(component, 'endDate'))),
                issueDate: distdlib.date.addZero(this.createDate(this.getView(component, 'issueDate'))),
                dueDate: distdlib.date.addZero(this.createDate(this.getView(component, 'dueDate'))),
            };
            
            console.log('DEBUG:DiMoalDialogInvoiceHelper: params:', params);

            this.disableSubmit(component);

            this.sendRequest(component, 'c.updateEntry', params)
            .then(result => {
                console.log('DEBUG:DiMoalDialogInvoiceHelper: Load:Success:', result);

                if(result.status == 'success') {
                    this.closeModal(component);
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.proccessServerErrors(component, result);
                }  
            })
            .catch(errors => {
                this.enableSubmit(component);
                console.error('DEBUG:DiMoalDialogInvoiceHelper: Load:Error:', errors);
            });
        }    
    },
    updateView: function(component, data) {
        console.log('DEBUG: DIModalDialogHelper: updateView:', data.open, data.view,
         data.invoiceId, data.startDate, data.endDate, data.userId, data.contractId, data.accountId);
    
        if(data.open) {
            distdlib.scroll.disable();
        }

        Object.keys(data).forEach(prop => {
            this.setView(component, prop, data[prop]);
        });

        if(data.invoiceNumber) {
            this.invoiceNumber = data.invoiceNumber;
        }

        this.createBasicInformation(component);
        
        let view = this.getView(component, 'view');

        switch(view) {
            case 'edit':
                this.setView(component, 'submitLabel', 'Save');
                break;
            case 'create':
                this.setView(component, 'submitLabel', 'Create');
                break;
        }

        (typeof data.open !== 'undefined') && this.setView(component, 'opened', data.open);
         
        this.load(component);
    },
    getView: function(component, view) {
        return component.get('v.' + view);
    },
    setView: function(component, view, value) {
        return component.set('v.' + view, value);
    },
    canCreateInvoice: function(component) {
        return (this.getView(component, 'accountId') && 
        this.getView(component, 'startDate') &&
        this.getView(component, 'endDate')) && 
        this.getView(component, 'issueDate') &&
        this.getView(component, 'dueDate')
    },
    canUpdateInvoice: function(component) {
        return (!!this.getView(component, 'invoiceId'))
    },
    openModal: function(component) {
        this.cleanClients(component);
        this.resetDates(component);
        this.resetErrors(component);
        this.setView(component, 'opened', true);
        distdlib.scroll.disable();
    },
    closeModal: function(component) {
        this.setView(component, 'opened', false);
        this.cleanClients(component);
        this.resetDates(component);
        this.resetErrors(component);
        this.enableSubmit(component);
        distdlib.scroll.enable();
    },
    selectClient: function(component, accountId) {
      this.setView(component, 'accountId', accountId);
    },
    sendRequest: function(component, methodName, params, category) {
        return new Promise($A.getCallback(function(resolve, reject) {
            let action = component.get(methodName);
            action.setParams(params);

            action.setCallback(self, function(res) {
                let state = res.getState();

                if(state === 'SUCCESS') {
                    let result = {};
                if(typeof category == 'undefined') {
                    result = res.getReturnValue();
                } else {
                    result[category] = res.getReturnValue();
                }           
                    resolve(result);
                } else if(state === 'ERROR') {
                    reject(action.getError());
                } else {
                    reject(action.getError());
                }
            });

            $A.enqueueAction(action);
        }));
    },
    validate: function(component) {  
        console.log('DEBUG:DiMoalDialogInvoiceHelper: valid:', this.getView(component, 'accountId'), this.getView(component, 'startDate'));      
        let errorMessage = this.getView(component, 'errorBlankField');

        let fields = [
            {name: 'accountId', type: 'text', label: 'Client Name', messages: {error: errorMessage}},
            {name: 'startDate', type: 'date', label: 'Start Date', messages: {error: errorMessage}},
            {name: 'endDate', type: 'date', label: 'End Date', messages: {error: errorMessage}},
            {name: 'issueDate', type: 'date', label: 'Issue Date', messages: {error: errorMessage}},
            {name: 'dueDate', type: 'date', label: 'Due Date', messages: {error: errorMessage}},
            {name: 'dateRange', type: 'dateRange', label: 'Start Date', messages: {error: 'Invoice End Date should not be before Start Date'}},
        ];
        
        this.resetErrors(component);
      
        let success = true;

        fields.forEach((field) => {
            if(field.name !== 'dateRange') {
                let value = this.getView(component, field.name);
                let cmp = component.find(field.name);
    
                if(!value) {
                    success = false;
                    this.errors.push(field.label);
                  
                    switch(field.type) {
                        case 'date':                    
                            cmp.set('v.errors', [{message: field.messages.error}]);
                            break;
                        case 'text':
                            cmp.showHelpMessageIfInvalid();
                            break;
                    }
                    //distdlib.date.addZero(this.createDate(item));  
                } else {
                    if(field.type === 'text') {
                        cmp.showHelpMessageIfInvalid();
                    } else {
                        cmp.set('v.errors', []);
                    }
                }
            } else {
                let startDate = this.getView(component, 'startDate');
                let endDate = this.getView(component, 'endDate');
                let startDateCmp = component.find('startDate');

                if(startDate && endDate)  {
                    if(startDate > endDate) {
                        success = false;
                        this.errors.push(field.label);
                        startDateCmp.set('v.errors', [{message: field.messages.error}]);
                    } else {
                        startDateCmp.set('v.errors', []);
                    }
                } 
            }          
        });

        let issueDateCmp = component.find('issueDate');
        let dueDateCmp = component.find('dueDate');

        if(issueDateCmp.get('v.errors').length === 0 && dueDateCmp.get('v.errors').length === 0) {
            let issueDateValue = this.getView(component, 'issueDate');
            let dueDateValue = this.getView(component, 'dueDate');

            issueDateValue = new Date(issueDateValue);
            dueDateValue = new Date(dueDateValue);

            console.log('DEBUG:DiMoalDialogInvoiceHelper: ISSUE:DUE:COMPARE:', dueDateValue , issueDateValue,  dueDateValue < issueDateValue); 

            if(dueDateValue < issueDateValue) {
                dueDateCmp.set("v.errors", [{message: 'Invoice Due Date should not be before Issue Date'}]);
                success = false;
                this.errors.push('Due Date');
            }
        }

        let endDateValue = new Date(this.getView(component, 'endDate'));
        let issueDateValue = new Date(this.getView(component, 'issueDate'));

        if(issueDateCmp.get('v.errors').length === 0 && dueDateCmp.get('v.errors').length === 0 && endDateValue > issueDateValue){
            success = false;
            this.errors.push('Issue Date');
            issueDateCmp.set("v.errors", [{message: 'Invoice Issue Date should not be before End Date'}]);
        }


        console.log('DEBUG:DiMoalDialogInvoiceHelper: success:', success); 
        return success;
    }, 
    resetDates: function(component) {
        component.set('v.startDate', null);
        component.set('v.endDate', null);
        component.set('v.issueDate', null);
        component.set('v.dueDate', null);
    },
    resetErrors: function(component) {
        this.errors = [];
        this.setView(component, 'showError', false);
        this.setView(component, 'errortype', null);
        this.setView(component, 'errorsFields',  this.errors.join(', '));
    },
    createDate: function(value) {
        return (value ? (moment(value).toDate()) : value);
    },
    proccessServerErrors: function(component, result) {
        let errorMessage = '';

        if(result.errors) {
            if(Array.isArray(result.errors.list) && result.errors.list.length > 0) {                        
                let list = result.errors.list;

                list.forEach((error) => {
                    if(distdlib.isObject(error)) {
                        errorMessage += ' ' + error.message;
                    } else {
                        errorMessage += ' ' + error;
                    }
                });
            } else {
                errorMessage = result.errors.message;
            }
        } else {
            errorMessage = 'Something wrong. Please, contact with support';
        }

        this.setView(component, 'showError', true);
        this.setView(component, 'errorsFields',  errorMessage);
        this.enableSubmit(component);
    },
    disableSubmit: function(component) {
        this.setView(component, 'disableSubmit', true);
    },
    enableSubmit: function(component) {
        this.setView(component, 'disableSubmit', false);
    },
})