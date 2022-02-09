({
    childsData: [],
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:TimesheetContainer:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component, event, helper) { 
        console.log('DEBUG:TimesheetContainer:Helper:init');
        this.clearEvents();
        
        let timesheetId = distdlib.location.getQueryVariable('c__timesheetId');
        console.log('DEBUG:TimesheetContainer:Helper:init"timesheetId:timesheetId', timesheetId);
        if(typeof timesheetId !== 'undefined') {
            let data = {
                timesheetId: timesheetId           
            };

            this.showDetailedView(component, data);
            this.updateTimesheetsContainerInformation(component);
        } else {
            this.showListView(component);
        }        
    },
    updateTimesheetsContainerInformation : function(component) {
        console.log('DEBUG:TimesheetsContainer:Helper:updateTimesheetsContainerInformation:');

        let timesheetId = distdlib.location.getQueryVariable('c__timesheetId');

        if(timesheetId) {
            let params = {
                timesheetId: timesheetId
            };

            this.sendRequest(component, 'c.getInformation', params)
            .then((data) => {
                console.log('DEBUG:updateTimesheetsContainerInformation: Load:Success: ', data.data.item);     
                if(distdlib.isObject(data.data) && distdlib.isObject(data.data.item)) {
                    let item = data.data.item;

                    if(item.status) {
                        this.setView(component, 'timesheetStatus', item.status);
                    }
              
                }                
            })
            .catch((errors) => {
                console.error('DEBUG:updateTimesheetsContainerInformation: Load:Error: ', errors);
            });
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
    showDetailedView: function(component, data) {
        console.log('DEBUG:TimesheetContainer:Helper:showDetailedView', data);        
        this.setView(component, 'timesheetId', data.timesheetId);
        this.setView(component, 'title', 'Timesheets');
    },
    showListView: function(component) {        
        this.setView(component, 'title', 'Timesheets')
        this.setView(component, 'details', 'Timesheets for Clients');    
        this.setView(component, 'role', 'employee');    
    },
    updateHeaderView: function(component, data) {
        component.find('diTimesheetsHeader').update(data);
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
                if(typeof data['id'] != 'undefined') {
                    switch(data['state']) {
                        case 'init':     
                            let handler = distdlib.event.createHandler(data);
                            console.log('DEBUG:TimesheetContainer:Helper:handleChange:createHandler', handler);
                            handler && distdlib.event.subscribe(handler);
                            distdlib.event.notify(component, handler);
                            break;
                        case 'change':
                            console.log('DEBUG:TimesheetContainer:Helper:handleChange:createHandler:change', data['id'], data['data'], data['state'], data['dependencies']);
                            distdlib.event.updateHandler(data);
                            distdlib.event.notify(component, distdlib.event.getHandler(data['id']));
                            break;
                        case 'details':
                        case 'edit':
                            switch(data['id']) {
                                case 'diTimesheetsTable':
                                    if(typeof data.data['timesheetId'] !== 'undefined') {   
                                        let params = new Map([
                                            ['c__timesheetId', data.data['timesheetId']]
                                        ]);
                
                                        this.goToDetailView(null, params);
                                    } 
                                    break;
                                case 'diTimeReportsTable':
                                    if(typeof data.data['startDate'] !== 'undefined' && 
                                        typeof data.data['endDate'] !== 'undefined' && 
                                        typeof data.data['userId'] !== 'undefined'
                                    ) {   
                                        let params = new Map([
                                            ['c__userId', data.data.userId],            
                                            ['c__startDate', data.data.startDate],
                                            ['c__endDate', data.data.endDate],
                                            ['c__role', 'manager']
                                        ]);
                
                                        let timeReportsUrl = this.getView(component, 'timeReportsUrl');
                                        console.log('DEBUG:TimesheetContainer:Helper:handleTableChange:timeReportsUrl', timeReportsUrl);
                                        this.goToDetailView(timeReportsUrl, params);
                                    }
                                    break;
                                default: {
                                    console.log('DEBUG:TimesheetContainer:Helper:handleTableChange', data['id'], data.data, data.data.startDate, data.data.endDate, data.data.employeeId);
                                }
                            }
                            break;
                    }
                }
            }); 

            this.childsData.length = 0;
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
    clearEvents: function() {
        distdlib.event.clear();
    }
})