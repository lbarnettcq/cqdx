({
    id: 'diPaymentsTable',
    childsData: [],
    modalDialog: {
        id: null,
        action: null,
        paymentId: null
    },
    lastModified: null,
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:PaymentsTable:Helper:processingProcess:', currentState, previousState, process[currentState]);

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
        let params  = {
            'limits': this.getView(component, 'limitRows'),
            'offset': this.getView(component, 'offsetRows')
        }

        Promise.all([
            this.sendRequest(component, 'c.getTotalCount', {}, 'total'), 
            this.sendRequest(component, 'c.getList', params, 'list')   
        ]).then(list => {
            console.log('DEBUG:PaymentsTable:Helper:load:SUCCESS:', list);
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

            console.log('DEBUG:PaymentsTable:Helper:load:lastModified', this.lastModified);   

            this.updateViewCurrentCountRows(component, timeTrackingsCount); 
            this.updateViewSort(component, 'paymentUrl'); 
            this.updateLastModified(component, this.lastModified);    

            this.setView(component, 'data', timeTrackings);  
            
            let data = {
                totalNumberRows: timeTrackingsCount,
                sortedBy: this.getLableByColumnName(component, 'paymentUrl'),
                lastModified: this.formatLastModified(this.lastModified)
            }
            
            this.notify(component, 'init', data);
        }).catch(function(errors) {
            console.error('DEBUG:PaymentsTable:Helper:load:ERROR: ', errors);
        });
    }, 
    proccessData: function(component, dataList) {
        dataList = dataList.map(rowData => {
            let startDate =  this.createDate(rowData.startDate);
            let endDate =  this.createDate(rowData.endDate);

            rowData.paymentUrl = this.getPaymentUrl(component, rowData.paymentId);
            rowData.paymentLabel = rowData.paymentNumber + '';

            rowData.paymentReceiverUrl = rowData.receiverUrl;//'/lightning/r/Account/' + rowData.accountId + '/view';
            rowData.paymentReceiverLabel = rowData.receiverName;

            rowData.timePeriod = (startDate.getDate() + ' ' + distdlib.date.months[startDate.getMonth()].label) + ' ' + startDate.getFullYear() + ' - ' + 
                                (endDate.getDate() + ' ' + distdlib.date.months[endDate.getMonth()].label) + ' ' + endDate.getFullYear();

            rowData.totalAmount = rowData.totalAmount + '';
            //rowData.totalAmountLabel = rowData.totalAmount;

            if(!rowData.paymentDate) {
                rowData.paymentDate = '';
            }

            rowData.lastUpdatedDate = moment(rowData.lastUpdatedDate).format('MM/DD/YYYY hh:mm A');

            console.log('DEBUG:PaymentsTable:Helper:load:lastModified:after:', this.createDate(rowData.lastModifiedDate), this.createDate(this.lastModified)); 

            if(this.lastModified) {
                if((this.createDate(rowData.lastUpdatedDate)) > (this.createDate(this.lastModified))) {
                    this.lastModified = rowData.lastUpdatedDate;
                }               
            } else {
                this.lastModified = rowData.lastUpdatedDate;
            }

            rowData.displayIconName = 'utility:record';

            if(typeof rowData.status === 'string') {
                let status = rowData.status.toLowerCase();
                switch(status) {
                    case 'new':
                    case 'pending':
                    case 'paid':
                        rowData.showClass = 'slds-icon-utility-' + status;                   
                        rowData.displayIconNameLabel = distdlib.capitalizeFirstLetter(status);
                        break;
                    default: {
                        rowData.showClass = 'slds-icon-utility-default';
                        rowData.displayIconNameLabel = rowData.status;
                    }
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
            {label: 'Payment ID', fieldName: 'paymentUrl', type: 'url', sortable:true, 
                typeAttributes: {
                    label: {
                        fieldName: 'paymentLabel'
                    },
                    tooltip: { 
                        fieldName: 'paymentLabel'
                    }
                },
                actions: headerActions
            },
            {label: 'Account Name', fieldName: 'paymentReceiverUrl', type: 'url', sortable:true, 
                typeAttributes: {
                    label: {
                        fieldName: 'paymentReceiverLabel'
                    },
                    tooltip: { 
                        fieldName: 'paymentReceiverLabel'
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
            {label: 'Payment Type', fieldName: 'paymentType', type: 'text', sortable:true, 
                cellAttributes: { 
                    class: 'time-period'
                },
                actions: headerActions
            },
            {
                label: 'Payment Date', 
                fieldName: 'paymentDate', 
                type: 'date-local',
                typeAttributes: {
                    month: '2-digit',
                    day: '2-digit',
                    year: 'numeric'
                },
                sortable:true, 
                cellAttributes: { 
                    class: 'time-period'
                },
            actions: headerActions
            },            
            {label: 'Final Total', fieldName: 'totalAmount', type: 'currency', sortable: true, 
                cellAttributes: { 
                    class: 'time-period payment_align-left'
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
            {label: 'Last Updated', fieldName: 'lastUpdatedDate', type: 'text', 
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
    sendPayment: function(component, data) {
        console.log('DEBUG:PaymentsTable:Helper:sendPayment');
        
        let params = {
            paymentId: this.modalDialog.paymentId
        };

        if(distdlib.isObject(data)) {
            data.paymentDate && (params['paymentDate'] = data.paymentDate);
        }

        console.log('DEBUG:PaymentsTable:Helper:sendPayment: params:', params);

        this.sendRequest(component, 'c.updateStatus', params)
        .then((result) => {
            console.log('DEBUG:PaymentsTable:Helper:sendPayment: Load:Success:', result);
            this.clearModalDialogData();
            $A.get('e.force:refreshView').fire(); 
        })
        .catch((errors) => {
            console.error('DEBUG:PaymentsTable:Helper:sendPayment: Load:Error:', errors);
        }); 
    },
    deletePayment: function(component) {
        console.log('DEBUG:PaymentsTable:Helper:deletePayment');
        
        let params = {
            paymentId: this.modalDialog.paymentId
        };

        console.log('DEBUG:PaymentsTable:Helper:deletePayment: params:', params);

        this.sendRequest(component, 'c.deleteEntry', params)
        .then(result => {
            console.log('DEBUG:PaymentsTable:Helper:deletePayment: Load:Success:', result);
            if(result.status == 'success') {
                this.clearModalDialogData();
                $A.get('e.force:refreshView').fire(); 
            }
        })
        .catch((errors) => {
            console.error('DEBUG:PaymentsTable:Helper:deletePayment: Load:Error:', errors);
        }); 
    },
    showModalDialog: function(component, event, type) {
        console.log('DEBUG:PaymentsTable:Helper:showModalDialog', type);

        let modalDialog = null;
        let data = null;
        let row = event.getParam('row');

        switch(type) {
            case 'send':               
            case 'delete':
            case 'mark_paid':
                let actionTitle = distdlib.capitalizeFirstLetter((type === 'mark_paid') ? 'Mark Paid' : type);
                if(type === 'mark_paid'){
                    actionTitle = 'Mark Paid';
                }

                data = {
                    open: true,
                    view: type,
                    name: row.paymentNumber,
                    title: actionTitle + ' Payment',
                    showHint: false
                };

                this.modalDialog.id = 'diModalDialogConfirm';
                this.modalDialog.action = type;
                this.modalDialog.paymentId = row.paymentId;

                modalDialog = component.find('diModalDialogConfirm');
                modalDialog.update(data); 
                break;
                case 'edit':
                    data = {
                        open: true,
                        view: type,
                        paymentTypeId: row.paymentType,
                        receiverId: row.receiverId,
                        paymentId: row.paymentId,
                        paymentNumber: row.paymentNumber,
                        startDate: row.startDate,
                        endDate: row.endDate,
                        paidInvoices: row.paidInvoices,
                        pendingInvoices: row.pendingInvoices,
                        pendingInvoicesStartDate: row.pendingInvoicesStartDate
                    };

                    modalDialog = component.find('diModalDialogPayment');
                    modalDialog.update(data); 
                    break;
        }
    },
    detailsData: function(component, event) {
        let row = event.getParam('row');

        let data = {
            paymentId: row.paymentId      
        }

        console.log('DEBUG:PaymentsTable:Helper:detailsData', row);
        
        this.notify(component, 'details', data);
    },
    /*updateStatus: function(component, event, status) {
        let row = event.getParam('row');

        let params = {
            startDate: row.startDate, 
            endDate: row.endDate,
            employeeId: row.userId,
            status: status
        };

        this.sendRequest(component, 'c.setStatus', params)
        .then(result => {
            console.log('DEBUG:PaymentsTable:Helper:updateStatus:SUCCESS:', result);         
            let rows = component.get('v.data');
            let rowIndex = rows.indexOf(row);
            console.log('DEBUG:PaymentsTable:Helper:updateStatus:SUCCESS:status', status);     
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

            console.log('DEBUG:PaymentsTable:Helper:updateStatus:SUCCESS:rows:before', rows);     

            component.set('v.data', rows);

            console.log('DEBUG:PaymentsTable:Helper:updateStatus:SUCCESS:rows:after', rows);   
        }).catch(function(errors) {
            console.error('DEBUG:PaymentsTable:Helper:updateStatus:ERROR: ', errors);
        });
    },*/
    getData: function(component, event) {
        console.log('DEBUG:PaymentsTable:Helper:getData:init:', this.getView(component, 'data').length, this.getView(component, 'totalNumberRows'));
        if (this.getView(component, 'data').length >= this.getView(component, 'totalNumberRows')) {
            console.log('DEBUG:PaymentsTable:Helper:getData:if:disableInfiniteLoading');
            event.getSource().set('v.isLoading', false);
            this.setView(component, 'enableInfiniteLoading', false);     
            this.setView(component, 'loadMoreStatus', 'No more data to load');      
        } else {
            console.log('DEBUG:PaymentsTable:Helper:getData:else:');

            event.getSource().set('v.isLoading', true);  
            this.setView(component, 'loadMoreStatus', 'Loading');

            let rows = this.getView(component, 'rowsToLoad');

            let params  = {
                'limits': rows, 
                'offset': this.getView(component, 'offsetRows')
            }
    
            this.sendRequest(component, 'c.getList', params)   
            .then(result => {
                console.log('DEBUG:PaymentsTable:Helper:getData:getList:SUCCESS:', result);   
                
                let listData = result['data']['list'];
                let countRows = listData.length;
    
                let currentCountRows = this.getView(component, 'currentCountRows');
                this.updateViewCurrentCountRows(component, currentCountRows + countRows);   
    
                let offsetRows = this.getView(component, 'offsetRows');
                this.updateViewOffsetRows(component, offsetRows + countRows);    
    
                this.proccessData(component, listData);  

                let newData = this.getView(component, 'data').concat(listData);

                console.log('DEBUG:PaymentsTable:Helper:getData:', this.getView(component, 'data').length, this.getView(component, 'totalNumberRows'));
    
                if (this.getView(component, 'data').length >= this.getView(component, 'totalNumberRows')) {                 
                    this.setView(component, 'enableInfiniteLoading', false);                  
                    this.setView(component, 'loadMoreStatus', 'No more data to load');
                    console.log('DEBUG:getData:true');
                } else {              
                    this.setView(component, 'loadMoreStatus', 'Please wait ');
                    console.log('DEBUG:PaymentsTable:Helper:getData:false');                    
                }
                
                this.setView(
                    component, 
                    'data', 
                    newData
                    /*this.sortData(
                        newData, 
                        this.getView(component, 'sortedBy'), 
                        this.getView(component, 'v.sortedDirection')
                    )*/
                );

                event.getSource().set('v.isLoading', false);

                let data = {
                    totalNumberRows: this.getView(component, 'currentCountRows'),
                    sortedBy: this.getLableByColumnName(component, this.getView(component, 'sortedBy')),
                    lastModified: this.formatLastModified(this.lastModified)
                }                
                this.notify(component, 'change', data);
            }).catch(function(errors) {
                console.error('DEBUG:PaymentsTable:Helper:getData:ERROR: ', errors);
            });   
        }
    },
    getTotal: function(component) {
        let params = {};

        this.sendRequest(component, 'c.getTotalCount', params)   
        .then(data => {
            console.log('DEBUG:PaymentsTable:Helper:getTotal:getTotalCount:SUCCESS:', data);

            if(stdlib.isObject(data.data) && typeof data.data.count != 'undefined') {
                this.setView(component, 'totalNumberOfRows', data.data.count);
            }            
        }).catch(function(errors) {
            console.error('DEBUG:PaymentsTable:Helper:getTotal:getTotalCount:ERROR: ', errors);
        });
    },
    sortData: function (data, fieldName, sortDirection) {
        let reverse = (sortDirection !== 'asc');
   
        data.sort(this.sortBy(fieldName, reverse));

        return data;
    },
    sortBy: function(field, reverse, primer) {
        switch(field) {
            case 'paymentReceiverUrl':
                field = 'paymentReceiverLabel';
                break;
            case 'paymentUrl':
                field = 'paymentLabel';
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

        let fieldsOfNumeric = ['totalAmount', 'totalMinutes'];

        let key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return ((fieldsOfNumeric.indexOf(field) > -1) ? (+x[field]) : x[field]);};

        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            console.log('DEBUG:PaymentsTable:Helper:sort', field, key(a), key(b), key(a) > key(b), key(b) > key(a))
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    getRowActions: function (component, row, doneCallback) {
        console.log('DEBUG:PaymentsTable:Helper:getRowActions', row);
        let actions = [];

        if(typeof row.status === 'string') {
            switch(row.status.toLowerCase()) {
                case 'new':
                    actions = [
                        {label: 'Mark Paid', name: 'mark_paid'},
                        {label: 'Details', name: 'details'},
                        {label: 'Edit', name: 'edit'},
                        {label: 'Delete', name: 'delete'}
                    ];
                break;
                case 'paid':
                    actions = [
                        {label: 'Details', name: 'details'},
                    ];
                    break;
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

        console.log('DEBUG:DIPaymentsTable:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DIPaymentsTable:Helper:init:dependencies:array:', dependencies);
            return dependencies;
        }

        return [];
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
                                case 'mark_paid':
                                    this.sendPayment(component, data['data']);                                    
                                    break;
                                case 'delete':
                                    this.deletePayment(component);
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
        this.modalDialog.paymentId = null;
    },
    createDate: function(value) {
        return moment(value).toDate();
    },
    getPaymentUrl: function(component, paymentId) {  
        let options = this.getView(component, 'options');

        console.log('DEBUG:DIPaymentsTable:Helper:getPaymentUrl:options:', options);

        let url = null;

        if(options && options.paymentsUrl) {
            url = options.paymentsUrl;
        } 
        
        let params = new Map([
            ['c__paymentId', paymentId],
        ]);

        return distdlib.location.createUrl(url, params);
    },
})