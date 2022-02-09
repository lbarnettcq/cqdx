({
    id: 'diTimesheetsPanelInfo',
    delimiter: ' • ',
    sfxSow: 'SOW',
    data: [],
    map: {
        status: 'status',
        accountName: 'client',
        contractName: 'sow',
        userName: 'employee',
        totalHours: 'totalHours',
        totalExpenses: 'totalExpenses'
    },
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:TimesheetsPanelInfo:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
        console.log('DEBUG:TimesheetsPanelInfo:Helper:init');
        this.updatePanelInformation(component);
        this.notify(component, 'init');         
    },
    updatePanelInformation : function(component) {
        console.log('DEBUG:TimesheetsPanelInfo:Helper:updatePanelInformation:');

        let timesheetId = this.getView(component, 'timesheetId');

        if(timesheetId) {
            let params = {
                timesheetId: timesheetId
            };

            this.sendRequest(component, 'c.getInformation', params)
            .then((data) => {
                console.log('DEBUG:TimesheetsPanelInfo: Load:Success: ', data.data.item);     
                if(distdlib.isObject(data.data) && distdlib.isObject(data.data.item)) {
                    let item = data.data.item;

                    if(item.status) {
                        this.setView(component, 'status', item.status);
                    }

                    console.log('DEBUG:TimesheetsPanelInfo: Load:Success:data.data.item.accountName ', item.accountName);    

                    if(item.accountName) {
                        this.setView(component, 'client', item.accountName);
                    }

                    if(item.contractName) {                        
                        this.setView(component, 'sow', item.contractName);
                    }

                    if(item.userName) {
                        this.setView(component, 'employee', item.userName);
                    }

                    if(item.contactName) {
                        this.setView(component, 'contactName', item.contactName);
                    }

                    let timePeriod = '';
                    let startDate = item.startDate;

                    if(startDate) {
                        startDate =  this.createDate(startDate);
                        timePeriod = (startDate.getDate() + ' ' + distdlib.date.months[startDate.getMonth()].label + ' ' + startDate.getFullYear());
                    } else {
                        timePeriod = 'Undefined';
                    }

                    let endDate = item.endDate;
                    if(endDate) {
                        endDate =  this.createDate(endDate);
                        timePeriod += ' - ' + (endDate.getDate() + ' ' + distdlib.date.months[endDate.getMonth()].label)  + ' ' + startDate.getFullYear();
                    }

                    this.setView(component, 'timePeriod', timePeriod);

                    if(item.totalMinutes) {
                        this.setView(component, 'totalHours', distdlib.time.convert(item.totalMinutes, 'mm', '*:*'));
                    }

                    if(item.totalExpenses) {
                        totalExpenses = item.totalExpenses;

                        if(distdlib.isNumeric(totalExpenses)) {
                            totalExpenses = totalExpenses.toFixed(2);
                        }
                        
                        this.setView(component, 'totalExpenses', '$' + totalExpenses);                        
                    }                    
                }                
            })
            .catch((errors) => {
                console.error('DEBUG:TimesheetsPanelInfo: Load:Error: ', errors);
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

        console.log('DEBUG:DITimesheetsPanelInfo:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DITimesheetsPanelInfo:Helper:init:dependencies:array:', dependencies);
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
    }
})