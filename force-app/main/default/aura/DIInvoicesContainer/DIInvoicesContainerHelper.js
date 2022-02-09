({
    childsData: [],
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:Invoices:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component, event, helper) { 
        console.log('DEBUG:Invoices:Helper:init');
        this.clearEvents();
        
        let invoiceId = distdlib.location.getQueryVariable('c__invoiceId');
        console.log('DEBUG:Invoices:Helper:init"invoiceId:invoiceId', invoiceId);
        if(typeof invoiceId !== 'undefined') {
            this.availableInvoice(component, invoiceId);
        } else {
            this.showLoadIndicator(component, false);
            this.showListView(component);            
        }        
    },
    availableInvoice: function(component, invoiceId) {
        console.log('DEBUG:Invoices:Helper:existInvoice');
        
        let params = {
            invoiceId: invoiceId
        };

        console.log('DEBUG:Invoices:Helper:sendInvoice: params:', params);

        this.sendRequest(component, 'c.availableEntity', params)
        .then((result) => {
            console.log('DEBUG:Invoices:Helper:existEntity: Load:Success:result:', result);
            if(result.status == 'success') {
               if(result.data.status == 'available') {
                    let data = {
                        invoiceId: invoiceId           
                    };
        
                    this.showDetailedView(component, data);
               } else {
                    let message = result.data.message;

                    if(!message) {
                        message = 'This record is no longer available. Ask your administrator for help.';
                    }

                    this.setView(component, 'showError', true);
                    this.setView(component, 'errorType', 'UnavailableEntityError');
                    this.setView(component, 'errorMessage', message);
               }
            } else {
              this.proccessServerErrors(component, result);             
            }  

            this.showLoadIndicator(component, false);
        })
        .catch((errors) => {
            this.setView(component, 'showError', true);
            this.setView(component, 'errorType', 'InternalServerError');
            this.setView(component, 'errorMessage', errors.message);
            this.showLoadIndicator(component, false);
            console.error('DEBUG:Invoices:Helper:sendInvoice: Load:Error:', errors);
        });        
    },
    showDetailedView: function(component, data) {
        console.log('DEBUG:Invoices:Helper:showDetailedView', data);        
        this.setView(component, 'invoiceId', data.invoiceId);
        this.setView(component, 'title', 'Invoices');
    },
    showListView: function(component) {        
        this.setView(component, 'title', 'Invoices')
        this.setView(component, 'details', 'Invoices');    
        this.setView(component, 'role', 'employee');    
    },
    showLoadIndicator: function(component, show) {
        this.setView(component, 'showLoadIndicator', show);
    },
    showErrorMessage: function(component, message) {
        this.setView(component, 'showError', true);
        this.setView(component, 'errorMessage', message);
    },
    updateHeaderView: function(component, data) {
        component.find('diInvoicesHeader').update(data);
    },
    goToDetailView: function (url, params) {
        distdlib.location.open(url, params, true);
    },
    changeStateComponent: function(name, state, data) {
        if(typeof registeredComponents[name] !== 'undefined') {
            registeredComponents[name] = state;
            registeredComponents['data'] = data;
        }
    },
    handleChange: function(component, data) {
        this.childsData.push(data);

        if(this.isReady(component)) {
            this.childsData.forEach(data => {
                console.log('DEBUG:Invoices:Helper:handleChange:iteration:', data['id'] , data['state'] );
                if(typeof data['id'] != 'undefined') {
                    switch(data['state']) {
                        case 'init':     
                            let handler = distdlib.event.createHandler(data);
                            console.log('DEBUG:Invoices:Helper:handleChange:createHandler', handler);
                            handler && distdlib.event.subscribe(handler);
                            distdlib.event.notify(component, handler);
                            break;
                        case 'change':
                            console.log('DEBUG:Invoices:Helper:handleChange:createHandler:change', data['id'], data['data'], data['state'], data['dependencies']);

                            switch(data['data']['action']) {
                                case 'showList': 
                                    console.log('DEBUG:Invoices:Helper:showList');
                                    let url = this.getView(component, 'invoicesUrl');                             
                                    distdlib.location.pushState(url, 'Invoices');
                                    this.setView(component, 'invoiceId', null);
                                    break;
                                default: {                                    
                                    distdlib.event.updateHandler(data);
                                    distdlib.event.notify(component, distdlib.event.getHandler(data['id']));
                                }
                            }
                            break;
                        case 'edit':
                        case 'details':
                            switch(data['id']) {                           
                                case 'diInvoicesTable':                                        
                                    if(typeof data.data['invoiceId'] !== 'undefined') {   
                                        let params = new Map([
                                            ['c__invoiceId', data.data['invoiceId']]
                                        ]);

                                        let invoicesUrl = this.getView(component, 'invoicesUrl');
                                        this.goToDetailView(invoicesUrl, params);
                                    } 
                                    break;
                                case 'diInvoicesTimesheetsTable':                                        
                                    if(typeof data.data['timesheetId'] !== 'undefined') {   
                                        let params = new Map([
                                            ['c__timesheetId', data.data['timesheetId']]
                                        ]);

                                        let timesheetsUrl = this.getView(component, 'timesheetsUrl');
                                        this.goToDetailView(timesheetsUrl, params);
                                    } 
                                    break;
                                default: {
                                    console.log('DEBUG:Invoices:Helper:handleTableChange', data['id'], data.data, data.data.startDate, data.data.endDate, data.data.employeeId);
                                }
                            }
                            break;
                    }
                }
            }); 

            this.childsData.length = 0;
        }
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
    proccessServerErrors: function(component, result) {
        let errorMessage = '';
        let errorType = null;

        if(result.errors && distdlib.isObject(result.errors)) {
            errorType = result.errors.type;

            if(Array.isArray(result.errors.list) && result.errors.list.length > 0) {
                        
                let list = result.errors.list;

                list.forEach((error) => {
                    if(distdlib.isObject(error)) {
                        errorMessage += ' ' + error.message;
                    } else {
                        errorMessage += ' ' + error;
                    }
                });
            }
        } 

        this.setView(component, 'showError', true);
        this.setView(component, 'errorType', errorType);
        this.setView(component, 'errorMessage',  errorMessage);
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
    clearEvents: function() {
        distdlib.event.clear();
    },
})