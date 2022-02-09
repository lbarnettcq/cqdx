({
    id: 'diTimesheetsTable',
    childsData: [],
    modalDialog: {
        id: null,
        action: null,
        timesheetId: null
    },
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
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:TimesheetsTable:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component);
            this.load(component);
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
       this.createColumns(component);
    },
    load: function(component) {
        let totalCountParams = {};

        let params  = {
            'limits': this.getView(component, 'limitRows'),
            'offset': this.getView(component, 'offsetRows')
        }

        let invoiceId = this.getView(component, 'invoiceId');
        if(invoiceId) {
            params['invoiceId'] = invoiceId;
            totalCountParams['invoiceId'] = invoiceId;
        }

        Promise.all([
            this.sendRequest(component, 'c.getTotalCount', totalCountParams, 'total'), 
            this.sendRequest(component, 'c.getList', params, 'list')   
        ]).then(list => {
            console.log('DEBUG:TimesheetsTable:Helper:load:SUCCESS:', list);
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

            console.log('DEBUG:TimesheetsTable:Helper:load:lastModified', this.lastModified);   

            this.updateViewCurrentCountRows(component, timeTrackingsCount); 
            this.updateViewSort(component, 'timePeriod'); 
            this.updateLastModified(component, this.lastModified);    

            this.setView(component, 'data', timeTrackings);  
            
            let data = {
                totalNumberRows: timeTrackingsCount,
                sortedBy: this.getLableByColumnName(component, 'timePeriod'),
                lastModified: this.formatLastModified(this.lastModified)
            }
            
            this.notify(component, 'init', data);
        }).catch(function(errors) {
            console.error('DEBUG:TimesheetsTable:Helper:load:ERROR: ', errors);
        });
    },
    proccessData: function(component, dataList) {
        dataList = dataList.map(rowData => {
            let startDate =  this.createDate(rowData.startDate);
            let endDate =  this.createDate(rowData.endDate);

            rowData.timesheetUrl = this.getTimesheetUrl(component, rowData.timesheetId);
            rowData.timesheetLabel = rowData.timesheetNumber;

            rowData.clientUrl = rowData.accountLink;
            rowData.clientLabel = rowData.account;

            rowData.employeeUrl = rowData.userLink;
            rowData.employeeLabel = rowData.userName;

            rowData.sowUrl = rowData.contractLink;

            rowData.sowLabel = rowData.contractNumber;

            rowData.timePeriod = (startDate.getDate() + ' ' + distdlib.date.months[startDate.getMonth()].label) + ' ' + startDate.getFullYear() + ' - ' + 
                                (endDate.getDate() + ' ' + distdlib.date.months[endDate.getMonth()].label) + ' ' + endDate.getFullYear();

            rowData.totalHoursLabel = distdlib.time.convertToHoursAndMinutes(rowData.totalMinutes);

            console.log('DEBUG:TimesheetsTable:Helper:load:lastModified:after:', this.createDate(rowData.lastModifiedDate), this.createDate(this.lastModified)); 

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
                case 'New':
                    rowData.showClass = 'slds-icon-utility-new';                   
                    rowData.displayIconNameLabel = 'New';
                    break;
                case 'Pending':
                    rowData.showClass = 'slds-icon-utility-pending';
                    rowData.displayIconNameLabel = 'Pending';
                    break;
                case 'Approved':
                    rowData.showClass = 'slds-icon-utility-approved';
                    rowData.displayIconNameLabel = 'Approved';
                    break;
                case 'Invoiced':
                    rowData.showClass = 'slds-icon-utility-invoiced';
                    rowData.displayIconNameLabel = 'Invoiced';
                    break;
                case 'Paid':
                    rowData.showClass = 'slds-icon-utility-paid';
                    rowData.displayIconNameLabel = 'Paid';
                    break;
                default: {
                    rowData.showClass = 'slds-icon-utility-default';
                    rowData.displayIconNameLabel = rowData.status;
                }
            }
            
            return rowData;
        });
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
    createColumns: function(component) {
        let headerActions = [];

        let rowActions = this.getRowActions.bind(this, component);

        this.setView(component, 'columns', [
            {label: 'Timesheet', fieldName: 'timesheetUrl', type: 'url', sortable:true, 
                typeAttributes: {
                    label: {
                        fieldName: 'timesheetLabel'
                    },
                    tooltip: { 
                        fieldName: 'timesheetLabel'
                    }
                },
                actions: headerActions
            },
            {label: 'Client', fieldName: 'clientUrl', type: 'url',sortable:true, 
                typeAttributes: {
                    label: {
                        fieldName: 'clientLabel'
                    },
                    tooltip: { 
                        fieldName: 'clientLabel'
                    }
                },
                actions: headerActions
            },
            {label: 'Employee', fieldName: 'employeeUrl', type: 'url',sortable:true, 
                typeAttributes: {
                    label: {
                        fieldName: 'employeeLabel'
                    },
                    tooltip: { 
                        fieldName: 'employeeLabel'
                    }
                },
                actions: headerActions
            },            
            {label: 'SOW', fieldName: 'sowUrl', type: 'url',sortable:true, 
                typeAttributes: {
                    label: {
                        fieldName: 'sowLabel'
                    },
                    tooltip: { 
                        fieldName: 'sowLabel'
                    }
                },
                actions: headerActions
            },
            {label: 'Time Period', fieldName: 'timePeriod', type: 'text', sortable:true, 
                cellAttributes: { 
                    class: 'time-period'
                },
                actions: headerActions
            },
            {label: 'Hours Total', fieldName: 'totalHoursLabel', type: 'text', sortable: true, 
                typeAttributes: {
                    label: {fieldName: 'totalHoursLabel'}
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
            /*
            communicate with team for delete in future
            {label: 'Last Updated', fieldName: 'lastModifiedDate', type: 'text', 
                cellAttributes: { 
                    class: 'time-period'
                },
                sortable: true
            },*/           
            {type: 'action', typeAttributes: {rowActions: rowActions}} 
        ]);
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
    sendTimesheet: function(component) {
        console.log('DEBUG:TimesheetsTable:Helper:sendTimesheet');
        
        let params = {
            timesheetId: this.modalDialog.timesheetId
        };

        console.log('DEBUG:TimesheetsTable:Helper:sendTimesheet: params:', params);

        this.sendRequest(component, 'c.updateStatus', params)
        .then((data) => {
            console.log('DEBUG:TimesheetsTable:Helper:sendTimesheet: Load:Success:', data);
            this.clearModalDialogData();
            $A.get('e.force:refreshView').fire(); 
        })
        .catch((errors) => {
            console.error('DEBUG:TimesheetsTable:Helper:sendTimesheet: Load:Error:', errors);
        }); 
    },
    approveTimesheet: function(component) {
        console.log('DEBUG:TimesheetsTable:Helper:approveTimesheet');
        
        let params = {
            timesheetId: this.modalDialog.timesheetId
        };

        console.log('DEBUG:TimesheetsTable:Helper:approveTimesheet: params:', params);

        this.sendRequest(component, 'c.updateStatus', params)
        .then((data) => {
            console.log('DEBUG:TimesheetsTable:Helper:updateTimesheetStatus: Load:Success:', data);
            this.clearModalDialogData();
            $A.get('e.force:refreshView').fire(); 
        })
        .catch((errors) => {
            console.error('DEBUG:TimesheetsTable:Helper:approveTimesheet: Load:Error:', errors);
        }); 
    },
    deleteTimesheet: function(component) {
        console.log('DEBUG:TimesheetsTable:Helper:deleteTimesheet');
        
        let params = {
            timesheetId: this.modalDialog.timesheetId
        };

        console.log('DEBUG:TimesheetsTable:Helper:deleteTimesheet: params:', params);

        this.sendRequest(component, 'c.deleteEntry', params)
        .then((data) => {
            console.log('DEBUG:TimesheetsTable:Helper:deleteTimesheet: Load:Success:', data);
            this.clearModalDialogData();
            $A.get('e.force:refreshView').fire(); 
        })
        .catch((errors) => {
            console.error('DEBUG:TimesheetsTable:Helper:deleteTimesheet: Load:Error:', errors);
        }); 
    },
    showModalDialog: function(component, event, type) {
        console.log('DEBUG:TimesheetsTable:Helper:showModalDialog', type);

        let modalDialog = null;
        let data = null;
        let row = event.getParam('row');

        switch(type) {
            case 'approve':                
            case 'send':
            case 'delete':
                data = {
                    open: true,
                    view: type,
                    name: row.timesheetNumber,
                    title: distdlib.capitalizeFirstLetter(type) + ' Timesheet',
                    showHint: ((type == 'delete') ? false : !row.approvedEntries)
                }

                this.modalDialog.id = 'diModalDialogConfirm';
                this.modalDialog.action = type;
                this.modalDialog.timesheetId = row.timesheetId;

                modalDialog = component.find('diModalDialogConfirm');
                modalDialog && modalDialog.update(data); 
                break;
            case 'edit':
                data = {
                    open: true,
                    view: type,
                    timesheetId: row.timesheetId,
                    timesheetNumber: row.timesheetNumber,
                    accountId: row.accountId,
                    userId: row.userId,  
                    contractId: row.contractId,
                    startDate: row.startDate,
                    endDate: row.endDate,
                };
                
                modalDialog = component.find('diModalDialogTimesheet');
                modalDialog && modalDialog.update(data); 
                break;
        }
        
    },
    detailsData: function(component, event) {
        let row = event.getParam('row');

        let data = {
            timesheetId: row.timesheetId      
        }

        console.log('DEBUG:TimesheetsTable:Helper:detailsData', row);
        
        this.notify(component, 'details', data);
    },
    updateStatus: function(component, event, status) {
        let row = event.getParam('row');

        let params = {
            startDate: row.startDate, 
            endDate: row.endDate,
            employeeId: row.userId,
            status: status
        };

        this.sendRequest(component, 'c.setStatus', params)
        .then(result => {
            console.log('DEBUG:TimesheetsTable:Helper:updateStatus:SUCCESS:', result);         
            let rows = component.get('v.data');
            let rowIndex = rows.indexOf(row);
            console.log('DEBUG:TimesheetsTable:Helper:updateStatus:SUCCESS:status', status);     
            if(status) {
                rows[rowIndex].showClass = 'slds-icon-utility-approved';                   
                rows[rowIndex].displayIconNameLabel = 'Approved';
                rows[rowIndex].status = 'approved';
            } else {
                rows[rowIndex].showClass = 'slds-icon-utility-approval';                   
                rows[rowIndex].displayIconNameLabel = 'For Approval';
                rows[rowIndex].status = 'for_approval';
            }

            this.lastModified = new Date();
            rows[rowIndex].lastModifiedDate = moment(this.lastModifiedDate).format('MM/DD/YYYY hh:mm A');
            this.updateLastModified(component, this.lastModified);

            console.log('DEBUG:TimesheetsTable:Helper:updateStatus:SUCCESS:rows:before', rows);     

            component.set('v.data', rows);

            console.log('DEBUG:TimesheetsTable:Helper:updateStatus:SUCCESS:rows:after', rows);   
        }).catch(function(errors) {
            console.error('DEBUG:TimesheetsTable:Helper:updateStatus:ERROR: ', errors);
        });
    },
    getData: function(component, event) {
        console.log('DEBUG:TimesheetsTable:Helper:getData:init:', this.getView(component, 'data').length, this.getView(component, 'totalNumberRows'));
        if (this.getView(component, 'data').length >= this.getView(component, 'totalNumberRows')) {
            console.log('DEBUG:TimesheetsTable:Helper:getData:if:disableInfiniteLoading');
            event.getSource().set('v.isLoading', false);
            this.setView(component, 'enableInfiniteLoading', false);     
            this.setView(component, 'loadMoreStatus', 'No more data to load');      
        } else {
            console.log('DEBUG:TimesheetsTable:Helper:getData:else:');

            event.getSource().set('v.isLoading', true);  
            this.setView(component, 'loadMoreStatus', 'Loading');

            let rows = this.getView(component, 'rowsToLoad');

            let params  = {
                'limits': rows, 
                'offset': this.getView(component, 'offsetRows')
            }
    
            this.sendRequest(component, 'c.getList', params)   
            .then(result => {
                console.log('DEBUG:TimesheetsTable:Helper:getData:getList:SUCCESS:', result);   
                
                let listData = result['data']['list'];
                let countRows = listData.length;
    
                let currentCountRows = this.getView(component, 'currentCountRows');
                this.updateViewCurrentCountRows(component, currentCountRows + countRows);   
    
                let offsetRows = this.getView(component, 'offsetRows');
                this.updateViewOffsetRows(component, offsetRows + countRows);    
    
                this.proccessData(component, listData);  

                let newData = this.getView(component, 'data').concat(listData);

                console.log('DEBUG:TimesheetsTable:Helper:getData:', this.getView(component, 'data').length, this.getView(component, 'totalNumberRows'));
    
                if (this.getView(component, 'data').length >= this.getView(component, 'totalNumberRows')) {                 
                    this.setView(component, 'enableInfiniteLoading', false);                  
                    this.setView(component, 'loadMoreStatus', 'No more data to load');
                    console.log('DEBUG:getData:true');
                } else {              
                    this.setView(component, 'loadMoreStatus', 'Please wait ');
                    console.log('DEBUG:TimesheetsTable:Helper:getData:false');                    
                }
                
                this.setView(component, 'data', this.sortData(newData, this.getView(component, 'sortedBy')), this.getView(component, 'v.sortedDirection'));

                event.getSource().set('v.isLoading', false);

                let data = {
                    totalNumberRows: this.getView(component, 'currentCountRows'),
                    sortedBy: this.getLableByColumnName(component, this.getView(component, 'sortedBy')),
                    lastModified: this.formatLastModified(this.lastModified)
                }                
                this.notify(component, 'change', data);
            }).catch(function(errors) {
                console.error('DEBUG:TimesheetsTable:Helper:getData:ERROR: ', errors);
            });   
        }
    },
    getTotal: function(component) {
        let params = {};

        this.sendRequest(component, 'c.getTotalCount', params)   
        .then(data => {
            console.log('DEBUG:TimesheetsTable:Helper:getTotal:getTotalCount:SUCCESS:', data);

            if(stdlib.isObject(data.data) && typeof data.data.count != 'undefined') {
                this.setView(component, 'totalNumberOfRows', data.data.count);
            }            
        }).catch(function(errors) {
            console.error('DEBUG:TimesheetsTable:Helper:getTotal:getTotalCount:ERROR: ', errors);
        });
    },
    sortData: function (data, fieldName, sortDirection) {
        let reverse = (sortDirection !== 'asc');
   
        data.sort(this.sortBy(fieldName, reverse));

        return data;
    },
    sortBy: function(field, reverse, primer) {
        switch(field) {
            case 'timesheetUrl':
                field = 'timesheetLabel';
                break;
            case 'clientUrl':
                field = 'clientLabel';
                break;
            case 'employeeUrl':
                field = 'employeeLabel';
                break;
            case 'sowUrl':
                field = 'sowLabel';
                break;
            case 'timePeriod':
                field = 'startDate';
                break;
            case 'totalHoursUrl':
            case 'totalHoursLabel':
                field = 'totalMinutes';
                break;
        }

        let key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return ((field === 'totalMinutes') ? (+x[field]) : x[field]);};

        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            console.log('DEBUG:TimesheetsTable:Helper:sort', field, key(a), key(b), key(a) > key(b), key(b) > key(a))
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    getRowActions: function (component, row, doneCallback) {
        console.log('DEBUG:TimesheetsTable:Helper:getRowActions', row);
        let actions = [
            {label: 'Mark Approved', name: 'mark_approved'},
            {label: 'Send', name: 'send' },
            {label: 'Details', name: 'details'},
            {label: 'Delete', name: 'details'}
        ];

        switch(row.status) {
            case 'New':
                actions = [
                    {label: 'Send', name: 'send' },
                    {label: 'Edit', name: 'edit' },
                    {label: 'Details', name: 'details'},
                    {label: 'Delete', name: 'delete'}
                ];
            break;
            case 'Pending':
                actions = [
                    {label: 'Mark Approved', name: 'mark_approved'},
                    {label: 'Details', name: 'details'},
                ];
                break;
            case 'Approved':
            case 'Invoiced':
            case 'Paid':
                actions = [
                    {label: 'Details', name: 'details'},
                ];
                break;
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

        console.log('DEBUG:DITimesheetsTable:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DITimesheetsTable:Helper:init:dependencies:array:', dependencies);
            return dependencies;
        }

        return [];
    },
    getTimesheetUrl: function(component, timesheetId) {  
        let options = this.getView(component, 'options');

        console.log('DEBUG:DITimesheetsTable:Helper:getTimesheetUrl:options:', options);

        let url = null;

        if(options && options.timesheetsUrl) {
            url = options.timesheetsUrl;
        }
        
        let params = new Map([
            ['c__timesheetId', timesheetId],
        ]);

        return distdlib.location.createUrl(url, params);
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
    handleChange: function(component, data) {
        this.childsData.push(data);

        if(this.isReady(component)) {
            this.childsData.forEach(data => {
                switch(data['id']) {
                    case 'diModalDialogConfirm':
                        if(this.modalDialog.id == 'diModalDialogConfirm' && data['action'] == 'submit') {
                            switch(this.modalDialog.action) {
                                case 'send':
                                    this.sendTimesheet(component);
                                    break;
                                case 'approve':
                                    this.approveTimesheet(component);
                                    break;
                                case 'delete':
                                    this.deleteTimesheet(component);
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
            }); 

            this.childsData.length = 0;
        }
    },
    clearModalDialogData: function() {
        this.modalDialog.id = null;
        this.modalDialog.action = null;
        this.modalDialog.timesheetId = null;
    },
    createDate: function(value) {
        return moment(value).toDate();
    }
})