({
    childsData: [],
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:PaymentsContainer:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component, event, helper) { 
        console.log('DEBUG:PaymentsContainer:Helper:init');
        this.clearEvents();
        
        let paymentId = distdlib.location.getQueryVariable('c__paymentId');
        console.log('DEBUG:PaymentsContainer:Helper:init"paymentId:paymentId', paymentId);
        if(typeof paymentId !== 'undefined') {
            this.availablePayment(component, paymentId);
        } else {
            this.showLoadIndicator(component, false);
            this.showListView(component);            
        }        
    },
    availablePayment: function(component, paymentId) {
        console.log('DEBUG:PaymentsContainer:Helper:existPayment');
        
        let params = {
            paymentId: paymentId
        };

        console.log('DEBUG:PaymentsContainer:Helper:sendPayment: params:', params);

        this.sendRequest(component, 'c.availableEntity', params)
        .then((result) => {
            console.log('DEBUG:PaymentsContainer:Helper:existEntity: Load:Success:result:', result);
            if(result.status == 'success') {
               if(result.data.status == 'available') {
                    let data = {
                        paymentId: paymentId           
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
            console.error('DEBUG:PaymentsContainer:Helper:sendPayment: Load:Error:', errors);
        });        
    },
    getPayment: function(component, paymentId) {
        console.log('DEBUG:PaymentsContainer:Helper:existPayment');
        
        let params = {
            paymentId: paymentId
        };

        console.log('DEBUG:PaymentsContainer:Helper:sendPayment: params:', params);

        this.sendRequest(component, 'c.getInformation', params)
        .then(result => {
            console.log('DEBUG:PaymentsContainer:Helper:existEntity: Load:Success:result:', result);
            if(result.status == 'success') {
               if(result.data.item) {        
                    let item = result.data.item;
                    console.log('DEBUG:PaymentsContainer:Helper:existEntity: Load:Success:result:item:', item.paymentType);
                    this.setView(component, 'paymentId', item.paymentId);
                    this.setView(component, 'paymentType', item.paymentType);                    
                    this.setView(component, 'title', 'Payments');
               } else {
                    let message = result.data.message;

                    if(!message) {
                        message = 'This record hasn\'t information. Ask your administrator for help.';
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
            console.error('DEBUG:PaymentsContainer:Helper:sendPayment: Load:Error:', errors);
        });        
    },
    showDetailedView: function(component, data) {
        console.log('DEBUG:PaymentsContainer:Helper:showDetailedView', data);   
        this.getPayment(component, data.paymentId);
    },
    showListView: function(component) {        
        this.setView(component, 'title', 'Payments')
        this.setView(component, 'details', 'Payments');    
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
        component.find('diPaymentsHeader').update(data);
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
                console.log('DEBUG:PaymentsContainer:Helper:handleChange:iteration:', data['id'] , data['state'] );
                if(typeof data['id'] != 'undefined') {
                    switch(data['state']) {
                        case 'init':     
                            let handler = distdlib.event.createHandler(data);
                            console.log('DEBUG:PaymentsContainer:Helper:handleChange:createHandler', handler);
                            handler && distdlib.event.subscribe(handler);
                            distdlib.event.notify(component, handler);
                            break;
                        case 'change':
                            console.log('DEBUG:PaymentsContainer:Helper:handleChange:createHandler:change', data['id'], data['data'], data['state'], data['dependencies']);

                            switch(data['data']['action']) {
                                case 'showList': 
                                    console.log('DEBUG:PaymentsContainer:Helper:showList');
                                    let url = this.getView(component, 'paymentsUrl');                             
                                    distdlib.location.pushState(url, 'Payments');
                                    this.setView(component, 'paymentId', null);
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
                                case 'diPaymentsTable':                                        
                                    if(typeof data.data['paymentId'] !== 'undefined') {   
                                        let params = new Map([
                                            ['c__paymentId', data.data['paymentId']]
                                        ]);

                                        let paymentsUrl = this.getView(component, 'paymentsUrl');
                                        this.goToDetailView(paymentsUrl, params);
                                    } 
                                    break;
                                default: {
                                    console.log('DEBUG:PaymentsContainer:Helper:handleTableChange', data['id'], data.data, data.data.startDate, data.data.endDate, data.data.employeeId);
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