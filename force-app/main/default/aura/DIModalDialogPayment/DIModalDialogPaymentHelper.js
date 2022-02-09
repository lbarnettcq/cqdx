({
    config: {
        create: {
            title: 'New Payment',
            description: ['', '']
        },
        edit: {
            title: 'Edit Payment',
            description: ['']
        },
        send: {
            title: 'Send Payment',
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

        console.log('DEBUG:ModalDialog:Create Payment:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
        this.cleanPaymentTypes(component);
        this.cleanReceivers(component);
        this.resetDates(component);
        this.resetErrors(component);
        this.createBasicInformation(component);

        if(this.showModalDialog(component)) {
            //this.load(component);
        }
    },
    load: function(component) {
        if(this.canLoad()) {
            this.createPaymentTypes(component);            
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
    createPaymentTypes: function(component) {
        let params = {};

        this.sendRequest(component, 'c.getTypes', params)
        .then(result => {
            console.log('DEBUG:DiMoalDialogPaymentsHelper: Load:Success:', result);

            if(result.status == 'success') {
                if(distdlib.isObject(result.data) && Array.isArray(result.data.list)) {
                    let items = [];
    
                    result.data.list.forEach(type => {
                        let item = {
                            'value': type.id,
                            'label': type.label                  
                        };
                        items.push(item);
                    });
    
                    this.setView(component, 'paymentTypes', items);
    
                    this.createReceivers(component);                
                }  
            }         
        })
        .catch((errors) => {
            console.error('DEBUG:DiMoalDialogPaymentsHelper: Load:Error:', errors);
        });
    },
    createReceivers: function(component) {
        let paymentTypeId = this.getView(component, 'paymentTypeId');

        console.log('DEBUG:DiMoalDialogPaymentsHelper: createReceivers:paymentTypeId:', paymentTypeId);

        if(paymentTypeId) {
            let params = {
                paymentType: paymentTypeId
            };

            this.sendRequest(component, 'c.getReceivers', params)
            .then(result => {
                console.log('DEBUG:DiMoalDialogPaymentsHelper: Load:Success:', result);
    
                if(result.status == 'success') {
                    if(distdlib.isObject(result.data) && Array.isArray(result.data.list)) {
                        let items = [];
        
                        result.data.list.forEach(account => {
                            let item = {
                                'label': account.name,
                                'value': account.id
                            };
                            items.push(item);
                        });
        
                        this.setView(component, 'receivers', items);
                    }  
                }
            })
            .catch((errors) => {
                console.error('DEBUG:DiMoalDialogPaymentsHelper: Load:Error:', errors);
            });
        }

        
    },
    cleanPaymentTypes: function(component) {
        this.setView(component, 'paymentTypes', []);
        this.setView(component, 'paymentTypeId', null);
    },
    cleanReceivers: function(component) {
        this.setView(component, 'receivers', []);
        this.setView(component, 'receiverId', null);
    },
    submit: function(component) {
        if(this.validate(component)) {
            this.resetErrors(component);

            switch(this.getView(component, 'view')) {
                case 'edit':
                    this.updatePayment(component);
                    break;
                case 'create':
                    this.createPayment(component);
                    break;
            }
        } else {
            this.setView(component, 'showError', true);
            this.setView(component, 'errortype', 'client');
            this.setView(component, 'errorsFields',  'These required fields must be completed: ' + this.errors.join(', '));
        }
    },
    createPayment: function(component) {
        if(this.canCreatePayment(component)) {            
            let params = {
                paymentType: this.getView(component, 'paymentTypeId'),
                receiverId: this.getView(component, 'receiverId'),
                startDate: distdlib.date.addZero(this.createDate(this.getView(component, 'startDate'))),
                endDate: distdlib.date.addZero(this.createDate(this.getView(component, 'endDate'))),
                paidInvoices: this.getView(component, 'paidInvoices'),
                pendingInvoices: this.getView(component, 'pendingInvoices'),
                pendingInvoicesStartDate: distdlib.date.addZero(this.createDate(this.getView(component, 'pendingInvoicesStartDate'))),
            };

            console.log('DEBUG:DiMoalDialogPaymentHelper: params:', params);
    
            this.disableSubmit(component);

            this.sendRequest(component, 'c.insertEntry', params)
            .then(result => {
                console.log('DEBUG:DiMoalDialogPaymentHelper: Load:Success:', result);

                if(result.status == 'success') {
                    this.closeModal(component);
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.proccessServerErrors(component, result);
                }      
            })
            .catch(errors => {
                this.enableSubmit(component);
                console.error('DEBUG:DiMoalDialogPaymentHelper: Load:Error:', errors);
            });
        }        
    },
    updatePayment: function(component) {
        console.log('DEBUG:DiMoalDialogPaymentHelper: updatePayment:', this.canUpdatePayment(component));
       if(this.canUpdatePayment(component)) {
            //TODO: add only changed parameters
            let params = {
                paymentId: this.getView(component, 'paymentId'),
                paymentType: this.getView(component, 'paymentTypeId'),
                receiverId: this.getView(component, 'receiverId'),
                startDate: distdlib.date.addZero(this.createDate(this.getView(component, 'startDate'))),
                endDate: distdlib.date.addZero(this.createDate(this.getView(component, 'endDate'))),
                paidInvoices: this.getView(component, 'paidInvoices'),
                pendingInvoices: this.getView(component, 'pendingInvoices'),
                pendingInvoicesStartDate: distdlib.date.addZero(this.createDate(this.getView(component, 'pendingInvoicesStartDate'))),
            };
            
            console.log('DEBUG:DiMoalDialogPaymentHelper: params:', params);

            this.disableSubmit(component);

            this.sendRequest(component, 'c.updateEntry', params)
            .then(result => {
                console.log('DEBUG:DiMoalDialogPaymentHelper: Load:Success:', result);

                if(result.status == 'success') {
                    this.closeModal(component);
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.proccessServerErrors(component, result);
                }  
            })
            .catch(errors => {
                this.enableSubmit(component);
                console.error('DEBUG:DiMoalDialogPaymentHelper: Load:Error:', errors);
            });
        }    
    },
    updateView: function(component, data) {
        console.log('DEBUG: DIModalDialogHelper: updateView:', data.open, data.view, data.receiverId);
    
        if(data.open) {
            distdlib.scroll.disable();
        }

        Object.keys(data).forEach(prop => {
            this.setView(component, prop, data[prop]);
        });

        if(data.paymentNumber) {
            this.paymentNumber = data.paymentNumber;
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
    canCreatePayment: function(component) {
        return (this.getView(component, 'paymentTypeId') && 
        this.getView(component, 'receiverId') && 
        this.getView(component, 'startDate') &&
        this.getView(component, 'endDate'));
    },
    canUpdatePayment: function(component) {
        return (!!this.getView(component, 'paymentId'))
    },
    openModal: function(component) {
        this.reset(component);
        this.setView(component, 'opened', true);
        distdlib.scroll.disable();
    },
    closeModal: function(component) {
        this.setView(component, 'opened', false);
        this.reset(component);
        this.enableSubmit(component);
        distdlib.scroll.enable();
    },
    selectPaymentType: function(component, paymentTypeId) {
        this.setView(component, 'paymentTypeId', paymentTypeId);
        this.cleanReceivers(component);
        this.createReceivers(component);
      },
    selectReceiver: function(component, receiverId) {    
      this.setView(component, 'receiverId', receiverId);
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
        console.log('DEBUG:DiMoalDialogPaymentHelper: valid:', this.getView(component, 'receiverId'), this.getView(component, 'startDate'));      
        let errorMessage = this.getView(component, 'errorBlankField');

        let fields = [
            {name: 'paymentTypeId', type: 'text', label: 'Payment Type', messages: {error: errorMessage}},
            {name: 'receiverId', type: 'text', label: 'Account Name', messages: {error: errorMessage}},
            {name: 'startDate', type: 'date', label: 'Start Date', messages: {error: errorMessage}},
            {name: 'endDate', type: 'date', label: 'End Date', messages: {error: errorMessage}},
            {name: 'dateRange', type: 'dateRange', label: 'Start Date', messages: {error: 'The payment end date should not be before the start date'}},
        ];

        if(this.getView(component, 'paymentTypeId') !== 'Expenses Reimbursement') {
            fields.push({name: 'pendingInvoicesStartDate', type: 'date', label: 'Sent Starting from Date', messages: {error: errorMessage}});
        }
        
        this.resetErrors(component);
      
        let success = true;

        fields.forEach(field => {
            if(field.name !== 'dateRange') {
                if((field.name  == 'pendingInvoicesStartDate') && !this.getView(component, 'pendingInvoices')) {
                    return true;
                }
                
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

        console.log('DEBUG:DiMoalDialogPaymentHelper: success:', success); 
        return success;
    }, 
    reset: function(component) {
        this.cleanPaymentTypes(component);
        this.cleanReceivers(component);
        this.resetDates(component);        
        this.setView(component, 'paidInvoices', false);
        this.setView(component, 'pendingInvoices', false);
        this.setView(component, 'pendingInvoicesStartDate', null);
        this.setView(component, 'disabledPaidInvoices', false);
        this.setView(component, 'disabledPendingInvoices', false);
        this.resetErrors(component);
    },
    resetDates: function(component) {
        component.set('v.startDate', null);
        component.set('v.endDate', null);
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

                list.forEach(error => {
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