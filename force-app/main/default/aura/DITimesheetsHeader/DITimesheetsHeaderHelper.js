({
    id: 'diTimesheetsHeader',
    delimiter: ' • ',
    data: [],
    modalDialog: {
        id: null,
        action: null
    },
    loadedTimesheetInformation: false,
    timesheet: null,
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:TimesheetsHeader:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
        console.log('DEBUG:TimesheetsHeader:Helper:init');
        this.updatePanelInformation(component);
        this.notify(component, 'init');         
    },
    updatePanelInformation : function(component) {
        console.log('DEBUG:TimesheetsHeader:Helper:updatePanelInformation:');

        let timesheetId = this.getView(component, 'timesheetId');

        if(timesheetId) {
            let params = {
                timesheetId: timesheetId
            };

            this.sendRequest(component, 'c.getInformation', params)
            .then((data) => {
                console.log('DEBUG:TimesheetsHeader: Load:Success: ', data);     
                if(distdlib.isObject(data.data) && distdlib.isObject(data.data.item)) {
                    this.timesheet = data.data.item;

                    let timesheetNumber = 'Undefined';
                    if(this.timesheet.timesheetNumber) {
                        timesheetNumber = this.timesheet.timesheetNumber;
                    }

                    this.setView(component, 'details', timesheetNumber);

                    let lastModified = this.getView(component, 'lastModified');
                    if(this.timesheet.lastModifiedDate) { 
                        lastModified = moment(this.timesheet.lastModifiedDate).format('MM/DD/YYYY hh:mm A');
                    }
        
                    console.log('DEBUG:TimesheetsHeader: Load:Success:status:', this.timesheet.status);  
                    if(this.timesheet.status) {
                        this.timesheet.status = this.timesheet.status.toLowerCase();
                    }

                    this.setView(component, 'status', this.timesheet.status);

                    this.setView(component, 'panelInformation', this.createInformation(null, null, lastModified));

                    this.setView(component, 'loadedTimesheetInformation', true);
                }                
            })
            .catch((errors) => {
                console.error('DEBUG:TimesheetsHeader: Load:Error: ', errors);
            });
        } else {
            let totalNumberRows = this.getView(component, 'totalNumberRows');
            let sortedBy = this.getView(component, 'sortedBy');
            let lastModified = this.getView(component, 'lastModified');
            this.setView(component, 'panelInformation', this.createInformation(totalNumberRows, sortedBy, lastModified));
        }
    },
    createInformation: function(totalNumberRows, sortedBy, lastModified) {
        let panelInformation = [];
        
        if(totalNumberRows) {
            let totalNumberRowsTitle = 'Items';

            if(totalNumberRows == 1) {
                totalNumberRowsTitle = 'Item';
            }

            panelInformation.push(totalNumberRows + ' ' + totalNumberRowsTitle);
        }

        if(sortedBy) {
            panelInformation.push('Sorted by ' + sortedBy);
        }

        if(lastModified) {
            panelInformation.push('Updated ' + lastModified);
        }

        return panelInformation.join(this.delimiter);
    },
    updateViewTotalNumberRows: function(component, total) {
        this.setView(component, 'totalNumberRows', total);
    },
    updateViewSortedBy: function(component, sortedBy) {
        this.setView(component, 'sortedBy', sortedBy);
    },
    updateViewLastModified: function(component, lastModified) {
        this.setView(component, 'lastModified', lastModified);
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
    
        let changeEvent = component.getEvent('changeEvent');    
        changeEvent.setParams({data: params});
        changeEvent.fire();
    },
    getArrayDependencies: function(component) {        
        let dependencies = this.getView(component, 'dependencies');

        console.log('DEBUG:DITimesheetsHeader:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DITimesheetsHeader:Helper:init:dependencies:array:', dependencies);
            return dependencies;
        }

        return [];
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
    update: function(component, data) {
        this.data.push(data);
        
        if(this.isReady(component)) {
            this.data.forEach(item => {                
                if(distdlib.isObject(data) && distdlib.isObject(data.data)) {
                    Object.keys(data.data).forEach(fieldName => {
                        this.setView(component, fieldName, data.data[fieldName]);
                    });
        
                    this.updatePanelInformation(component);
                }
            });

            this.data.length = 0;
        }
    },
    isReady: function(component) {
        return this.getView(component, 'stateProcess') === 'ready';
    },
    getView: function(component, view) {
        return component.get('v.' + view);
    },
    setView: function(component, view, value) {
        return component.set('v.' + view, value);
    },
    showModalDialog: function(component, event, type) {
        console.log('DEBUG:TimesheetsTable:Helper:showModalDialog', type);
        let modalDialog = null;
        let data = null;

        switch(type) {
            case 'approve':
            case 'send':
            case 'delete':
                console.log('DEBUG:TimesheetsTable:Helper:showModalDialog:update:before', type);
                modalDialog = component.find('diModalDialogConfirm');

                data = {
                    open: true,
                    view: type,
                    name: this.getView(component, 'details'),
                    showHint: ((type == 'delete') ? false : !this.timesheet.approvedEntries)
                }

                this.modalDialog.id = 'diModalDialogConfirm';
                this.modalDialog.action = type;
                console.log('DEBUG:TimesheetsTable:Helper:showModalDialog:update', type);
                modalDialog.update(data); 
                break;
            case 'edit':
                modalDialog = component.find('diModalDialogTimesheet');

                data = {
                    open: true,
                    view: type,
                    accountId: this.timesheet.accountId,
                    userId: this.timesheet.userId,  
                    contractId: this.timesheet.contractId,
                    startDate: this.timesheet.startDate,
                    endDate: this.timesheet.endDate,
                    timesheetNumber: this.timesheet.timesheetNumber,
                    timesheetId: this.timesheet.timesheetId,
                    contractResourceId: this.timesheet.contractResourceId
                }

                modalDialog.update(data);
                break;
            case 'create':
                modalDialog = component.find('diModalDialogTimesheet');

                data = {
                    open: true,
                    view: type,     
                }

                modalDialog.update(data);
                break;
        }
    },
    handleChange: function(component, data) {
        switch(data['id']) {
            case 'diModalDialogConfirm':
                console.log('DEBUG:TimesheetsHeader:Helper:handleChange:diModalDialogConfirm', this.modalDialog);
                if(this.modalDialog.id == 'diModalDialogConfirm' && data['action'] == 'submit') {
                    switch(this.modalDialog.action) {
                        case 'send':
                        case 'delete':
                        case 'approve':
                            console.log('DEBUG:TimesheetsHeader:Helper:handleChange:action', this.modalDialog.action);                            
                            let timesheetId = this.getView(component, 'timesheetId');
                            timesheetId && this[this.modalDialog.action + 'Timesheet'](component, timesheetId);
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
    sendTimesheet: function(component, timesheetId) {
        console.log('DEBUG:TimesheetsHeader:Helper:sendTimesheet');
        
        let params = {
            timesheetId: timesheetId
        };

        console.log('DEBUG:TimesheetsHeader:Helper:sendTimesheet: params:', params);

        this.sendRequest(component, 'c.updateStatus', params)
        .then((data) => {
            console.log('DEBUG:TimesheetsHeader:Helper:sendTimesheet: Load:Success:', data);
            this.clearModalDialogData();
            $A.get('e.force:refreshView').fire(); 
        })
        .catch((errors) => {
            console.error('DEBUG:TimesheetsHeader:Helper:sendTimesheet: Load:Error:', errors);
        });        
    },
    approveTimesheet: function(component, timesheetId) {
        console.log('DEBUG:TimesheetsHeader:Helper:approveTimesheet');
        
        let params = {
            timesheetId: timesheetId
        };

        console.log('DEBUG:TimesheetsHeader:Helper:approveTimesheet: params:', params);

        this.sendRequest(component, 'c.updateStatus', params)
        .then((data) => {
            console.log('DEBUG:TimesheetsHeader:Helper:updateTimesheetStatus: Load:Success:', data);
            this.clearModalDialogData();
            $A.get('e.force:refreshView').fire(); 
        })
        .catch((errors) => {
            console.error('DEBUG:TimesheetsHeader:Helper:approveTimesheet: Load:Error:', errors);
        }); 
    },
    deleteTimesheet: function(component, timesheetId) {
        console.log('DEBUG:TimesheetsHeader:Helper:deleteTimesheet');
        
        let params = {
            timesheetId: timesheetId
        };

        console.log('DEBUG:TimesheetsHeader:Helper:deleteTimesheet: params:', params);

        this.sendRequest(component, 'c.deleteEntry', params)
        .then((data) => {
            console.log('DEBUG:TimesheetsHeader:Helper:deleteTimesheet: Load:Success:', data);
            this.clearModalDialogData();
            distdlib.location.open();           
        })
        .catch((errors) => {
            console.error('DEBUG:TimesheetsHeader:Helper:deleteTimesheet: Load:Error:', errors);
        }); 
    },
    refreshTimesheet : function(component) {
        let timesheetId = this.getView(component, 'timesheetId');

        if(timesheetId) {
            
            let params = {
                timesheetId: timesheetId
            };

            this.sendRequest(component, 'c.getInformation', params)
            .then((data) => {
                console.log('DEBUG:refreshTimesheet: Load:Success:', data.data.item);     
                if(distdlib.isObject(data.data) && distdlib.isObject(data.data.item)) {

                    let item = data.data.item;                 

                    let params2 = {
                        timesheetId: timesheetId,
                        userId: item.userId,
                        contractId: item.contractId,
                        startDate: item.startDate,
                        endDate: item.endDate
                    };
                    
                    console.log('DEBUG:refreshTimesheet: params2:', params2);
        
                    this.sendRequest(component, 'c.updateEntry', params2)
                    .then((result) => {
                        console.log('DEBUG:refreshTimesheet: Load:Success:', result);
        
                        if(result.status == 'success') {
                            $A.get('e.force:refreshView').fire();
                        }   else {
                            console.error('refreshTimesheet: Server:Error:');
                        }       
                    })
                    .catch((errors) => {
                        console.error('refreshTimesheet: Load:Error:', errors);
                    });
                 
                }                
            })
            .catch((errors) => {
                console.error('DEBUG:TimesheetsPanelInfo: Load:Error: ', errors);
            });
        }               
    },    
    clearModalDialogData: function() {
        this.modalDialog.id = null;
        this.modalDialog.action = null;
    },
    hideView: function(component, view) {
        //$A.util.toggleClass(toggleText, "toggle");
        $A.util.addClass(button, 'invisible');
    }
})