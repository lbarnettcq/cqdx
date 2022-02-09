({
    config: {
        create: {
            title: 'New Timesheet',
            description: ['Creating a new timesheet will automatically send a notification to an employee', 'working on this SOW']
        },
        edit: {
            title: 'Edit',
            description: ['']
        }
    },
    errors: [],
    timesheetNumber: null,
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
        this.createBasicInformation(component);
        this.createDefaultDateRange(component);

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
            title = ((view === 'edit') ? (this.config[view]['title'] + ' ' + this.timesheetNumber) : this.config[view]['title']);
            description = this.config[view]['description'];
        }

        this.setView(component, 'title', title);
        this.setView(component, 'description', description);
    },
    createDefaultDateRange: function(component, startDate, endDate) {
        let startIndex = 0;
        let endIndex = 6;

        let today = (startDate ?  this.createDate(startDate) : new Date());

        if(startDate) {
            startDate = this.createDate(startDate);         
        } else {
            startDate = this.createDate(today.getTime());
            startDate.setDate(startDate.getDate() - (startDate.getDay() - startIndex));   
        }   
             
        startDate = startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate();

        if(endDate) {
            endDate = this.createDate(endDate);         
        } else {
            endDate = this.createDate(today.getTime());
            endDate.setDate(endDate.getDate() + (endIndex - endDate.getDay())); 
        }        
               
        endDate = endDate.getFullYear() + "-" + (endDate.getMonth() + 1) + "-" + endDate.getDate();

        component.set('v.startDate', startDate);
        component.set('v.endDate', endDate);
    },
    createClients: function(component) {
        let params = {};

        this.sendRequest(component, 'c.getAccounts', params)
        .then((data) => {
            console.log('DEBUG:DiMoalDialogTimesheetsHelper: Load:Success:', data);

            if(distdlib.isObject(data.data) && Array.isArray(data.data.list)) {
                let items = [];

                let selectedClient = this.getView(component, 'selectedClient');
                let existSelectedClient = false;

                data.data.list.forEach(account => {
                    let item = {
                        'label': account.name,
                        'value': account.id
                    };
                    items.push(item);

                    if(selectedClient === item['value']) {
                        existSelectedClient = true;
                    }
                });

                this.setView(component, 'clients', items);
                
                if(existSelectedClient) {
                    this.createEmployees(component, selectedClient);
                } else {
                    this.setView(component, 'selectedClient', null);
                }
            }  
        })
        .catch((errors) => {
            console.error('DEBUG:DiMoalDialogTimesheetsHelper: Load:Error:', errors);
        });
    },
    cleanClients: function(component) {
        this.setView(component, 'clients', []);
        this.setView(component, 'selectedClient', null);
    },
    createEmployees: function(component, id) {
        let params = {
            accountId: id
        };

        this.sendRequest(component, 'c.getContractsAndUsersListByAccount', params)
        .then((data) => {
            console.log('DEBUG:DiMoalDialogTimesheetHelper: Load:Success:', data);

            if(distdlib.isObject(data.data) && Array.isArray(data.data.list)) {
                let items = [];

                let selectedEmployee = this.getView(component, 'selectedEmployee');
                let existSelectedEmployee = false;

                data.data.list.forEach(employee => {
                    let contractNumber = employee.contractNumber;

                    if(!distdlib.isNumeric(contractNumber)) {
                        contractNumber = employee.contractNumber;
                    }

                    //contractNumber: "00000100"
                    //contractId: "a0156000001cojYAAQ"
                    //userId: "00556000003H0IZAA0"
                    //userName: "User User"

                    //00556000003H0IZAA0
                    //contractId: "80056000000Cpf5AAC"

                    let item = {
                        'label': employee.userName + '/' + contractNumber,
                        'value': employee.userId + '_' + employee.contractId 
                    };
                    items.push(item);

                    if(selectedEmployee === item['value']) {
                        existSelectedEmployee = true;
                    }
                });

                if(!existSelectedEmployee) {
                    this.setView(component, 'selectedEmployee', null);
                }
        
                this.setView(component, 'employees', items);
            }      
        })
        .catch((errors) => {
            console.error('DEBUG:DiMoalDialogTimesheetHelper: Load:Error:', errors);
        });
    },
    cleanEmployees: function(component) {
        this.setView(component, 'employees', []);
        this.setView(component, 'selectedEmployee', null);
    },
    submit: function(component) {
        if(this.validate(component)) {
            this.resetErrors(component);

            switch(this.getView(component, 'view')) {
                case 'edit':
                    this.updateTimesheet(component);
                    break;
                case 'create':
                    this.createTimesheet(component);
                    break;
            }
        } else {
            this.setView(component, 'showError', true);
            this.setView(component, 'errorsFields',  'These required fields must be completed: ' + this.errors.join(', '));
        }
    },
    createTimesheet: function(component) {
        if(this.canCreateTimesheet(component)) {
            let selectedEmployee = this.getView(component, 'selectedEmployee');
            let employee = selectedEmployee.split('_');

            let userId = employee[0];
            let contractId = employee[1];
            
            let params = {
                userId: userId,
                contractId: contractId,
                startDate: distdlib.date.addZero(this.createDate(this.getView(component, 'startDate'))),
                endDate: distdlib.date.addZero(this.createDate(this.getView(component, 'endDate')))
            };

            console.log('DEBUG:DiMoalDialogTimesheetHelper: params:', params);
    
            this.disableSubmit(component);

            this.sendRequest(component, 'c.insertEntry', params)
            .then((result) => {
                console.log('DEBUG:DiMoalDialogTimesheetHelper: Load:Success:', result);

                if(result.status == 'success') {
                    this.closeModal(component);
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.proccessServerErrors(component, result);       
                }      
            })
            .catch((errors) => {
                console.error('DEBUG:DiMoalDialogTimesheetHelper: Load:Error:', errors);
                this.enableSubmit(component);
            });
        }        
    },
    updateTimesheet: function(component) {
        if(this.canUpdateTimesheet(component)) {
            let timesheetId = this.getView(component, 'timesheetId');
            let selectedEmployee = this.getView(component, 'selectedEmployee');
            let employee = selectedEmployee.split('_');

            let userId = employee[0];
            let contractId = employee[1];
            
            let params = {
                timesheetId: timesheetId,
                userId: userId,
                contractId: contractId,
                startDate: distdlib.date.addZero(this.createDate(this.getView(component, 'startDate'))),
                endDate: distdlib.date.addZero(this.createDate(this.getView(component, 'endDate')))
            };
            
            console.log('DEBUG:DiMoalDialogTimesheetHelper: params:', params);

            this.disableSubmit(component);

            this.sendRequest(component, 'c.updateEntry', params)
            .then((result) => {
                console.log('DEBUG:DiMoalDialogTimesheetHelper: Load:Success:', result);

                if(result.status == 'success') {
                    this.closeModal(component);
                    $A.get('e.force:refreshView').fire();
                }   else {
                    this.proccessServerErrors(component, result);
                }       
            })
            .catch((errors) => {
                console.error('DEBUG:DiMoalDialogTimesheetHelper: Load:Error:', errors);
                this.enableSubmit(component);
            });
        }        
    },
    updateView: function(component, data) {
        console.log('DEBUG: DIModalDialogHelper: updateView:', data.open, data.view, data.timesheetId, data.startDate, data.endDate, data.userId, data.contractId, data.accountId);
    
        if(data.open) {
            distdlib.scroll.disable();
        }

        Object.keys(data).forEach(prop => {
            this.setView(component, prop, data[prop]);
        });

        if(data.timesheetNumber) {
            this.timesheetNumber = data.timesheetNumber;
        }
        
        /*view: view,
        accountId: this.timesheet.accountId,
        userId: this.timesheet.userId,  
        contractId: this.timesheet.contractId,
        startDate: this.timesheet.startDate,
        endDate: this.timesheet.endDate*/

        this.createBasicInformation(component);

        if(data.startDate && data.endDate) {
            this.createDefaultDateRange(component, data.startDate, data.endDate);
        }

        if(data.userId && data.contractId) {
            let employeeId = data.userId + '_' + data.contractId;
            this.selectEmployee(component, employeeId);
        }

        (data.accountId) && this.selectClient(component, data.accountId);
        
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
    canCreateTimesheet: function(component) {
        return (this.getView(component, 'selectedClient') && 
        this.getView(component, 'selectedEmployee') &&
        this.getView(component, 'startDate') &&
        this.getView(component, 'endDate'))
    },
    canUpdateTimesheet: function(component) {
        return (!!this.getView(component, 'timesheetId'))
    },
    openModal: function(component) {
        this.createDefaultDateRange(component);
        this.setView(component, 'opened', true);
        distdlib.scroll.disable();
    },
    closeModal: function(component) {
        this.setView(component, 'opened', false);
        this.cleanClients(component);
        this.cleanEmployees(component);
        this.createDefaultDateRange(component);
        this.resetErrors(component);
        this.enableSubmit(component);
        distdlib.scroll.enable();
    },
    selectClient: function(component, selectedClient) {
      this.setView(component, 'selectedClient', selectedClient);
      this.createEmployees(component, selectedClient);
    },
    selectEmployee: function(component, selectedEmployee) {
        this.setView(component, 'selectedEmployee', selectedEmployee);
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
        console.log('DEBUG:DiMoalDialogTimesheetHelper: valid:', this.getView(component, 'selectedClient'));      
        let errorMessage = this.getView(component, 'errorBlankField');
        this.errors = [];

        let success = true;

        if(!this.getView(component, 'selectedClient')) {
            success = false;
            this.errors.push('Client Name');
            let selectedClientCmp = component.find("selectedClient");
            //selectedClientCmp.set('v.validity', {valid: false, badInput: true});
            //selectedClientCmp.set("v.showError", true);
           // selectedClientCmp.set("v.errorMessage", "XYZ");
            selectedClientCmp.showHelpMessageIfInvalid();
            //selectedClientCmp.set('v.errors', [{message: errorMessage}]);
            //selectedClientCmp.set('v.validity', {valid: false, badInput: true});
            //selectedClientCmp.showHelpMessageIfInvalid();
        }

        if(!this.getView(component, 'selectedEmployee')) {
            success = false;
            this.errors.push('Employee/SOW');
            let selectedEmployeeCmp = component.find("selectedEmployee");
            selectedEmployeeCmp.showHelpMessageIfInvalid();
            //selectedEmployeeCmp.set('v.errors', [{message: errorMessage}]);
        }
      
        let startDateCmp = component.find("startDate");
        let startDateValid = true;
        let startDate = distdlib.date.addZero(this.createDate(this.getView(component, 'startDate')));
        if(!startDate || startDate === 'NaN-aN-aN') {
            success = false;
            startDateValid = false;
            this.errors.push('Start Date');
            startDateCmp.set("v.errors", [{message: errorMessage}]);
        } else {
            startDateCmp.set("v.errors", null);
        }
      
        let endDateCmp = component.find("endDate");
        let endDateValid = true;
        let endDate = distdlib.date.addZero(this.createDate(this.getView(component, 'endDate')));
        if(!endDate || endDate === 'NaN-aN-aN') {
            success = false;
            endDateValid = false;
            this.errors.push('End Date');            
            endDateCmp.set("v.errors", [{message: errorMessage}]);
        } else {
            endDateCmp.set("v.errors", null);
        }

        console.log('DEBUG:DiMoalDialogTimesheetHelper: valid:check:', startDate, endDate, startDate > endDate);
        if(startDateValid && endDateValid && startDate > endDate) {
            success = false;
            this.errors.push('Start date');
            let startDateCmp = component.find("startDate");
            startDateCmp.set("v.errors", [{message: 'Timesheet End Date should not be before Start Date.'}]);
        }

        return success;
    }, 
    resetErrors: function(component) {
        this.errors = [];
        this.setView(component, 'showError', false);
        this.setView(component, 'errorsFields',  this.errors.join(', '));
    },
    createDate: function(value) {
        return moment(value).toDate();
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