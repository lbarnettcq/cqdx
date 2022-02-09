({
    id: 'diModalDialogExpenses',
    config: {
        create: {
            title: 'New Expense',
            description: []
        },
        edit: {
            title: 'Edit Expense',
            description: ['']
        },
        details: {
            title: 'View Expense',
            description: ['']
        }
    },
    data: {},
    errors: [],
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:ModalDialog:Create Timesheet:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
        //TODO: Add generate this.data from attributes for compare with new data(change: for insert or update)
        this.createBasicInformation(component);
        this.createTypes(component);

        if(this.showModalDialog(component)) {
            //this.load(component);
        }
    },
    load: function(component) {
        if(this.canLoad()) {
            this.createClientsSows(component);
            this.createTypes(component);
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
    canSendRequest: function(component) {
        let disableSubmit = this.getView(component, 'disableSubmit');
        return (disableSubmit === false);
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
    createClientsSows: function(component) {
        let params = {};

        let timesheetId = this.getView(component, 'timesheetId');

        if(timesheetId) {
            params['timesheetId'] = timesheetId;
        }

        let employeeId = this.getView(component, 'employeeId');

        if(employeeId) {
            params['employeeId'] = employeeId;
        }

        this.sendRequest(component, 'c.getAccounts', params)
        .then((result) => {
            console.log('DEBUG:DiMoalDialogExpensessHelper: Load:Success:', result);
            if(result.status == 'success') {                
                let  selectedClientSow = this.getView(component, 'selectedClientSow');

                if(distdlib.isObject(result.data) && Array.isArray(result.data.list)) {
                    let items = [];
    
                    result.data.list.forEach(account => {
                        if(Array.isArray(account.contracts)) {
                            account.contracts.forEach((contract) => {
                                let contractNumber = contract.contractNumber;
    
                                let item = {
                                    'label': account.name + '/' + contractNumber,
                                    'value': account.id + '_' +  contract.id
                                };

                                if(!distdlib.isNumeric(contractNumber)) {
                                    contractNumber = contract.contractNumber;
                                }

                                items.push(item);                   
                            });
                 
                        }
                    });
    
                    this.setView(component, 'clientsSows', items);                    

                    if(timesheetId) {
                        this.selectClientSow(component, items[0]['value']);
                    }
                }
            } else {
                this.proccessServerErrors(component, result);
            }
        })
        .catch((errors) => {
            console.error('DEBUG:DiMoalDialogExpensessHelper: Load:Error:', errors);
        });
    },
    cleanClientsSows: function(component) {
        this.setView(component, 'clientsSows', []);
        this.setView(component, 'selectedClientSow', null);
        this.setView(component, 'disabledSelectedClientSow', false);
    },
    createTypes: function(component) {
        let items = [
            {
                'label': 'Airfare',
                'value': 'Airfare'
            },
            {
                'label': 'Rental Car',
                'value': 'Rental Car'
            },
            {
                'label': 'Hotel Room',
                'value': 'Hotel Room'
            },
            {
                'label': 'Meal',
                'value': 'Meal'
            }
        ];

        this.setView(component, 'types', items);
    },
    cleanTypes: function(component) {
        this.setView(component, 'types', []);
        this.setView(component, 'selectedType', null);
    },
    submit: function(component) {
        if(this.validate(component)) {
            this.resetErrors(component);
            switch(this.getView(component, 'view')) {            
                case 'create':
                    this.createExpense(component);
                    break;
                case 'edit':
                    console.log('DEBUG:DiMoalDialogExpensesHelper: canUpdate:before:', this.canUpdate(component));
                    this.updateExpense(component);                                 
                    break;
            }
        } else {
            this.setView(component, 'showError', true);
            this.setView(component, 'errorsFields',  'These required fields must be completed: ' + this.errors.join(', '));
        }
    },
    createExpense: function(component) {
        console.log('DEBUG:DiMoalDialogExpensesHelper:createExpense:before:');
        if(this.canSendRequest(component)) {
            let params = this.getParams(component);
            console.log('DEBUG:DiMoalDialogExpensesHelper: params:', params);
    
            this.disableSubmit(component);
    
            this.sendRequest(component, 'c.insertEntry', params)
            .then(result => {
                console.log('DEBUG:DiMoalDialogExpensesHelper: Load:Success:', result);
    
                if(result.status == 'success') {
                    let data = {
                        recordId: result.data.item.Id,
                        action: 'upload'
                    };
    
                    console.log('DEBUG:DiMoalDialogExpensesHelper: Load:Success:upload:files', data);
    
                    let fileUpload = component.find('fileUpload');
                    fileUpload.update(data);
                } else {
                    this.proccessServerErrors(component, result);         
                }         
            })
            .catch((errors) => {
                console.error('DEBUG:DiMoalDialogExpensesHelper: Load:Error:', errors);
                this.enableSubmit(component);
            });   
        }
    },
    updateExpense: function(component) {
        console.log('DEBUG:DiMoalDialogExpensesHelper:updateExpense:before:', this.canUpdate(component),  this.canSendRequest(component));
        if(this.canUpdate(component) && this.canSendRequest(component)) {
            let expense = this.getParams(component);

            let params = {
                expenseEntriesList: [expense]
            };
            
            console.log('DEBUG:DIExpenses:Helper:updateExpense:save:Success:params:', params);
            this.disableSubmit(component);
    
            this.sendRequest(component, 'c.updateEntries', params)
            .then(data => {
                console.log('DEBUG:DIExpenses:Helper:save:Success:', data);
    
                if(data.status == 'success') {
                    let data = {
                        recordId: expense.id,
                        action: 'upload'
                    };
    
                    console.log('DEBUG:DiMoalDialogExpensesHelper:updateExpense:Load:Success:upload:files', data);
    
                    let fileUpload = component.find('fileUpload');
                    fileUpload.update(data);
                } else {
                    this.proccessServerErrors(component, data); 
                }  
            })
            .catch(errors => {
                console.error('DEBUG:DIExpenses:Helper:save:Error:', errors);
                this.enableSubmit(component);
            });
        }
    },
    getParams: function(component) {
        let mapParams = {
            id: 'id',
            expenseDate: 'date',
            amount: 'amount',
            submittalDate: 'submittalDate',
            invoicedAmount: 'invoicedAmount',
            billable: 'billable',
            type: 'selectedType',
            description: 'comment'           
        };        

        let timesheetId = this.getView(component, 'timesheetId');
        let invoiceId = this.getView(component, 'invoiceId');
        let employeeId = this.getView(component, 'employeeId');
        
        let id = this.getView(component, 'id');
        let date = distdlib.date.addZero(this.createDate(this.getView(component, 'date')));
        let amount = this.getView(component, 'amount');
        let submittalDate = distdlib.date.addZero(this.createDate(this.getView(component, 'submittalDate')));
        let invoicedAmount = this.getView(component, 'invoicedAmount');
        let billable = this.getView(component, 'billable');
        let selectedType = this.getView(component, 'selectedType');
        let comment = this.getView(component, 'comment');
        
        let selectedClientSow = this.getView(component, 'selectedClientSow');
        let ids = this.getClientSowIDS(selectedClientSow);

        let accountId = ids[0];
        let contractId = ids[1];

        //let recordId = this.getView(component, 'recordId');

        let expense = {};

        switch(this.getView(component, 'view')) {
            case 'create':
                expense = {           
                    accountId: accountId,
                    contractId: contractId,                
                    expenseDate: date,
                    amount: amount,
                    submittalDate: submittalDate,
                    invoicedAmount: invoicedAmount,
                    billable: billable,
                    type: selectedType,
                    description: comment
                };
                break;
            case 'edit':               
                Object.keys(mapParams).forEach((param) => {
                    let attrValue = this.getView(component, mapParams[param]);

                    if(attrValue != this.data[mapParams[param]]) {                       
                        expense[param] = attrValue;
                    }
                });

                expense['id'] = id;
                
                if(this.data['selectedClientSow'] != selectedClientSow) {
                    ids = this.getClientSowIDS(this.data['selectedClientSow']);
                    (ids[0] != accountId) && (expense['accountId'] = accountId);
                    (ids[1] != contractId) && (expense['contractId'] = contractId);
                }
                break;
        }

        if(timesheetId) {
            expense['timesheetId'] = timesheetId;
        }

        if(invoiceId) {
            expense['invoiceId'] = invoiceId;
        }

        if(employeeId) {
            expense['employeeId'] = employeeId;
        }

        return expense;
    },
    getClientSowIDS: function(selectedClientSow) {
        return selectedClientSow.split('_');
    },
    updateView: function(component, data) {
        console.log('DEBUG: DIModalDialogHelper: updateView:', data.open, data.view, data.date, data.selectedClient, data.comment);
        
        if(data.open) {
            distdlib.scroll.disable();
        }

        Object.keys(data).forEach(prop => {
            console.log('DEBUG: DIModalDialogHelper: updateView:Object.keys(data):', prop, data[prop]);
            if(prop == 'date') {
                data[prop] = distdlib.date.addZero(this.createDate(data[prop]));
            }

            this.data[prop] = data[prop];
            this.setView(component, prop, data[prop]);            
        });

        this.createBasicInformation(component);

        if(data.accountId && data.contractId) {
            let selectedClientSow = data.accountId + '_' + data.contractId;
            this.data['selectedClientSow'] = selectedClientSow;
            this.setView(component, 'selectedClientSow', selectedClientSow);  
            this.selectClientSow(component, selectedClientSow);
            console.log('DEBUG: DIModalDialogHelper: updateView:selectedClientSow:', selectedClientSow);
        } 
        
        let id = this.getView(component, 'id');

        if(id) {
            let data = {
                recordId: id,
                action: 'getFiles'
            };

            let fileUpload = component.find('fileUpload');

            console.log('DEBUG: DIModalDialogHelper: updateView:fileUpload:', fileUpload);

            if(fileUpload) {
                fileUpload.update(data);
            }
        }

        let view = this.getView(component, 'view');

        switch(view) {
            case 'edit':
                this.setView(component, 'submitLabel', 'Save');
                let timesheetId = this.getView(component, 'timesheetId');

                if(timesheetId) {
                    this.setView(component, 'disabledSelectedClientSow', true);
                }
                break;
            case 'create':
                this.resetData(component);
                this.setView(component, 'submitLabel', 'Create');
                break;
            case 'details':
                this.disableFields(component);
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
    toogleSubmit: function(component) {
        if(this.isValid(component)) {
            this.setView(component, 'disableSubmit', false);
        } else {
            this.setView(component, 'disableSubmit', true);
        }
    },
    canUpdate: function(component) {
        let expense = {
            selectedClientSow: this.getView(component, 'selectedClientSow'),
            date: distdlib.date.addZero(this.createDate(this.getView(component, 'date'))),
            amount: this.getView(component, 'amount'),
            submittalDate: distdlib.date.addZero(this.createDate(this.getView(component, 'submittalDate'))),
            invoicedAmount: this.getView(component, 'invoicedAmount'),
            billable: this.getView(component, 'billable'),
            type: this.getView(component, 'selectedType'),
            comment: this.getView(component, 'comment')
        };

        let differentData = false;

        Object.keys(expense).forEach((prop) => {
            console.log('DEBUG: DIModalDialogHelper: canUpdate:prop:' + prop, this.data[prop], expense[prop], this.data[prop] != expense[prop]);
            if(this.data[prop] != expense[prop]) {
                differentData = true;
            }            
        });

        console.log('DEBUG: DIModalDialogHelper: canUpdate:prop:differentData', differentData);
        
        return differentData;
    },
    isValid: function(component) {
        return (this.getView(component, 'selectedClientSow') && 
        this.getView(component, 'date') &&
        this.getView(component, 'amount') &&
        this.getView(component, 'submittalDate') &&
        this.getView(component, 'invoicedAmount')        
        ) &&  
        (this.getView(component, 'comment') && this.getView(component, 'comment') .length > 0);
    },
    openModal: function(component) {
        this.setView(component, 'opened', true);
        distdlib.scroll.disable();
    },
    closeModal: function(component) {
        this.setView(component, 'opened', false);
        this.cleanClientsSows(component);
        this.cleanTypes(component);
        this.resetData(component);
        this.resetErrors(component);
        this.enableFields(component);
        this.enableSubmit(component);
        distdlib.scroll.enable();


        let data = {
            action: 'clear'
        };

        let fileUpload = component.find('fileUpload');
        fileUpload.update(data);
    },
    selectClientSow: function(component, selectedClientSow) {
      this.setView(component, 'selectedClientSow', selectedClientSow);
    },
    selectType: function(component, selectedType) {
        this.setView(component, 'selectedType', selectedType);
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
                    reject(action.getError())
                } else {
                    reject(action.getError())
                }
            });

            $A.enqueueAction(action);
        }));
    },
    validate: function(component) {  
        console.log('DEBUG:DiMoalDialogExpensesHelper: valid:');      
        let errorMessage = this.getView(component, 'errorBlankField');
        this.errors = [];

        let success = true;

        if(!this.getView(component, 'selectedClientSow')) {
            success = false;
            this.errors.push('Client/Sow');
            let selectedClientCmp = component.find("selectedClientSow");
            selectedClientCmp.showHelpMessageIfInvalid();
        }

        if(!this.getView(component, 'date')) {
            success = false;
            this.errors.push('Expense Date');
            let dateCmp = component.find("date");
            dateCmp.set("v.errors", [{message: errorMessage}]);
        }
      
        if(!this.getView(component, 'amount')) {
            success = false;
            this.errors.push('Expense Amount');
            let amountCmp = component.find("amount");
            amountCmp.showHelpMessageIfInvalid();
        }

        if(!this.getView(component, 'submittalDate')) {
            success = false;
            this.errors.push('Submittal Date');
            let submittalDateCmp = component.find("submittalDate");
            submittalDateCmp.set("v.errors", [{message: errorMessage}]);
        }
      
        if(!this.getView(component, 'invoicedAmount')) {
            success = false;
            this.errors.push('Invoiced Amount');
            let invoicedAmountCmp = component.find("invoicedAmount");
            invoicedAmountCmp.showHelpMessageIfInvalid();
        }        

        if(!this.getView(component, 'selectedType')) {
            success = false;
            this.errors.push('Type');
            let selectedTypeCmp = component.find("selectedType");
            selectedTypeCmp.showHelpMessageIfInvalid();
        }

        return success;
    }, 
    resetData: function(component) {
        this.setView(component, 'date', null);
        this.setView(component, 'amount', null);
        this.setView(component, 'submittalDate', null);
        this.setView(component, 'invoicedAmount', null);
        this.setView(component, 'billable', true);
        this.setView(component, 'comment', null);
    },
    resetErrors: function(component) {
        this.errors = [];
        this.setView(component, 'showError', false);
        this.setView(component, 'errorsFields',  this.errors.join(', '));
    },
    proccessServerErrors: function(component, result) {
        this.enableSubmit(component);

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

                    if(error == 'This date is included into timesheet already sent to the client. Please select another Submittal Date.') {
                        let submittalDateCmp = component.find("submittalDate");
                        submittalDateCmp.set("v.errors", [{message: error.message}]);      
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
    },
    notify: function(component, state) {
        let params = {id: this.id};
    
        if(!state) {
          state = 'init';
        }
    
        params['state'] = state;
    
        let changeEvent = component.getEvent('changeEvent');
        changeEvent.setParams({data: params});
        changeEvent.fire();
    },
    createDate: function(value) {
        return moment(value).toDate();
    },
    handleChangeUploadFiles: function(component, data) {
        console.log('DEBUG: DIModalDialogHelper: handleChangeUploadFiles:data:');
 
        if(distdlib.isObject(data['data'])) {
            if(data['data']['action'] === 'uploadedFiles') {
                this.closeModal(component);
                this.notify(component, 'close');
                $A.get('e.force:refreshView').fire();
            }
        }
    },
    disableSubmit: function(component) {
        this.setView(component, 'disableSubmit', true);
    },
    enableSubmit: function(component) {
        this.setView(component, 'disableSubmit', false);
    },
    disableFields: function(component) {
        let fields = [
            'disabledSelectedClientSow',
            'disabledSelectedType',
            'disabledDate',
            'disabledBillable',
            'disabledAmount',
            'disabledComment',
            'disabledSubmittalDate',
            'disabledInvoicedAmount',
            'disabledFileUpload',
            'hideSubmit'
        ];

        fields.forEach(field => {
            this.setView(component, field, true);
        });
    },
    enableFields: function(component) {
        let fields = [
            'disabledSelectedClientSow',
            'disabledSelectedType',
            'disabledDate',
            'disabledBillable',
            'disabledAmount',
            'disabledComment',
            'disabledSubmittalDate',
            'disabledInvoicedAmount',
            'disabledFileUpload',
            'hideSubmit'
        ];

        fields.forEach(field => {
            this.setView(component, field, false);
        });
    }
})