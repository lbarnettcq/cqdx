({//Formatting dates: https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/js_cb_format_dates.htm
    id: 'diExpensesContainer',
    data: {    },
    childsData: [],
    modalDialog: {
        id: null,
        action: null,
        expenseId: null
    },
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:DIExpensesContainer:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
        this.createColumns(component);
        this.showLoadIndicator(component, true, 'No items to display.');
        
        if(this.canLoad(component)) {
            this.load(component);
        } else {
            this.notify(component, 'init');  
        } 
    },
    load: function(component) {
        console.log('DEBUG:DIExpensesContainer:Helperload:');
        this.resetTable(component);

        /* test */

        if(this.canLoad(component)) {
            console.log('DEBUG:DIExpensesContainer:Helper:load:canLoad:', this.getContractsIds(component));

            this.showLoadIndicator(component, true);

            let params = {};

            let timesheetId = this.getView(component, 'timesheetId');
            let invoiceId = this.getView(component, 'invoiceId');
            let paymentId = this.getView(component, 'paymentId');

            if(timesheetId) {
                params['timesheetId'] = timesheetId;
            } else if(invoiceId) {
                params['invoiceId'] = invoiceId;
            } else if(paymentId) {
                params['paymentId'] = paymentId;
            } else {
                params['contractsIds'] = this.getContractsIds(component);
    
                let startDate = this.getView(component, 'startDate');
                let endDate = this.getView(component, 'endDate');
    
                if(startDate) {
                    params['startDate'] = distdlib.date.addZero(this.createDate(startDate));
                }
    
                if(endDate) {
                    params['endDate'] = distdlib.date.addZero(this.createDate(endDate));
                }

                let employeeId = this.getView(component, 'employeeId');

                if(employeeId) {
                    params['employeeId'] = employeeId;
                }
            }
            
            console.log('DEBUG:DIExpensesContainer:Helper:Load:Params:', params);

            this.sendRequest(component, 'c.getList', params)
            .then((result) => {
                console.log('DEBUG:DIExpensesContainer:Helper:Load:Success:', result);
                this.showLoadIndicator(component, false);
                if(result.status == 'success') {
                    if(Array.isArray(result.data.list) && result.data.list.length > 0) {                    
                        this.createRows(component, result.data.list);
                        this.showLoadIndicator(component, false);
    
                        if(this.getView(component, 'timesheetId') || 
                            this.getView(component, 'invoiceId') || 
                            this.getView(component, 'paymentId')) {
                            this.notify(component, 'init');
                        }
                    } else {
                        this.showLoadIndicator(component, true, 'There are no expenses in this time period for this user');
                    }
                } else {
                    this.proccessServerErrors(component, result);
                }
            })
            .catch((errors) => {
                console.error('DEBUG:DIExpensesContainer:Helper:Load:Error:', errors);
                this.showLoadIndicator(component, true, 'Data can not load. Please, try later...');
            });

        } else {
            this.showLoadIndicator(component, true, 'Data can not load. User or date range are absent');
        }
    },
    createColumns: function(component) {
        let rowActions = this.getRowActions.bind(this, component);
        
        let configColumns = [
            {label: '', fieldName: 'approved',
                cellAttributes: { 
                    class: {
                        'fieldName': 'showClass'
                    },
                    iconName: {fieldName: 'displayIconName'}, 
                    iconLabel: {fieldName: 'displayIconNameLabel'}, 
                    iconPosition: 'right' 
                },
                options: {enable: true},
                fixedWidth: 40,
                initialWidth: 40,
            },
            {
                label: 'Submittal Date', 
                fieldName: 'submittalDate', 
                type: 'date-local',
                typeAttributes: {
                    month: '2-digit',
                    day: '2-digit',
                    year: 'numeric'
                },
                cellAttributes: {
                    class: 'time-period'
                },
                sortable: false,
                options: {enable: true}
            },
            {
                label: 'Expense Date', 
                fieldName: 'date', 
                type: 'date-local',
                typeAttributes: {
                    month: '2-digit',
                    day: '2-digit',
                    year: 'numeric'
                },
                cellAttributes: {
                    class: 'time-period'
                },
                sortable: false,
                options: {enable: true}
            },
            {label: 'Client/SOW', fieldName: 'client', type: 'text', sortable:false, 
                typeAttributes: {
                    label: {fieldName: 'userNameLabel'}
                },
                options: {enable: true}
            },
            {label: 'SOW/Employee', fieldName: 'sowEmployee', type: 'text', sortable:false, 
                typeAttributes: {
                    label: {fieldName: 'sowEmployee'}
                },
                options: {enable: false}
            },
            {label: 'Type', fieldName: 'type', type: 'text', sortable:false, 
                typeAttributes: {
                    label: {fieldName: 'type'}
                },
                options: {enable: true}
            },
            {label: 'Description', fieldName: 'description', type: 'text', sortable: false, 
                typeAttributes: {
                    label: {fieldName: ''}
                },
                options: {enable: true}
            },
            {
                label: 'Billable', 
                fieldName: 'billable', 
                type: 'boolean', 
                sortable: false,
                options: {enable: true}
            },  
            {label: 'Expense Amount', fieldName: 'amount', type: 'currency', 
                cellAttributes: { 
                    class: 'di-amount'
                },
                sortable: false,
                typeAttributes: {
                    maximumFractionDigits: '2'
                },
                options: {enable: true}               
            },
            {label: 'Invoiced Amount', fieldName: 'invoicedAmount', type: 'currency', 
                cellAttributes: { 
                    class: 'di-amount'
                },
                sortable: false,
                typeAttributes: {
                    maximumFractionDigits: '2'
                },
                options: {enable: true}               
            },   
            {
                label: 'Attachment', 
                fieldName: 'haveAttachments', 
                type: 'boolean', 
                sortable: false,
                options: {enable: true}
            },                                           
        ];
        
        let columns = [];

        let optionsColumns = [];

        let options = this.getView(component, 'options');

        if(options && options.columns) {
            optionsColumns = options.columns;
        }
        
        configColumns.forEach((configColumn) => {
            let enableColumn = configColumn.options.enable;

            optionsColumns.forEach((optionColumn) => {
                if(configColumn.fieldName == optionColumn.fieldName) {
                    enableColumn = optionColumn.enable;
                }
            });

            if(enableColumn) {
                columns.push(configColumn);
            }
        });

        columns.push({type: 'action', typeAttributes: {rowActions: rowActions}});
        
        this.setView(component, 'columns', columns);
    },
    createRows: function(component, data) {
        let rows = [];

        data.forEach((item) => {
            let startDate = this.getView(component, 'startDate');
            let endDate = this.getView(component, 'endDate');

            if(startDate && endDate) {
                startDate = this.createDate(startDate);
                endDate = this.createDate(endDate);
            } else {
                startDate = -Infinity;
                endDate = Infinity;
            }

            let currentDate = this.createDate(item.date);
            let submittalDate = this.createDate(item.submittalDate);

            if(startDate <= submittalDate && submittalDate <= endDate) {
                let row = {
                    id: item.id,
                    date: item.date,
                    //dateLabel: this.addZero((currentDate.getMonth() + 1)) + '/' + (currentDate.getDate()) + '/' + currentDate.getFullYear(),
                    client: (item.accountName + '/' + item.contractNumber),                    
                    type: item.type, 
                    description: item.description,
                    approved: item.approved,
                    billable: item.billable,
                    amount: ('' + distdlib.math.roundTo2Digit(item.amount)),
                    submittalDate: item.submittalDate, 
                    invoicedAmount: ('' + distdlib.math.roundTo2Digit(item.invoicedAmount)),
                    accountId: item.accountId,
                    contractId: item.contractId,
                    haveAttachments: item.haveAttachments
                };

                if(item.contractNumber && item.userName) {
                    let contractNumber = (distdlib.isNumber(item.contractNumber) ? (+item.contractNumber) : item.contractNumber);                    
                    row['sowEmployee'] = contractNumber + '/' + item.userName
                }

                if(row.approved) {
                    row.displayIconName = 'utility:lock';
                } else {
                    row.displayIconName = '';
                }
                
                row.showClass = '';                   
                row.displayIconNameLabel = '';

                /*<lightning:icon iconName="utility:lock" alternative-text="lock" size="x-small"></lightning:icon>*/
                
                rows.push(row);
            }

        });

        component.set('v.data', rows);
    },
    canLoad: function(component) {
        console.log('DEBUG:DIExpensesContainer:canLoad:', this.existContractsIds(component), this.getView(component, 'contractsIds'));
        return (
            (this.existContractsIds(component)) || 
            this.getView(component, 'timesheetId') || 
            this.getView(component, 'invoiceId') ||
            this.getView(component, 'paymentId')
        );
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
    getRowActions: function (component, row, doneCallback) {
        console.log('DEBUG:getRowActions', row);

        let actions = null;

        if(!row.approved) {
            actions = [
                {label: 'Edit', name: 'edit'},
                {label: 'Details', name: 'details'},
                {label: 'Delete', name: 'delete'},
            ];
        } else {
            actions = [
                {label: 'Details', name: 'details'},
            ]
        }

        doneCallback(actions);
    },
    notify: function(component, state, data) {
        let params = {id: this.id, dependencies: this.getArrayDependencies(component)};
    
        if(!state) {
          state = 'init'
        }
    
        params['state'] = state;
    
        if(distdlib.isObject(data)) {
          params['data'] = data;
        }
    
        console.log('DEBUG:DiExpensesContainer:notify', params);

        let changeEvent = component.getEvent('changeEvent');    
        changeEvent.setParams({data: params});
        changeEvent.fire();
    },
    getArrayDependencies: function(component) {        
        let dependencies = this.getView(component, 'dependencies');

        console.log('DEBUG:DIExpensesContainer:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DIExpensesContainer:Helper:init:dependencies:array:', dependencies);
            return dependencies;
        }

        return [];
    },
    setContractsIds: function(component, ids) {
        console.log('DEBUG:DIExpensesContainer:Helper:setContractsIds:ids', Array.isArray(ids), ids);
        if(Array.isArray(ids) || distdlib.isObject(ids)) {
            let contractsIds = [];

            Object.keys(ids).forEach(key => {
                contractsIds.push(ids[key]);
                console.log('DEBUG:DIExpensesContainer:Helper:setContractsIds:item', ids[key]);
            });     

            this.setView(component, 'contractsIds', contractsIds)
        }
    },
    getContractsIds: function(component) {
        return this.getView(component, 'contractsIds');
    },
    existContractsIds: function(component) {
        return (this.getView(component, 'contractsIds').length > 0);
    },
    showLoadIndicator: function(component, show, description) {
        let message = null;

        if(show) {
            message = {
                show: true,
                description: 'Data is loaded... Please wait.'
            };
        } else {
            message = {
                show: false,
                description: ''
            };
        }

        (description) && (message.description = description);

        this.setView(component, 'message', message);
    },
    update: function (component, lData) {
        console.log('DEBUG:DIExpensesHelper:Update:init', lData);
        this.childsData.push(lData);
        console.log('DEBUG:DIExpensesHelper:Update:Init:after');
        if(this.isReady(component)) {
            this.childsData.forEach(data => {               
                if(distdlib.isObject(data) && distdlib.isObject(data.data)) {
                    console.log('DEBUG:DIExpensesHelper:Update', data.id);
                    switch(data.id) {
                        case 'diExpensesContainer': 
                            console.log('DEBUG:DIExpensesHelper:Update:Params:diExpensesContainer', data.id,  data.state, data.data); 
                            if(data.data['diMenu'] && distdlib.isObject(data.data['diMenu']['data'])) {
                                let menuData = data.data['diMenu']['data'];                             
                                this.setContractsIds(component, menuData['list']);                                                                           
                            }      
                            
                            if(data.data['diDatePicker'] && distdlib.isObject(data.data['diDatePicker']['data'])) {                           
                                let datePickerData = data.data['diDatePicker']['data'];
                                this.setView(component, 'startDate', datePickerData.startDate);            
                                this.setView(component, 'endDate', datePickerData.endDate);                                                 
                            }                      
                            break;          
                        case 'diMenu':
                            console.log('DEBUG:DIExpensesHelper:Update:Params:diMenu', data.data['list']);
                            this.setContractsIds(component, data.data['list']);
                            data.data.startDate && this.setView(component, 'startDate', data.data.startDate);            
                            data.data.endDate && this.setView(component, 'endDate', data.data.endDate);
                            break;
                        case 'diDatePicker':
                            if(data.data.startDate && data.data.endDate) {
                                this.setView(component, 'startDate', data.data.startDate);            
                                this.setView(component, 'endDate', data.data.endDate);
                            }
                            break;                 
                        default: {
                            if(data.data.employeeId) {
                                this.setView(component, 'employeeId', data.data.employeeId);
                            }

                            if(data.data.startDate && data.data.endDate) {
                                this.setView(component, 'startDate', data.data.startDate);            
                                this.setView(component, 'endDate', data.data.endDate);
                            }

                            if(data.data.contractIds) {                          
                                this.setContractsIds(component, data.data.contractIds);                                                                           
                            }     
                            
                            console.log('DEBUG:DIExpensesHelper:Update:Init:default', data.data);
                        }
                    }

                    this.updateData(component); 
                }
            }); 

            this.childsData.length = 0;
        }
    },
    updateData: function(component) {
        console.log('Debug:DIExpensesContainer:Helper:update:data:check:', this.existContractsIds(component), this.getView(component, 'startDate'), this.getView(component, 'endDate'));
        if(this.existContractsIds(component) && this.getView(component, 'startDate') && this.getView(component, 'endDate')) {
            console.log('Debug:DIExpensesContainer:Helper:update:data:before:');
            this.load(component);       
        }
    },
    isReady: function(component) {
        return this.getView(component, 'stateProcess') === 'ready';
    },
    setView: function(component, view, value) {
        return component.set('v.' + view, value);
    },
    getView: function(component, field) {
        return component.get('v.' + field);
    },
    showModalDialog: function(component, event, type) {
        console.log('DEBUG:DIExpensesContainer:Helper:showModalDialog', type, this.getView(component, 'timesheetId'));
        let modalDialog = null;
        let data = null;
        let row = null;
        let timesheetId = this.getView(component, 'timesheetId');
        let invoiceId = this.getView(component, 'invoiceId');
        let employeeId = this.getView(component, 'employeeId');
        let paymentId = this.getView(component, 'paymentId');

        switch(type) {
            case 'create':
                modalDialog = component.find('diModalDialogExpenses');

                data = {
                    open: true,
                    view: type,
                }

                if(timesheetId) {
                    data['timesheetId'] = timesheetId;
                }

                if(invoiceId) {
                    data['invoiceId'] = invoiceId;
                }

                if(employeeId) {
                    data['employeeId'] = employeeId;
                }

                if(paymentId) {
                    data['paymentId'] = paymentId;
                }

                modalDialog.update(data);
                break;
            case 'delete':
                console.log('DEBUG:DIExpensesContainer:Helper:showModalDialog:update:before', type);
                modalDialog = component.find('diModalDialogConfirm');

                row = event.getParam('row');

                if(row.id) {
                    this.modalDialog.id = 'diModalDialogConfirm';
                    this.modalDialog.action = type;
                    this.modalDialog.expenseId = row.id;

                    data = {
                        open: true,
                        view: type,
                        title: 'Delete Expense',
                        name: 'this Expense'
                    };

                    modalDialog.update(data); 
                }
                break;
            case 'details':
            case 'edit':
                modalDialog = component.find('diModalDialogExpenses');

                row = event.getParam('row');

                if(row.id) {
                    //let recordId = this.getView(component, 'recordId');

                    data = {
                        open: true,
                        view: type,                        
                        id: row.id,
                        accountId: row.accountId,
                        contractId: row.contractId,
                        amount: row.amount,
                        date: row.date,
                        invoicedAmount: row.invoicedAmount,
                        submittalDate: row.submittalDate,
                        billable: row.billable,
                        selectedType: row.type,
                        comment: row.description,
                    };

                    if(timesheetId) {
                        data['timesheetId'] = timesheetId;
                    }

                    if(invoiceId) {
                        data['invoiceId'] = invoiceId;
                    }

                    if(employeeId) {
                        data['employeeId'] = employeeId;
                    }
                    
                    if(paymentId) {
                        data['paymentId'] = paymentId;
                    }

                    modalDialog.update(data);
                }
                break;
        }
    },
    resetTable: function(component) {
        component.set('v.data', []);
    },
    handleChange: function(component, data) {
        switch(data.id) {
            case 'diModalDialogExpenses':
                if(data.state === 'close') {
                    this.load(component);
                }
                break;
            case 'diModalDialogConfirm':
                if(this.modalDialog.id == 'diModalDialogConfirm' && data['action'] == 'submit') {
                    switch(this.modalDialog.action) {
                        case 'delete':
                            console.log('DEBUG:DIExpensesContainer:Helper:handleChange:action', this.modalDialog.action);      
                            this.modalDialog.expenseId && this[this.modalDialog.action + 'Expense'](component, this.modalDialog.expenseId);
                            break;
                        default: {
                            this.clearModalDialogData();
                        }
                    }                           
                } else {
                    this.clearModalDialogData();
                }
                break;
        }
        
    },
    deleteExpense: function(component, id) {
        console.log('DEBUG:DIExpensesContainer:Helper:deleteExpense');
        
        let params = {
            entryId: id
        };

        console.log('DEBUG:DIExpensesContainer:Helper:deleteExpense: params:', params);

        this.sendRequest(component, 'c.deleteEntry', params)
        .then((data) => {
            console.log('DEBUG:DIExpensesContainer:Helper:deleteExpense: Load:Success:', data);
            this.clearModalDialogData(); 
            this.load(component);
            //this.updateData(component);            
        })
        .catch((errors) => {
            console.error('DEBUG:DIExpensesContainer:Helper:deleteExpense: Load:Error:', errors);
        }); 
    },
    createDate: function(value) {
        return moment(value).toDate();
    },
    clearModalDialogData: function() {
        this.modalDialog.id = null;
        this.modalDialog.action = null;
    },
    proccessServerErrors: function(component, result) {
        if(result.errors) {
            if(Array.isArray(result.errors.list) && result.errors.list.length > 0) {
                let message = '';
                let list = result.errors.list;

                list.forEach((error) => {
                    if(distdlib.isObject(error)) {
                        message += ' ' + error.message;
                    } else {
                        message += ' ' + error;
                    }
                });
                this.showLoadIndicator(component, true, message);
            } else {
                this.showLoadIndicator(component, true, result.errors.message);
            }
        } else {
            this.showLoadIndicator(component, true, 'Something wrong. Please, contact with support');
        }
    }
})