({
    id: 'diTimeTrackingTable',
    config: {
        roles: {
            emplyeee: {},
            manager: {}
        }    
    },
    startInit: false,
    lastModified: null,
    message: {
        show: true,
        emptyList: {
            description: 'Please add the SOWs you are working on to start tracking your time'
        },
        startLoad: {
            description: 'Data is loaded. Please, wait.'
        },
        error: {
            description: 'Something wrong. Please, contact to administrator.'
        },
        default: {
            description: 'Data are empty for this date range and contracts'
        }
    },
    data: {
        products: [],
        list: [],
        employeeId: null
    },
    childsData: [],
    buttons: {
        save: {
            show: true,
            state: 'disabled'
        },
        cancel: {
            show: true,
            state: 'disabled'
        }
    },
    schema: {
        field: {id: 'string', rowId: 'string', columnId: 'string', value: 'string', type: 'string', format: 'hh:mm'},
        row: {
            id: 'string',
            prefix: 'string',
            name: 'string',
            fields: {
                name: null,
                monday: null,
                tuesday: null,
                wednesday: null,
                thursday: null,
                friday: null,
                saturday: null,
                sunday: null,
                sumTime: null,
                //action: null 
            },
        }
    },
    columns: [],    
    cells: [],
    rows: [],
    total: {
        name: 'TOTALS',
        monday: 0,
        tuesday: 0,
        wednesday: 0,
        thursday: 0,
        friday: 0,
        saturday: 0,
        sunday: 0,
        sum: 0,
    },
    errors: [],
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:TimeTrackingTable:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component);
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {  
        console.log('DEBUG:TimeTrackingTable:Helper:init', this.getRole(component), window.jQuery);

        let role = distdlib.location.getQueryVariable('c__role');
        let userId = distdlib.location.getQueryVariable('c__userId');
        let contractId = distdlib.location.getQueryVariable('c__contractId');
        let startDate = distdlib.location.getQueryVariable('c__startDate');
        let endDate = distdlib.location.getQueryVariable('c__endDate');

        if(typeof role != 'undefined') {
            this.setRole(component, role);
        }

        if(typeof userId != 'undefined') {
            this.clearUserIds(component);
            this.addUserId(component, userId);
        }

        if(typeof contractId != 'undefined') {time-tracking_background
            this.clearContractIds(component);
            this.addContractId(component, contractId);
        }

        if(typeof startDate != 'undefined' && typeof endDate != 'undefined') {
            let currentDate = {
                startDate: startDate,
                endDate: endDate,
                selectedDate: null
            };

            this.setDate(component, currentDate);
        }
        
        this.setMessage(component, true);
        this.initSchemaRow();

        console.log('DEBUG:TimeTrackingTable:Helper:init', this.existContractIds(component), this.existUserIds(component), this.existDate(component), this.getDate(component));

        if((this.existContractIds(component) || this.existUserIds(component)) && this.existDate(component)) {
            this.startInit = true;
            this.load(component);
        } else {
            this.notify(component, 'init');
        }
    },
    load: function(component) {
        console.log('DEBUG:TimeTrackingTable:Helper:canCreateColumns', this.canCreateColumns(component), this.existContractIds(component));
        if(this.canCreateColumns(component)) {
            this.createColumns(component);   
            this.updateViewColumns(component);   
            this.resetTotals();
            this.updateViewTotal(component);        
        }

        if(this.canLoad(component)) {
            this.errors.length = 0;
            this.setMessage(component, true, this.message.startLoad.description);
            console.log('DEBUG:TimeTrackingTable:Helper:canLoad:TRUE');
            let currentDate = this.getDate(component);
            console.log('DEBUG:TimeTrackingTable:Helper:canLoad:currentDate', currentDate);
            let params = {
                startDate: distdlib.date.addZero(this.createDate(currentDate.startDate)), 
                endDate: distdlib.date.addZero(this.createDate(currentDate.endDate))
            };

            if(this.existContractIds(component)) {
                params['contractIds'] = this.getContractIds(component);
            }

            if(this.existUserIds(component)) {
                params['userIds'] = this.getUserIds(component);
            } 

            if(this.usePreviousWeek(component)) {
                params['previousWeek'] = true;
            }
            
            console.log('DEBUG:TimeTrackingTable:Helper:Promise:all:BEFORE:', params);
            Promise.all([
                //this.sendRequest(component, 'c.getProducts', {}, 'products'), 
                this.sendRequest(component, 'c.getList', params, 'list')
            ]).then(list => {
                console.log('DEBUG:TimeTrackingTable:Helper:Promise:all:SUCCESS:', list);
                if(list.length > 0) {
                    for(let i = 0; i < list.length; i++) {
                        let items = list[i];
                        //console.log('DEBUG:TimeTrackingTable:Helper:Promise:all:SUCCESS:iterable:', items, items['products'], typeof items['products']);
                        /*if(typeof items['products'] !== 'undefined' && Array.isArray(items['products']['data'])) {
                            this.data.products = items['products']['data'];                   
                        }*/
                        console.log('DEBUG:TimeTrackingTable:Helper:all:SUCCESS:iterable:', items, items['list'], typeof items['list']);
                        if(typeof items['list'] !== 'undefined' && distdlib.isObject(items['list']['data']) && Array.isArray(items['list']['data']['list'])) {
                            this.data.list = items['list']['data']['list'];                   
                        }
                    }  
    
                    this.createTimesheetsEntries(component);
                    console.log('DEBUG:TimeTrackingTable:Helper:Promise:all:SUCCESS:before: notify:');

                    let currentDate = this.getDate(component);
                    let startDate = this.createDate(currentDate.startDate);
                    let endDate = this.createDate(currentDate.endDate);

                    //details += ' ' + startDate.getDate() + ' ' + distdlib.date.months[startDate.getMonth()].label;
                    //details += ' - ' + endDate.getDate() + ' ' + distdlib.date.months[endDate.getMonth()].label;

                    let data = {
                        lastModified: moment(this.lastModified).fromNow(),
                        contractIds: this.getContractIds(component),
                        employeeId: this.data.employeeId, 
                        startDate: distdlib.date.addZero(startDate),
                        endDate: distdlib.date.addZero(endDate),
                        state: this.getView(component, 'stateTable'),
                    };

                    if(this.existUserIds(component)) {
                        data.userId = this.getUserIds(component)[0];
                    }

                    if(this.startInit) {
                        this.startInit = false;    
                        console.log('DEBUG:TimeTrackingTable:Helper:Promise:all:SUCCESS:notify:', data);
                        this.notify(component, 'init', data);
                    } else {
                        this.notify(component, 'change', data); 
                    }
                } else {
                    this.notify(component, 'init', data);
                    this.setMessage(component, true, this.message.emptyList.description);
                }               
            }).catch(function(errors) {
                console.error('DEBUG:TimeTrackingTable:Helper:Promise:all:ERROR: ');
                //this.setMessage(component, true, this.message.error.description);
            });      
        } else {            
            console.log('DEBUG:TimeTrackingTable:Helper:canLoad:FALSE');
        }
    },
    initSchemaRow: function() {
        this.schema.row = {
                id: 'string',
                prefix: 'string',
                name: 'string',
                fields: {
                    name: this.field,
                    monday: this.field,
                    tuesday: this.field,
                    wednesday: this.field,
                    thursday: this.field,
                    friday: this.field,
                    saturday: this.field,
                    sunday: this.field,
                    sumTime: this.field,
                    //action: this.field 
                },
        };
    },
    sendRequest: function(cmp, methodName, params, category) {
        return new Promise($A.getCallback(function(resolve, reject) {
            let action = cmp.get(methodName);

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
    createTimesheetsEntries: function(component) {
        console.log('DEBUG:TimeTrackingTable:Helper:createTimesheetsEntries:', this.data);    
        this.createRows(component);

        this.calculateTotals();

        this.updateStateTable(component);

        this.initButtons();

        this.setMessage(component, false);

        this.updateViewColumns(component);   
        this.updateViewRows(component);
        this.updateViewTotal(component);
        this.updateViewButtons(component);
        //this.notify(component, 'init');        
    },
    //TODO: Convert to Promise
    api: {
        products: {
            get: function(component, ctx, resolve, reject) {
                console.log('DEBUG:TimeTrackingTable:Helper:api:products:get', ctx.data);

                let action = component.get('c.getProductsList');
                action.setParams({
                    'attribute' : 'attribute1'
                });

                action.setCallback(ctx, function(a) {
                    console.log('DEBUG:TimeTrackingTable:Helper:api:products:get:response:');
                    let state = a.getState();
                    if(state == 'SUCCESS') {
                        let products = a.getReturnValue();

                        if(Array.isArray(products)) {       
                            console.log('DEBUG:TimeTrackingTable:Helper:api:products:get:Response:SUCCESS', ctx.data);               
                            ctx.data.products = products;
                            ctx.createRows(component);
                            ctx.updateAttrRows(component);
                            ctx.updateTotal(component);
                            console.log('DEBUG:TimeTrackingTable:Helper:api:products:get:Response:SUCCESS1', ctx.data);   
                            ctx.notify(component, 'init');
                        } else {
                            console.log('DEBUG:TimeTrackingTable:Helper:api:products:get:Response:SUCCESS', 'Products hasn\'t array schema');
                        }                       
                    }
                });
                $A.enqueueAction(action);
            }
        },
    },
    formatProductLabel: function(item) {
        return (item['accountName'] + ', ' + 'SOW ' + item['contractNumber'] + ', ' + item['productName']);
    },
    createRows: function(component) {
       let rows = []; 

       let existTimesheets = {};

       this.clearContractIds(component);

       let cellsWithoutState = [];

        let hideEmptyRow = this.hideEmptyRows(component);

       for(let i = 0; i < this.data.list.length; i++) {
            let record = this.data.list[i];
        
            if(typeof record['contractId'] !== 'undefined') {
                this.addContractId(component, record['contractId']);
            }

            if(!hideEmptyRow ||  (hideEmptyRow && record.timesheetEntriesList.length > 0)) {
                let row = {
                    id: record['contractId'],
                    contractId: ((record['contractId']) ?  record['contractId'] : null),
                    prefix: 'r',
                    product: {
                        id: record['productId'],
                        name: record['productName']
                    },
                    fields: {
                        name: {id: '', rowId: '', columnId: '', value: this.formatProductLabel(record), newValue: null, type: 'string', format: '*', excludeCalculate: true, state: null},
                        monday: {id: '', rowId: '', columnId: '', value: '', newValue: null, type: 'time', format: 'hh:mm', excludeCalculate: false, state: null},
                        tuesday: {id: '', rowId: '', columnId: '', value: '', newValue: null, type: 'time', format: 'hh:mm', excludeCalculate: false, state: null},
                        wednesday: {id: '', rowId: '', columnId: '', value:'', newValue: null, type: 'time', format: 'hh:mm', excludeCalculate: false, state: null},
                        thursday: {id: '', rowId: '', columnId: '', value: '', newValue: null, type: 'time', format: 'hh:mm', excludeCalculate: false, state: null},
                        friday: {id: '', rowId: '', columnId: '', value: '', newValue: null, type: 'time', format: 'hh:mm', excludeCalculate: false, state: null},
                        saturday: {id: '', rowId: '', columnId: '', value: '', newValue: null, type: 'time', format: 'hh:mm', excludeCalculate: false, state: null},
                        sunday: {id: '', rowId: '', columnId: '', value: '', newValue: null, type: 'time', format: 'hh:mm', excludeCalculate: false, state: null},
                        sumTime: {id: '', rowId: '', columnId: '', value: '', newValue: null, type: 'time', format: 'hh:mm', excludeCalculate: true, state: null},
                        //action: {id: 'r_1_c_10', rowId: 'r_1', columnId: 'c_10', value: '', type: 'icon', format: 'url'}
                    }
                }
    
                this.data.employeeId = record['employeeId'];
    
                for(let j = 0; j < this.columns.length; j++) {
                    let column = this.columns[j];
    
                    let cell = row.fields[column['idDay']];
    
                    if(distdlib.isObject(cell)) {
                        cell['rowId'] = row['id'];
                        cell['columnId'] = column['id'];
    
                        console.log('DEBUG:TimeTrackingTable:Helper:createRows:Result:COLUMN:', column);
    
                        for(let i = 0; i < record.timesheetEntriesList.length; i++) {
                            let item = record.timesheetEntriesList[i];
            
                            if(existTimesheets[row['id'] + '_' + column['id']]) continue;
            
                            if(/*item['Product__c'] == row['id'] && */item['Date__c'] == column['id']) {                            
                                if(item['Is_Approved__c']) {
                                    column['state']['countLock']++;
                                } else {
                                    column['state']['countUnlock']++;
                                }
                                
                                column['state']['count']++;
    
                                if(column['state']['countLock'] === column['state']['total']) {
                                    column['state']['type']= 'lock';
                                } else if(column['state']['countUnlock'] === column['state']['total']) {
                                    column['state']['type']= 'unlock';
                                } else {
                                    column['state']['type']= 'progress';
                                }                       
    
                                if(this.lastModified) {
                                    if((this.createDate(item['LastModifiedDate'])) > (this.createDate(this.lastModified))) {
                                        this.lastModified = item['LastModifiedDate'];
                                    }               
                                } else {
                                    this.lastModified = item['LastModifiedDate'];
                                }
    
                                existTimesheets[row['id'] + '_' + column['id']] = true;
    
                                console.log('DEBUG:TimeTrackingTable:Helper:createRows:Result:COLUMN:CELL', item['Product__c'], item['Date__c'] , column['idDay']);
                            
                                cell['id'] = item['Id'];                         
                                cell['value'] = (item['Minutes__c']) || item['Minutes__c'] == 0 ? distdlib.time.convert(item['Minutes__c'], 'mm', 'hh:mm') : '';
    
                                cell['state'] = (item['Is_Approved__c'] ? 'lock' : 'unlock');
    
                                console.log('DEBUG:TimeTrackingTable:Helper:Convert:Minutes__c', row.product.name,  item['Date__c'], item['Id'], item['Minutes__c'], cell['value']);
                                break;
                            }
                        }
    
                        if(cell['state'] == null) {
                            cellsWithoutState.push(cell);
                        }
                    }                
                }
    
                rows.push(row);
            }
        }

       this.rows = rows;

       cellsWithoutState.forEach(cell => {
           cell['state'] = 'unlock';
           /*for(let i = 0; i < this.columns.length; i++) {
               let column = this.columns[i];

               if(column['id'] == cell['columnId']) {
                if(column['state']['count'] == 0 || column['state']['count'] != column['state']['countLock']) {
                    cell['state'] = 'unlock';
                } else {
                    cell['state'] = 'lock';
                }
                break;
               }                
           }*/            
       });

       console.log('DEBUG:TimeTrackingTable:Helper:createRows:Result:TABLE:', this.rows, this.columns);
    
       return this.rows;
    },
    updateViewColumns: function(component) {
        this.setView(component, 'columns', this.columns);
    },
    updateViewRows: function(component){
        console.log('DEBUG:TimeTrackingTable:Helper:updateViewRows:', this.rows);
        this.setView(component, 'rows', this.rows);
    },
    updateViewTotal: function(component) {
        this.setView(component, 'total', this.total);
    },
    updateViewMessage: function(component) {
        console.log('DEBUG:TimeTrackingTable:Helper:updateViewMessage', this.message);
        this.setView(component, 'message', this.message);        
    },
    updateViewButtons: function(component) {
        console.log('DEBUG:TimeTrackingTable:Helper:updateViewButtons', this.buttons);
        this.setView(component, 'buttons', this.buttons);        
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

        if(this.errors.length == 0) {
            params['status'] = 'success';
        } else {
            params['status'] = 'error';
            params['errors'] = {
                list: this.errors
            };
        }

        let changeEvent = component.getEvent('changeEvent');    
        changeEvent.setParams({data: params});
        changeEvent.fire();
    },
    setDate: function(component, date) {
        this.setView(component, 'startDate', date.startDate);
        this.setView(component, 'endDate', date.endDate);
        this.setView(component, 'selectedDate', date.selectedDate);
    },
    getDate: function(component) {
        let result = {
            startDate: this.getView(component, 'startDate'),
            endDate: this.getView(component, 'endDate'),
            selectedDate: this.getView(component, 'selectedDate'),
        };

        return result;
    },
    existDate: function(component) {
        let date = this.getDate(component);
        return !!(date.startDate && date.endDate);
    },
    updateDependency: function(id, state) {
        if(typeof dependencies[id] != 'undefind') {
            dependencies[id]['state'] = state;
        }
    },
    getArrayDependencies: function(component) {        
        let dependencies = this.getView(component, 'dependencies');

        console.log('DEBUG:DITimeTrackingTable:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DITimeTrackingTable:Helper:init:dependencies:array:', dependencies);
            return dependencies;
        }

        return [];
    },
    canLoad: function(component) {     
        let existContracts = false;

        let dependencies = this.getArrayDependencies(component);

        dependencies.forEach((dependency) => {
            if(dependency === 'diMenu') {
                existContracts = this.existContractIds(component);
                if(!existContracts) {
                    this.setMessage(component, true, this.message.emptyList.description);
                }
            }
        });
       
        return !!((existContracts || this.existUserIds(component)) && this.canCreateColumns(component));
    },
    canCreateColumns: function(component) {
        return this.existDate(component);
    },
    setMessage: function(cmp, show, description) {
        if(typeof show !== 'undefined') {
            this.message.show = show;
        }
    
        if(typeof description !== 'undefined') {
            this.message.description = description;
        }

        this.updateViewMessage(cmp);
    },
    resetTotals: function() {
        Object.keys(this.total).forEach(key => {
            if(key != 'name') {
                this.total[key] = 0;
            }            
        });
    },
    calculateTotals: function() {
        this.resetTotals();

        let formatFrom = null;
        let formatTo = null;

        switch(this.schema.field.format.toLowerCase()) {
            case 'hh:mm': 
                formatFrom = 'hh:mm';
                formatTo = 'mm';
                break;
        }

        for(let i = 0; i < this.rows.length; i++) {
            let row = this.rows[i];

            let totalRow = 0;

            console.log('DEBUG:TimeTrackingTable:Helper:calculateTotals:', row);

            Object.keys(row.fields).forEach(field => {
                if(!row.fields[field].excludeCalculate) {
                    let time = (row.fields[field].value) ? row.fields[field].value : 0;

                    time = distdlib.time.convert(time, formatFrom, formatTo);

                    totalRow += time;

                    if(typeof this.total[field] !== 'undefined' && field != 'name') {
                        this.total[field] += time;
                    }
                }             
            });

            this.total['sum'] += totalRow;

            row.fields['sumTime'].value = distdlib.time.convertToHoursAndMinutes(totalRow);
        }

        console.log('DEBUG:TimeTrackingTable:Helper:calculateTotals:this.total', this.total);

        Object.keys(this.total).forEach(key => {
            if(key !== 'sum' && key !== 'name') {
                this.total[key] = distdlib.time.convertToHoursAndMinutes(this.total[key]);                   
            }
        });

        this.total['sum'] = distdlib.time.convertToHoursAndMinutes(this.total['sum']);
    },
    createColumns: function(component) {
        let dates = [
            {id: 'c_1', prefix: 'c', title: '', day: '', date: '', addDate: false, state: {count: 0, countUnlock: 0, countLock: 0, total: 0, type: 'lock', useIcon: false}}
        ];

        let startDay = 0;
        let endDay = 6;
        let maxDays = (endDay - startDay + 1);

        let currentDate = this.getDate(component);

        let startDate = this.createDate(currentDate.startDate);
        startDate = this.createDate(startDate.setDate(startDate.getDate() + (startDay - (startDate.getDay()))));

        let endDate = this.createDate(currentDate.endDate);
        endDate = this.createDate(endDate.setDate(endDate.getDate() + (endDay - (endDate.getDay()))));

        let countDays = 0;

        console.log('DEBUG:DATE:', startDate, ':', endDate);

        while(countDays < maxDays/* && startDate <= endDate*/) {
            let column =  {
                id: (startDate.getFullYear() + '-' + distdlib.addZeroToValue(startDate.getMonth() + 1) + '-' + distdlib.addZeroToValue(startDate.getDate())),
                //id: 'c_' + (startDate.getDay()+2), 
                prefix: 'c', 
                idDay: distdlib.date.daysWeek[startDate.getDay()].name,
                label: distdlib.date.daysWeek[startDate.getDay()].label, 
                day: startDate.getDay(), 
                date: startDate.getDate() + ' ' + distdlib.date.months[startDate.getMonth()].label,
                addDate: true,
                state: {count: 0, countUnlock: 0, countLock: 0, total: 0, type: '', useIcon: true}
            };

            console.log('DEBUG:TimeTrackingTable:Helper:createColumns:columns',  column);

            dates.push(column);

            startDate.setDate(startDate.getDate()+1);
            countDays++;
        }
    
        dates.push({id: 'c_' + (dates.length + 1), prefix: 'c', title: '', label: 'WEEKLY', day: '', date: 'TOTAL', addDate: true, state: {count: 0, countUnlock: 0, countLock: 0, total: 0, type: 'lock', useIcon: false}});
        
        this.columns = dates;

        console.log('DEBUG:TimeTrackingTable:Helper:createColumns:columns',  this.columns);

    },
    initButtons: function() {
        this.buttons =  {
            save: {
                show: true,
                state: 'disabled'
            },
            cancel: {
                show: true,
                state: 'disabled'
            }
        }
    },
    changeCell: function(component, event) {
        console.log('DEBUG:TimeTrackingTable:Helper:changeCell:init'); 
        //let source = event.getSource();
        //let data = source.get('v.tdata');

        let data = event.getParam('data');

        let newCell = {id: data.id, rowId: data.rowId, columnId: data.columnId, value: data.value, newValue: data.newValue};

        console.log('DEBUG:TimeTrackingTable:Helper:changeCell:Before', newCell);   

        let existCell = false;
        
        let state = 'disabled';

        let newCells = [];

        this.cells.forEach(cell => {
            if(cell.rowId == newCell.rowId && cell.columnId == newCell.columnId) {
                cell.value = newCell.value;
                cell.newValue = newCell.newValue;
                existCell = true;
            }

            if(cell.value != cell.newValue) {
                state = 'enabled';
                newCells.push(cell);
            }
        })

        if(!existCell) {
            newCells.push(newCell);

            if(newCell.value != newCell.newValue) {
                state = 'enabled';
            }
        }

        this.cells = newCells;

        this.buttons.cancel.state = state;
        this.buttons.save.state = state;

        this.updateViewButtons(component);

        console.log('DEBUG:TimeTrackingTable:Helper:changeCell:cells', this.cells);      
    },
    deleteTimesheetEntry: function(component, entryId, field) {
        console.log('DEBUG:TimeTrackingTable:Helper:deleteTimesheetEntry:Before', entryId);

        if(typeof entryId === 'undefined') {
            return false;
        }

        let params = {
            timesheetEntryId: entryId
        }

        if(this.existUserIds(component)) {
            params.userId = this.getUserIds(component)[0];
        }

        console.log('DEBUG:TimeTrackingTable:Helper:deleteTimesheetEntry:BEFORE:SEND', entryId);
        this.sendRequest(component, 'c.deleteEntry', params)   
        .then(result => {
            console.log('DEBUG:TimeTrackingTable:Helper:deleteTimesheetEntry:SUCCESS:', result);
            if(result.status === 'success') {
                field['id'] = null;   
                field.value = null;
                field.newValue = null; 
            } else {
                this.processServerErrors(result);
                this.notify(component, 'change'); 
            }
        }).catch(errors => {
            console.error('DEBUG:TimeTrackingTable:Helper:deleteTimesheetEntry:ERROR: ', errors);
        });     
    },
    updateTimesheetEntry: function(component, entryId, minutes) {
        console.log('DEBUG:TimeTrackingTable:Helper:updateTimesheetEntry:Before', entryId, minutes);

        if(typeof entryId === 'undefined' || typeof minutes === 'undefined') {
            return false;
        }

        let params = {
            timesheetEntryId: entryId,
            minutes:  minutes
        }

        if(this.existUserIds(component)) {
            params.userId = this.getUserIds(component)[0];
        }

        console.log('DEBUG:TimeTrackingTable:Helper:updateTimesheetEntry:BEFORE:SEND', entryId, minutes);
        this.sendRequest(component, 'c.updateEntry', params)   
        .then(data => {
            console.log('DEBUG:TimeTrackingTable:Helper:updateTimesheetEntry:SUCCESS:', data);
        }).catch(errors => {
            console.error('DEBUG:TimeTrackingTable:Helper:updateTimesheetEntry:ERROR: ', errors);
        });     
    },
    insertTimesheetEntry: function(component, contractId, productId, date, minutes, field) {
        console.log('DEBUG:TimeTrackingTable:Helper:insertTimesheetEntry:BEFORE:', this.getContractIds(component), productId, date, minutes);
        
        if(contractId && productId && date && minutes !== null && minutes !== '') {
            let params = { 
                contractId: contractId,                
                productId: productId, 
                createdDate: date,
                minutes:  minutes                
            }

            if(this.existUserIds(component)) {
                params.userId = this.getUserIds(component)[0];
            }
    
            this.sendRequest(component, 'c.insertEntry', params)   
            .then(result => {
                console.log('DEBUG:TimeTrackingTable:Helper:insertTimesheetEntry:SUCCESS:', result);
                if(result.status === 'success') {
                    field['id'] = result.data.list[0].Id;    
                } else {
                    this.processServerErrors(result);
                    this.notify(component, 'change'); 
                }
            }).catch(errors => {
                console.error('DEBUG:TimeTrackingTable:Helper:insertTimesheetEntry:ERROR: ', errors);
            });  
        } else {
            return false;
        }
    },
    handlerButtonCancelClick: function(component) {
        console.log('DEBUG:TimeTrackingTable:Helper:handlerButtonCancelClick:Before');   
        this.cells.length = 0;

        this.buttons.cancel.state = 'disabled';
        this.buttons.save.state = 'disabled';
        console.log('DEBUG:TimeTrackingTable:Helper:handlerButtonCancelClick:After');   
        this.updateViewRows(component);
        this.updateViewButtons(component);
    },
    handlerButtonSaveClick: function(component) {
        console.log('DEBUG:TimeTrackingTable:Helper:handlerButtonSaveClick');  
        this.cells.forEach(cell => {
            console.log('DEBUG:TimeTrackingTable:Helper:handlerButtonSaveClick:Cell', cell);

            this.errors.length = 0;
            this.notify(component, 'change');

            this.rows.forEach(row => {
                if(row.id == cell.rowId) {
                    console.log('DEBUG:TimeTrackingTable:Helper:handlerButtonSaveClick:Row', row.fields, cell.rowId);
                    let fields = Object.keys(row.fields);

                    for(let i = 0; i < fields.length; i++) {
                        let field = row.fields[fields[i]];
                        console.log('DEBUG:TimeTrackingTable:Helper:handlerButtonSaveClick:Column:Before', field);
                        if(field['columnId'] == cell.columnId) {
                            console.log('DEBUG:TimeTrackingTable:Helper:handlerButtonSaveClick:Column:After:', field, cell);
                            field.value = cell.newValue;
                            field.newValue = null;
                            console.log('DEBUG:TimeTrackingTable:Helper:handlerButtonSaveClick:Column:After:field.value', field.value);
                            let hours = distdlib.time.convert(field.value, 'hh:mm', 'mm');

                            if(field['id']) {
                                let entryId = field['id'];  
                                console.log('DEBUG:TimeTrackingTable:Helper:handlerButtonSaveClick:Column:After:updateTimesheetEntry', field.value === null, entryId, hours);
                                if(field.value === null || field.value === '') {
                                    this.deleteTimesheetEntry(component, entryId, field); 
                                } else {
                                    this.updateTimesheetEntry(component, entryId, hours);
                                }
                            } else {
                                let productId = row.product.id; 
                                let date = cell.columnId;
                                console.log('DEBUG:TABLE:Helper:handlerButtonSaveClick:Column:After:insertTimesheetEntry', productId, date, hours);
                                this.insertTimesheetEntry(component, row.contractId, productId, date, hours, field);
                            }
                        }                          
                    }           
                }
            });
        });

        this.cells = [];

        this.buttons.cancel.state = 'disabled';
        this.buttons.save.state = 'disabled';

        this.calculateTotals();

        this.updateViewRows(component);
        this.updateViewTotal(component);
        this.updateViewButtons(component);
    },
    clearUserIds: function(component) {
        this.setView(component, 'userIds', []);
    },
    addUserId: function(component, userId) {
        if(userId === null) {
            return false;
        }

        let userIds = this.getUserIds(component);

        if(userIds.indexOf(userId) === -1) {
            userIds.push(userId);
        }
       
        this.setView(component, 'userIds', userIds);

        return true;
    },
    getUserIds: function(component) {
        let userIds = this.getView(component, 'userIds');

        if(Array.isArray(userIds)) {
            return userIds;
        } else {
            return [];
        }
    },
    existUserIds: function(component) {
        let userIds = this.getUserIds(component);

        return (userIds.length > 0);
    },
    clearContractIds: function(component) {
        this.setView(component, 'contractIds', []);
    },
    addContractId: function(component, contractId) {
        if(contractId === null) {
            return false;
        }

        let contractIds = this.getContractIds(component);

        if(contractIds.indexOf(contractId) === -1) {
            contractIds.push(contractId);
        }
       
        this.setView(component, 'contractIds', contractIds);

        return true;
    },
    addContractIds: function(component, contractIds) {
        if(contractIds === null) {
            return false;
        }
       
        this.setView(component, 'contractIds', contractIds);

        return true;
    },
    getContractIds: function(component) {
        let contractIds = this.getView(component, 'contractIds');

        if(Array.isArray(contractIds)) {
            return contractIds;
        } else {
            return [];
        }
    },
    existContractIds: function(component) {
        let contractIds = this.getContractIds(component);

        return (contractIds.length > 0);
    },
    getRole: function(component) {
        return this.getView(component, 'role');
    },
    setRole: function(component, role) {
        return this.getView(component, 'role', role);
    },
    updateStateTable: function(component) {
        let countStatesCells = {
            lock: 0,
            unlock: 0,
            count: 0
        };

        this.columns.forEach((column) => {
            countStatesCells.lock += column.state.countLock;
            countStatesCells.unlock += column.state.countUnlock;
            countStatesCells.count += column.state.count;

            if(column.state.count === 0) {
                column.state.type = 'unlock';
            } else {
                if(column.state.countLock == column.state.count) {
                    column.state.type = 'lock';
                    countStatesCells.lock++;
                } else {
                    column.state.type = 'unlock';
                    countStatesCells.unlock++;
                }
    
                countStatesCells.count++;
            }

        });

        let state = '';

        if(countStatesCells.count === countStatesCells.unlock) {
            state = 'for_approval';
        } else  if(countStatesCells.count === countStatesCells.lock) {
            state = 'approved';
        } else {
            state = 'in_progress';
        }

        console.log('DEBUG:DITimeTrackingTableHelper:updateStateTable:columns', this.columns, countStatesCells);
        this.setView(component, 'stateTable', state)
    }, 
    update: function (component, data) {
        this.childsData.push(data);
        console.log('DEBUG:TimeTrackingTable:Helper:update:init:test:', data.id,  data.state, data.data['diMenu']);    
        if(this.isReady(component)) {
            this.childsData.forEach(data => {  
                console.log('DEBUG:TimeTrackingTable:Helper:update:test:', distdlib.isObject(data));            
                if(distdlib.isObject(data)) {
                    console.log('DEBUG:TimeTrackingTable:Helper:update:test:data', data);
                    let date = null;

                    switch(data.id) {
                        case 'diTimeTrackingTable': 
                            console.log('DEBUG:TimeTrackingTable:Helper:Update:Params:diTable', data.id,  data.state, data.data['diDatePicker'], data.data['diMenu']); 
        
                            if(distdlib.isObject(data.data)) {
                                if(data.data['diDatePicker'] && data.data['diDatePicker']['data']) {                           
                                    let datePickerData = data.data['diDatePicker']['data'];
                                   
                                    console.log('DEBUG:TimeTrackingTable:Helper:Update:Params:diTable:diDatePicker', datePickerData.startDate, datePickerData.endDate);
                                    let date = {
                                        startDate: datePickerData.startDate,
                                        endDate: datePickerData.endDate,
                                        selectedDate: datePickerData.selectedDate
                                    };
                                    this.setDate(component, date);                                                      
                                }
        
                                if(data.data['diMenu'] && data.data['diMenu']['data']) {
                                    let contractData = data.data['diMenu'];
                                    console.log('DEBUG:TimeTrackingTable:Helper:Update:Params:diTable:contractData', contractData.data); 
                                    if(distdlib.isObject(contractData) && distdlib.isObject(contractData.data) && (typeof contractData.data.contractIds != 'undefined')) {
                                        this.clearContractIds(component);
                                        this.addContractIds(component, contractData.data.contractIds);

                                        date = {
                                            startDate: contractData.data.startDate,
                                            endDate: contractData.data.endDate,
                                            selectedDate: contractData.data.selectedDate
                                        };
                                        this.setDate(component, date);
                                    }                      
                                }
                            }
        
                            this.load(component);                    
                            break;
                        case 'diMenu': 
                            console.log('DEBUG:TimeTrackingTable:Helper:Update:Params:diMenu', data.id,  data.state,  data.data.sow, data.data.client, data.data.contractIds);      
                            this.clearContractIds(component);
                            this.addContractIds(component, data.data.contractIds);

                            date = {
                                startDate: data.data.startDate,
                                endDate: data.data.endDate,
                                selectedDate: data.data.selectedDate
                            };
                            this.setDate(component, date);

                            this.load(component);
                            break;
                        case 'diDatePicker':
                            console.log('DEBUG:TimeTrackingTable:Helper:Update:Params:diDatePicker', data.id,  data.state,  data.data.startDate, data.data.endDate, data.data.selectedDate);      
                            date = {
                                startDate: data.data.startDate,
                                endDate: data.data.endDate,
                                selectedDate: data.data.selectedDate
                            };
                            this.setDate(component, date);
                            this.load(component);
                            break;
                        default: {
                            console.log('DEBUG:TimeTrackingTable:Helper:Update:Params:default', data.action, data.data.startDate, data.data.endDate, data.data.userId);      
                            switch(data.action) {
                                case 'load':
                                    date = {
                                        startDate: data.data.startDate,
                                        endDate: data.data.endDate,
                                        selectedDate: null
                                    };
                                    
                                    if(typeof data.data.userId != 'undefined') {
                                        this.clearUserIds(component);
                                        this.addUserId(component, data.data.userId);
                                    }
                                 
                                    if(typeof data.data.contractId != 'undefined') {
                                        this.clearContractIds(component);
                                        this.addContractIds(component, data.data.contractIds);
                                    }
        
                                    this.setDate(component, date);                            
                                    this.load(component);
                                    break;
                            }
                        }
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
    createDate: function(value) {
        return moment(value).toDate();
    },
    hideEmptyRows: function(component) {
        let options = this.getView(component, 'options');
        return options && options.hideEmptyRows;
    },
    usePreviousWeek: function(component) {
        let options = this.getView(component, 'options');
        return options && options.previousWeek;
    },
    processServerErrors: function(result) {
        let errorMessage = '';

        if(result.errors) {
            if(Array.isArray(result.errors.list) && result.errors.list.length > 0) {                        
                let list = result.errors.list;

                list.forEach(error => {
                    if(distdlib.isObject(error)) {
                        errorMessage += ' ' + error.message;
                    } else {
                        errorMessage += ' ' + error;
                    }
                });
            } else {
                errorMessage = result.errors.message;
            }
        } else {
            errorMessage = 'Something wrong. Please, contact with support';
        }

        this.errors.push({message: errorMessage});
    },
})