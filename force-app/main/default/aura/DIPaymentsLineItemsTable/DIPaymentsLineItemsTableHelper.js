({
    id: 'diPaymentsLineItemsTable',
    childsData: [],
    lastModified: null,
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:PaymentsLineItemsTable:Helper:processingProcess:', currentState, previousState, process[currentState]);

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

        let paymentId = this.getView(component, 'paymentId');
        if(paymentId) {
            params['paymentId'] = paymentId;
            totalCountParams['paymentId'] = paymentId;
        }

        Promise.all([
            this.sendRequest(component, 'c.getTotalItemsCount', totalCountParams, 'total'), 
            this.sendRequest(component, 'c.getListItems', params, 'list')   
        ]).then(list => {
            console.log('DEBUG:PaymentsLineItemsTable:Helper:load:SUCCESS:', list);
            let paymentsLineItems = [];
            let paymentsLineItemsCount = 0;

            for(let i = 0; i < list.length; i++) {
                let item = list[i];
              
                if(typeof item['total'] !== 'undefined' && distdlib.isObject(item['total']['data']) && typeof item['total']['data']['count']) {    
                    this.updateViewTotalNumberRows(component, item['total']['data']['count']);
                }

                if(typeof item['list'] !== 'undefined' && distdlib.isObject(item['list']['data']) && Array.isArray(item['list']['data']['list'])) {
                    paymentsLineItems = item['list']['data']['list']; 
                    paymentsLineItemsCount = paymentsLineItems.length;

                    let offsetRows = this.getView(component, 'offsetRows');
                    this.updateViewOffsetRows(component, offsetRows + paymentsLineItemsCount);     
                }
            }
        
            this.proccessData(paymentsLineItems); 

            console.log('DEBUG:PaymentsLineItemsTable:Helper:load:lastModified', this.lastModified);   

            this.updateViewCurrentCountRows(component, paymentsLineItemsCount); 
            this.updateViewSort(component, 'sowUrl'); 
            this.updateLastModified(component, this.lastModified);    

            this.setView(component, 'data', paymentsLineItems);  
            
            let data = {
                totalNumberRows: paymentsLineItemsCount,
                sortedBy: this.getLabelByColumnName(component, 'timePeriod'),
                lastModified: this.formatLastModified(this.lastModified)
            }
            
            if(paymentsLineItems.length > 0) {
                this.setView(component, 'message', {show: false, description: ''});
            } else {
                this.setView(component, 'message', {show: true, description: 'There are no payments in this time period'});
            }

            this.notify(component, 'init', data);
        }).catch(function(errors) {
            console.error('DEBUG:PaymentsLineItemsTable:Helper:load:ERROR: ', errors);
        });
    },
    proccessData: function(rows) {
        rows = rows.map(row => {
            row.sowUrl = row.contractUrl;
            row.sowLabel = row.contractNumber;

            row.employeeUrl = row.employeeUrl;
            row.employeeLabel = row.employeeName;

            row.totalHoursLabel = distdlib.time.convert(row.totalMinutes, 'mm', '*:*');

            row.rateLabel = (row.rate + '');
            
            row.totalAmountLabel = (distdlib.isNumber(row.totalAmount) ? row.totalAmount.toFixed(2) : (row.totalAmount + ''));
            
            return row;
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

        this.setView(component, 'columns', [
            {label: 'SOW', fieldName: 'sowUrl', type: 'url', sortable:true, 
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
            {label: 'Hours Total', fieldName: 'totalHoursLabel', type: 'text', sortable: true, 
                typeAttributes: {
                    label: {fieldName: 'totalHoursLabel'}
                },
                actions: headerActions  
            }, 
            {label: 'Rate', fieldName: 'rateLabel', type: 'currency', sortable: true, 
                typeAttributes: {
                    label: {fieldName: 'rateLabel'}
                },
                cellAttributes: { 
                    class: 'payment_align-left'
                },
                actions: headerActions  
            },
            {label: 'Final Total', fieldName: 'totalAmountLabel', type: 'currency', sortable: true, 
                typeAttributes: {
                    label: {fieldName: 'totalAmountLabel'}
                },
                cellAttributes: { 
                    class: 'payment_align-left'
                },
                actions: headerActions  
            } 
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
        this.setView(component, 'sortedByLabel', this.getLabelByColumnName(component, fieldName));
    },
    updateLastModified: function(component, lastModified) {
        this.setView(component, 'lastModifiedLabel', this.formatLastModified(lastModified));       
    },
    formatLastModified: function(lastModified) {
        return moment(lastModified).fromNow();
    },
    getLabelByColumnName: function(component, fieldName) {
        let columns = this.getView(component, 'columns');
        let sortByCol = columns.find(column => fieldName === column.fieldName);
        console.log('DEBUG:PaymentsLineItemsTable:Helper:getLabelByColumnName', fieldName, sortByCol);

        if(sortByCol) {
            return  sortByCol.label;
        }

        return null;
    },
    getData: function(component, event) {
        console.log('DEBUG:PaymentsLineItemsTable:Helper:getData:init:', this.getView(component, 'data').length, this.getView(component, 'totalNumberRows'));
        if (this.getView(component, 'data').length >= this.getView(component, 'totalNumberRows')) {
            console.log('DEBUG:PaymentsLineItemsTable:Helper:getData:if:disableInfiniteLoading');
            event.getSource().set('v.isLoading', false);
            this.setView(component, 'enableInfiniteLoading', false);     
            this.setView(component, 'loadMoreStatus', 'No more data to load');      
        } else {
            console.log('DEBUG:PaymentsLineItemsTable:Helper:getData:else:');

            event.getSource().set('v.isLoading', true);  
            this.setView(component, 'loadMoreStatus', 'Loading');

            let rows = this.getView(component, 'rowsToLoad');

            let params  = {
                'limits': rows, 
                'offset': this.getView(component, 'offsetRows')
            }
    
            let invoiceId = this.getView(component, 'invoiceId');
            if(invoiceId) {
                params['invoiceId'] = invoiceId;
            }

            this.sendRequest(component, 'c.getListItems', params)   
            .then(result => {
                console.log('DEBUG:PaymentsLineItemsTable:Helper:getData:getList:SUCCESS:', result);   
                
                let listData = result['data']['list'];
                let countRows = listData.length;
    
                let currentCountRows = this.getView(component, 'currentCountRows');
                this.updateViewCurrentCountRows(component, currentCountRows + countRows);   
    
                let offsetRows = this.getView(component, 'offsetRows');
                this.updateViewOffsetRows(component, offsetRows + countRows);    
    
                this.proccessData(listData);  

                let newData = this.getView(component, 'data').concat(listData);

                console.log('DEBUG:PaymentsLineItemsTable:Helper:getData:', this.getView(component, 'data').length, this.getView(component, 'totalNumberRows'));
    
                if (this.getView(component, 'data').length >= this.getView(component, 'totalNumberRows')) {                 
                    this.setView(component, 'enableInfiniteLoading', false);                  
                    this.setView(component, 'loadMoreStatus', 'No more data to load');
                    console.log('DEBUG:getData:true');
                } else {              
                    this.setView(component, 'loadMoreStatus', 'Please wait ');
                    console.log('DEBUG:PaymentsLineItemsTable:Helper:getData:false');                    
                }
                
                this.setView(component, 'data', this.sortData(newData, this.getView(component, 'sortedBy')), this.getView(component, 'v.sortedDirection'));

                event.getSource().set('v.isLoading', false);

                let data = {
                    totalNumberRows: this.getView(component, 'currentCountRows'),
                    sortedBy: this.getLabelByColumnName(component, this.getView(component, 'sortedBy')),
                    lastModified: this.formatLastModified(this.lastModified)
                }                
                this.notify(component, 'change', data);
            }).catch(function(errors) {
                console.error('DEBUG:PaymentsLineItemsTable:Helper:getData:ERROR: ', errors);
            });   
        }
    },
    sortData: function (data, fieldName, sortDirection) {
        let reverse = (sortDirection !== 'asc');
   
        data.sort(this.sortBy(fieldName, reverse));

        return data;
    },
    sortBy: function(field, reverse, primer) {
        switch(field) {
            case 'sowUrl':
                field = 'contractNumber';
                break;
            case 'employeeUrl':
                field = 'employeeName';
                break;
            case 'totalHoursUrl':
            case 'totalHoursLabel':
                    field = 'totalMinutes';
                    break;
            case 'totalAmountLabel':
                field = 'totalAmount';
                break;
        }

        let key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return ((field === 'totalHours') ? (+x[field]) : x[field]);};

        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            console.log('DEBUG:PaymentsLineItemsTable:Helper:sort', field, key(a), key(b), key(a) > key(b), key(b) > key(a))
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
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

        console.log('DEBUG:DIPaymentsLineItemsTable:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DIPaymentsLineItemsTable:Helper:init:dependencies:array:', dependencies);
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
    handleChange: function(component, data) {}
})