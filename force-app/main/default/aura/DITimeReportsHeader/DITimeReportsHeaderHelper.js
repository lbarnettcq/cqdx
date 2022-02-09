({
    id: 'diTimeReportsHeader',
    data: [],
    config: {
        modalDialogs: {
            approve: {
                type: 'approve',
                title: 'Mark Approved',
                description: 'Are you sure you want to mark these time entries as Approved?'
            },
            unlock: {
                type: 'unlock',
                title: 'Unlock',
                description: 'Please select time entries you would like to unlock'
            }
        }
    },
    delimiter: ' • ',
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
        console.log('DEBUG:TimeReportsTrackingHeader:doInit');
        this.setView(component, 'isModalOpen', false);
        this.updatePanelInformation(component);
        this.notify(component, 'init');         
    },
    updatePanelInformation: function(component) {
        let details = this.getView(component, 'details');
        let employeeId = this.getView(component, 'employeeId');
        let startDate = this.getView(component, 'startDate');
        let endDate = this.getView(component, 'endDate');

        if(!details && employeeId && startDate && endDate) {
            let params = {
                userId: employeeId
            };

            this.sendRequest(component, 'c.getUser', params)
            .then((result) => {
                console.log('DEBUG:DiMoalDialogHelper: Load:Success: ', result);  
                
                if(result.status == 'success') {
                    let userName = null;

                    if(distdlib.isObject(result.data.user)) {
                        userName = result.data.user.name;
                    }                    

                    this.createBasicInformation(component, userName, startDate, endDate);
                }                
            })
            .catch((errors) => {
                console.error('DEBUG:DiMoalDialogHelper: Load:Error: ', errors);
                this.createBasicInformation(component, null, startDate, endDate);
            });
        }        

        let totalNumberRows = this.getView(component, 'totalNumberRows');
        let sortedBy = this.getView(component, 'sortedBy');
        let lastModified = this.getView(component, 'lastModified');

        console.log('DEBUG:TimeReportsTrackingHeader:Helper:updatePanelInformation:', totalNumberRows, sortedBy, lastModified);

        this.setView(component, 'panelInformation', this.createPanelInformation(totalNumberRows, sortedBy, lastModified));
    },
    createBasicInformation: function(component, userName, startDate, endDate) {
        let information = '';

        information = (userName) ? userName : 'Unknown';
        information = (userName) ? userName : 'Unknown';

        if(startDate) {
            startDate =  this.createDate(startDate);
            startDate = startDate.getDate() + ' ' + distdlib.date.months[startDate.getMonth()].label + ' ' + startDate.getFullYear();
            information += ' ' + startDate;
        }

        if(endDate) {
            endDate =  this.createDate(endDate);        
            endDate = endDate.getDate() + ' ' + distdlib.date.months[endDate.getMonth()].label + ' ' + endDate.getFullYear();
            information += ' - ' + endDate;
        }

        this.setView(component, 'details', information);
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

        console.log('DEBUG:DIMenu:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DIMenu:Helper:init:dependencies:array:', dependencies);
            return dependencies;
        }

        return [];
    },
    showModalDialog: function(component, event, type) {
        let startDate = this.getView(component, 'startDate');
        let endDate = this.getView(component, 'endDate');
        let employeeId = this.getView(component, 'employeeId');
        let stateTable = this.getView(component, 'stateTable');

        let modalDialog = component.find('diModalDialog');

        console.log('DEBUG:DITimeReportsTrackingHeader:showModalDialog', type, startDate, endDate, employeeId, stateTable, modalDialog);

        if(type && startDate && endDate && employeeId && stateTable && modalDialog) {
            let modalDialogConfig = this.config.modalDialogs[type]

            let data = {
                    open: true,
                    title: modalDialogConfig.title, 
                    description: modalDialogConfig.description,
                    type: modalDialogConfig.type,
                    userId: employeeId,
                    startDate: startDate, 
                    endDate: endDate,
                    status: stateTable              
                }

            modalDialog.update(data);
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
    update: function(component, data) {
        this.data.push(data);
        console.log('Debug:TimeReportsTrackingHeader:update: this.data',  this.data);
        console.log('Debug:TimeReportsTrackingHeader:update: this.data:this.isReady(component)',  this.isReady(component));

        if(this.isReady(component)) {
            this.data.forEach(item => {                
                console.log('Debug:TimeReportsTrackingHeader:update:item', item, item.data);
                if(distdlib.isObject(item) && distdlib.isObject(item.data)) {
                    console.log('Debug:TimeReportsTrackingHeader:update:item:after', item.data);
                    Object.keys(item.data).forEach(fieldName => {
                        if(fieldName == 'state') {//TODO:refactor:change state to {'type': 'table'}
                            this.setView(component, 'stateTable', item.data[fieldName]);
                        } else {
                            this.setView(component, fieldName, item.data[fieldName]);
                        }
                        console.log('Debug:TimeReportsTrackingHeader:update:item:iterator', fieldName, item.data[fieldName]);
                        this.setView(component, fieldName, item.data[fieldName]);
                        console.log('Debug:TimeReportsTrackingHeader:update:item:iterator:getView', fieldName,  this.getView(component, fieldName));
                    });
                }
            });

            this.updatePanelInformation(component);

            this.data.length = 0;
        }
    },
    getView: function(component, view) {
        return component.get('v.' + view);
    },
    setView: function(component, view, value) {
        return component.set('v.' + view, value);
    },
    isReady: function(component) {
        return this.getView(component, 'stateProcess') === 'ready';
    },
    createDate: function(value) {
        return moment(value).toDate();
    },
    toogleFilter: function(component) {
        let showFilter = this.getView(component, 'showFilter');

        this.setView(component, 'showFilter', !showFilter);
        this.notify(component, 'change', {'showFilter': !showFilter});
    },
    createPanelInformation: function(totalNumberRows, sortedBy, lastModified) {
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
})