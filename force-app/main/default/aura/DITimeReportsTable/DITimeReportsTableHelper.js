({
    id: 'diTimeReportsTable',
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
            },
            edit: {
                type: 'edit',
                title: 'Edit',
                description: 'Please select entries you would like to edit'
            },
            details: {
                type: 'details',
                title: 'Details',
                description: 'Please select entries you would like to view'
            }
        }
    },
    lastModified: null,
    childsData: [],
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
        this.createColumns(component);
        this.load(component);
    },
    load: function(component) {
        let params  = {
            'limits': this.getView(component, 'limitRows'),
            'offset': this.getView(component, 'offsetRows')
        }

        let totalCountParams = {};

        let timesheetId = this.getView(component, 'timesheetId');
        if(timesheetId) {
            params['timesheetId'] = timesheetId;
            totalCountParams['timesheetId'] = timesheetId;
        }
      
        Promise.all([
            this.sendRequest(component, 'c.getTotalCount', totalCountParams, 'total'), 
            this.sendRequest(component, 'c.getList', params, 'list')   
        ]).then(list => {
            console.log('DEBUG:TimeReportsTracking:load:SUCCESS:', distdlib, list);
            let timeTrackings = [];
            let timeTrackingsCount = 0;

            for(let i = 0; i < list.length; i++) {
                let item = list[i];
              
                if(typeof item['total'] !== 'undefined' && distdlib.isObject(item['total']['data']) && typeof item['total']['data']['count']) {    
                    this.updateViewTotalNumberRows(component, item['total']['data']['count']);
                }

                if(typeof item['list'] !== 'undefined' && distdlib.isObject(item['list']['data']) && Array.isArray(item['list']['data']['list'])) {
                    timeTrackings = item['list']['data']['list']; 
                    timeTrackingsCount = timeTrackings.length;

                    let offsetRows = this.getView(component, 'offsetRows');
                    this.updateViewOffsetRows(component, offsetRows + timeTrackingsCount);     
                }
            }
        
            this.proccessData(component, timeTrackings); 

            console.log('DEBUG:TimeReportsTracking:load:timeTrackings:this.lastModified', this.lastModified);   

            this.updateViewCurrentCountRows(component, timeTrackingsCount); 
            this.updateViewSort(component, 'timePeriodUrl'); 
            this.updateLastModified(component, this.lastModified);    

            this.setView(component, 'data', timeTrackings);  
            
            let data = {
                totalNumberRows: timeTrackingsCount,
                sortedBy: this.getLableByColumnName(component, 'timePeriodUrl'),
                lastModified: this.formatLastModified(this.lastModified)
            }
            
            this.notify(component, 'init', data);
        }).catch(function(errors) {
            console.error('DEBUG:TimeReportsTracking:load:ERROR: ', errors);
        });
    },
    proccessData: function(component, dataList) {
        dataList = dataList.map(rowData  => {
            let startDate = this.createDate(rowData.startDate);
            let endDate = this.createDate(rowData.endDate);

            rowData.timePeriod = (startDate.getDate() + ' ' + distdlib.date.months[startDate.getMonth()].label) + ' ' + startDate.getFullYear() + ' - ' + 
                                (endDate.getDate() + ' ' + distdlib.date.months[endDate.getMonth()].label) + ' ' + endDate.getFullYear();
            rowData.timePeriodUrl = this.getTotalHoursUrl(component, rowData);
            rowData.userUrl = this.getUserUrl(component, rowData.userId);
            rowData.userNameLabel = rowData.userName;

            rowData.totalHoursLabel = distdlib.time.convertToHoursAndMinutes(rowData.totalMinutes);

            rowData.totalHoursUrl = this.getTotalHoursUrl(component, rowData);

            console.log('DEBUG:TimeReportsTracking:load:timeTrackings:this.lastModified:after:', this.createDate(rowData.lastModifiedDate), this.createDate(this.lastModified)); 

            if(this.lastModified) {
                if((this.createDate(rowData.lastModifiedDate)) > (this.createDate(this.lastModified))) {
                    this.lastModified = rowData.lastModifiedDate;
                }               
            } else {
                this.lastModified = rowData.lastModifiedDate;
            }

            rowData.lastModifiedDate = moment(rowData.lastModifiedDate).format('MM/DD/YYYY hh:mm A');

            rowData.displayIconName = 'utility:record';
          
            switch(rowData.status) {
                case 'approved':
                    rowData.showClass = 'slds-icon-utility-approved';                   
                    rowData.displayIconNameLabel = 'Approved';
                    break;
                case 'in_progress':
                    rowData.showClass = 'slds-icon-utility-inprogress';
                    rowData.displayIconNameLabel = 'In Progress';
                    break;
                case 'for_approval':
                default: {
                    rowData.showClass = 'slds-icon-utility-approval';
                    rowData.displayIconNameLabel = 'For Approval';
                }
            }
            
            return rowData;
        });
    },
    createColumns: function(component) {
        let headerActions = [];
        
        let rowActions = this.getRowActions.bind(this, component);

        this.setView(component, 'columns', [
            {label: 'Time Period', fieldName: 'timePeriodUrl', type: 'url', sortable:true, 
                typeAttributes: {
                    label: {
                        fieldName: 'timePeriod'
                    },
                    tooltip: { 
                        fieldName: 'timePeriod'
                    }
                },
                actions: headerActions
            },
            {label: 'Name', fieldName: 'userUrl', type: 'url',sortable:true, 
                typeAttributes: {
                    label: {
                        fieldName: 'userNameLabel'
                    },
                    tooltip: { 
                        fieldName: 'userNameLabel'
                    }
                },
                actions: headerActions
            },
            {label: 'Hours Total', fieldName: 'totalHoursUrl', type: 'url',sortable: true, 
                typeAttributes: {
                    label: {
                        fieldName: 'totalHoursLabel'
                    },
                    tooltip: { 
                        fieldName: 'totalHoursLabel'
                    }
                },
                actions: headerActions  
            },
            {label: 'Status', fieldName: 'status', type: 'text',sortable:true, 
                cellAttributes: { 
                    class: {
                        'fieldName': 'showClass'
                    },
                    iconName: {fieldName: 'displayIconName'}, 
                    iconLabel: {fieldName: 'displayIconNameLabel'}, 
                    iconPosition: 'left' 
                }
            },
            /* communicate with team for delete in future
            {label: 'Last Updated', fieldName: 'lastModifiedDate', type: 'text', 
                cellAttributes: { 
                    class: 'time-period'
                },
                sortable: true
            }, */          
            {type: 'action', typeAttributes: {rowActions: rowActions}} 
        ]);
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
    updateViewTotalNumberRows: function(component, total) {
        let title = '';

        switch(total) {
            case 1:
                title += total + ' Item';
                break;
            default: {
                title += total + ' Items';
            }
        }
        this.setView(component, 'totalNumberRows', total);
        this.setView(component, 'totalNumberRowsLabel', title);        
    },
    updateViewCurrentCountRows: function(component, currentCount) {
        this.setView(component, 'currentCountRows', currentCount);
    },
    updateViewOffsetRows: function(component, offset) {        
        this.setView(component, 'offsetRows', offset);
    },
    updateViewSort: function(component, fieldName) {
        this.setView(component, 'sortedBy', fieldName);
        this.setView(component, 'sortedByLabel', this.getLableByColumnName(component, fieldName));
    },
    updateLastModified: function(component, lastModified) {
        this.setView(component, 'lastModifiedLabel', this.formatLastModified(lastModified));       
    },
    formatLastModified: function(lastModified) {
        return moment(lastModified).fromNow();
    },
    getLableByColumnName: function(component, fieldName) {
        let columns = this.getView(component, 'columns');
        let sortByCol = columns.find(column => fieldName === column.fieldName);
        let fieldLabel = sortByCol.label;

        return fieldLabel;
    },
    showModalDialog: function(component, event, type) {
        console.log('DEBUG:updateModalDialog', type);

        let modalDialog = component.find('diModalDialog');

        if(modalDialog) {
            let modalDialogConfig = this.config.modalDialogs[type]

            let row = event.getParam('row');

            let data = {
                    open: true,
                    title: modalDialogConfig.title, 
                    description: modalDialogConfig.description,
                    type: modalDialogConfig.type,
                    userId: row.userId,
                    startDate: row.startDate, 
                    endDate: row.endDate,
                    status: row.status              
                }

            let timesheetId = this.getView(component, 'timesheetId');
            if(timesheetId) {
                data['timesheetId'] = timesheetId;
            }

            modalDialog.update(data);
        }
    },
    editData: function(component, event) {
        let row = event.getParam('row');

        let data = {
            userId: row.userId,
            startDate: row.startDate,
            endDate: row.endDate            
        }

        this.notify(component, 'edit', data);
    },
    detailsData: function(component, event) {
        let row = event.getParam('row');

        let data = {
            userId: row.userId,
            startDate: row.startDate,
            endDate: row.endDate            
        }

        this.notify(component, 'details', data);
    },
    getData: function(component, event) {
        console.log('DEBUG:getData:init:', this.getView(component, 'data').length, this.getView(component, 'totalNumberRows'));
        if (component.get('v.data').length >= this.getView(component, 'totalNumberRows')) {
            console.log('DEBUG:getData:if:disableInfiniteLoading');
            //component.get(loadMoreOffset
            event.getSource().set('v.isLoading', false);
            this.setView(component, 'enableInfiniteLoading', false);     
            this.setView(component, 'loadMoreStatus', 'No more data to load');      
        } else {
            console.log('DEBUG:getData:else:');

            event.getSource().set('v.isLoading', true);  
            this.setView(component, 'loadMoreStatus', 'Loading');

            let rows = this.getView(component, 'rowsToLoad');

            let params  = {
                'limits': rows, //component.get('v.limitRows'),
                'offset': this.getView(component, 'offsetRows')
            }

            let timesheetId = this.getView(component, 'timesheetId');
            if(timesheetId) {
                params['timesheetId'] = timesheetId;
            }
    
            this.sendRequest(component, 'c.getList', params)   
            .then(result => {
                console.log('DEBUG:getData:getList:SUCCESS:', result);   
                
                let listData = result['data']['list'];
                let countRows = listData.length;
    
                let currentCountRows = component.get('v.currentCountRows');
                this.updateViewCurrentCountRows(component, currentCountRows + countRows);   
    
                let offsetRows = component.get('v.offsetRows');
                this.updateViewOffsetRows(component, offsetRows + countRows);    
    
                this.proccessData(component, listData);  

                let newData = this.getView(component, 'data').concat(listData);

                console.log('DEBUG:getData:', this.getView(component, 'data').length, this.getView(component, 'totalNumberRows'));
    
                if (this.getView(component, 'data').length >= this.getView(component, 'totalNumberRows')) {                 
                    this.setView(component, 'enableInfiniteLoading', false);                  
                    this.setView(component, 'loadMoreStatus', 'No more data to load');
                    console.log('DEBUG:getData:true');
                } else {              
                    this.setView(component, 'loadMoreStatus', 'Please wait ');
                    console.log('DEBUG:getData:false');                    
                }
                
                this.setView(component, 'data', this.sortData(newData, component.get('v.sortedBy'), component.get('v.sortedDirection')));

                event.getSource().set('v.isLoading', false);

                let data = {
                    totalNumberRows: this.getView(component, 'currentCountRows'),
                    sortedBy: this.getLableByColumnName(component, this.getView(component, 'sortedBy')),
                    lastModified: this.formatLastModified(this.lastModified)
                }                
                this.notify(component, 'change', data);
            }).catch(function(errors) {
                console.error('DEBUG:getData:ERROR: ', errors);
            });   
        }
    },
    getTotal: function(component) {
        let params = {};

        this.sendRequest(component, 'c.getTotalCount', params)   
        .then(data => {
            console.log('DEBUG:getTotal:getTotalCount:SUCCESS:', data);
            if(stdlib.isObject(data.data) && typeof data.data.count != 'undefined') {
                this.setView(component, 'totalNumberOfRows', data.data.count);
            }
        }).catch(function(errors) {
            console.error('DEBUG:getTotal:getTotalCount:ERROR: ', errors);
        });
    },
    sortData: function (data, fieldName, sortDirection) {
        let reverse = (sortDirection !== 'asc');
   
        data.sort(this.sortBy(fieldName, reverse));

        return data;
    },
    sortBy: function(field, reverse, primer) {
        switch(field) {
            case 'timePeriodUrl':
                field = 'startDate';
                break;
            case 'totalHoursUrl':
                field = 'totalMinutes';
                break;
            case 'userUrl':
                field = 'userName';
                break;
        }

        let key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return ((field === 'totalMinutes') ? (+x[field]) : x[field]);};

        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            console.log('DEBUG:sort', field, key(a), key(b), key(a) > key(b), key(b) > key(a))
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    getRowActions: function (component, row, doneCallback) {
        console.log('DEBUG:getRowActions', row);
        let actions = [];
        let timesheetStatus = this.getView(component, 'timesheetStatus');

        switch(row.status) {
            case 'approved':
                actions = [
                    {label: 'Unlock', name: 'unlock'},
                    {label: 'Details', name: 'details'}
                ];
                if(timesheetStatus == 'Paid') {
                    actions = [
                        {label: 'Details', name: 'details'}
                    ];                    
                }
                break;
            case 'in_progress':
                actions = [
                    {label: 'Mark Approved', name: 'mark_approved'},
                    {label: 'Unlock', name: 'unlock'},
                    {label: 'Edit', name: 'edit'},
                    {label: 'Details', name: 'details'}
                ];
                break;
            case 'for_approval':
            default: {
                actions = [
                    {label: 'Mark Approved', name: 'mark_approved'},
                    {label: 'Edit', name: 'edit'},
                    {label: 'Details', name: 'details'}
                ];
            }
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
    
        let changeEvent = component.getEvent('changeEvent');
        changeEvent.setParams({data: params});
        changeEvent.fire();
    },
    getArrayDependencies: function(component) {        
        let dependencies = this.getView(component, 'dependencies');

        console.log('DEBUG:DITimeReportsTable:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DITimeReportsTable:Helper:init:dependencies:array:', dependencies);
            return dependencies;
        }

        return [];
    },
    getUserUrl: function(component, id) {
        let options = this.getView(component, 'options');

        let url = null;

        if(options && options.userUrl) {
            url = options.userUrl;
        } 

        return url + id + '/view';
    },
    getTotalHoursUrl: function(component, data) {  
        let options = this.getView(component, 'options');

        console.log('DEBUG:DITimeReportsTable:Helper:getTotalHoursUrl:options:', options);

        let url = null;

        if(options && options.timeReportsUrl) {
            url = options.timeReportsUrl;
        } 
        
        let params = new Map([
            ['c__userId', data.userId],            
            ['c__startDate', data.startDate],
            ['c__endDate', data.endDate],
            ['c__role', 'manager']
        ]);

        console.log('DEBUG:DITimeReportsTable:Helper:getTotalHoursUrl:url:', url);

        return distdlib.location.createUrl(url, params);
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
    update: function (component, data) {
        this.childsData.push(data);  
        
        if(this.isReady(component)) {
            this.childsData.forEach(data => {          
                if(distdlib.isObject(data)) {
                    switch(data.id) {
                        default: {
                            if(typeof data.data != 'undefined') {
                                if(typeof data.data.showFilter != 'undefined') {
                                    this.setView(component, 'showFilter', data.data.showFilter);
                                }
                            }
                        }
                    }
                }
            }); 

            this.childsData.length = 0;
        }
    },
    handleChange: function(component, data) {
        this.childsData.push(data);

        if(this.isReady(component)) {
            this.childsData.forEach(data => {
                switch(data['id']) {
                    case 'diFilter':
                    console.log(':DEBUG:TIMEREPORTSTABLE:HELPER:handleChange:' + data.data);
                        if(typeof data.data != 'undefined') {
                            switch(data.data.event) {
                                case 'close':
                                this.setView(component, 'showFilter', false);
                                this.notify(component, 'change', {'showFilter': false});
                                break;
                            }                            
                        }                         
                        break;
                }
            }); 

            this.childsData.length = 0;
        }
    },
})