({
    id: 'diInvoicesPanelInfo',
    delimiter: ' • ',
    data: [],
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:InvoicesPanelInfo:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
        console.log('DEBUG:InvoicesPanelInfo:Helper:init');
        this.updatePanelInformation(component);
        this.notify(component, 'init');         
    },
    updatePanelInformation : function(component) {
        console.log('DEBUG:InvoicesPanelInfo:Helper:updatePanelInformation:');

        let invoiceId = this.getView(component, 'invoiceId');

        if(invoiceId) {
            let params = {
                invoiceId: invoiceId
            };

            this.sendRequest(component, 'c.getInformation', params)
            .then((result) => {
                console.log('DEBUG:InvoicesPanelInfo: Load:Success: ', result.data.item);  
                if(result.status == 'success') {
                    if(distdlib.isObject(result.data) && distdlib.isObject(result.data.item)) {
                        if(result.data.item.status) {
                            this.setView(component, 'status', result.data.item.status);
                        } 
    
                        if(result.data.item.accountName) {
                            this.setView(component, 'client', result.data.item.accountName);
                        }
    
                        let issueDate = this.createDate(result.data.item.issueDate);
                        if(issueDate) {
                            issueDate = (issueDate.getDate() + ' ' + distdlib.date.months[issueDate.getMonth()].label + ' ' + issueDate.getFullYear());
                            this.setView(component, 'issueDate', issueDate);
                        }

                        let dueDate = this.createDate(result.data.item.dueDate);
                        if(dueDate) {
                            dueDate = (dueDate.getDate() + ' ' + distdlib.date.months[dueDate.getMonth()].label + ' ' + dueDate.getFullYear());
                            this.setView(component, 'dueDate', dueDate);
                        }

                        let timePeriod = '';
                        let startDate = result.data.item.startDate;
    
                        if(startDate) {
                            startDate =  this.createDate(startDate);
                            timePeriod = (startDate.getDate() + ' ' + distdlib.date.months[startDate.getMonth()].label + ' ' + startDate.getFullYear());
                        } else {
                            timePeriod = 'Undefined';
                        }
    
                        let endDate = result.data.item.endDate;
                        if(endDate) {
                            endDate =  this.createDate(endDate);
                            timePeriod += ' - ' + (endDate.getDate() + ' ' + distdlib.date.months[endDate.getMonth()].label)  + ' ' + startDate.getFullYear();
                        }
    
                        this.setView(component, 'timePeriod', timePeriod);
    
                        if(result.data.item.totalExpenses >= 0) {
                            let totalExpenses = result.data.item.totalExpenses;
    
                            if(distdlib.isNumeric(totalExpenses)) {
                                totalExpenses = totalExpenses.toFixed(2);
                            }
                            
                            this.setView(component, 'totalExpenses', '$' + totalExpenses);                        
                        }     

                        if(result.data.item.totalMinutes >= 0) {
                            this.setView(component, 'totalHours', distdlib.time.convert(result.data.item.totalMinutes, 'mm', '*:*'));
                        }
    
                        if(result.data.item.totalAmount >= 0) {
                            let totalAmount = result.data.item.totalAmount;
    
                            if(distdlib.isNumeric(totalAmount)) {
                                totalAmount = totalAmount.toFixed(2);
                            }
                            
                            this.setView(component, 'totalAmount', distdlib.currency.format(totalAmount));                        
                        }                    
                    }
                } else {
                    this.proccessServerErrors(component, result);
                }                                
            })
            .catch((errors) => {
                console.error('DEBUG:InvoicesPanelInfo: Load:Error: ', errors);
            });
        }
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

        console.log('DEBUG:DIInvoicesPanelInfo:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DIInvoicesPanelInfo:Helper:init:dependencies:array:', dependencies);
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
    createDate: function(value) {
        return moment(value).toDate();
    },
    proccessServerErrors: function(component, result) {
        let message = '';

        if(result.errors) {
            if(Array.isArray(result.errors.list) && result.errors.list.length > 0) {
                
                let list = result.errors.list;

                list.forEach((error) => {
                    if(distdlib.isObject(error)) {
                        message += ' ' + error.message;
                    } else {
                        message += ' ' + error;
                    }
                });
                
            } else {
                message = result.errors.message;
            }
        } else {
            message = 'Something wrong. Please, contact with support';
        }

        console.error(message);
    }
})