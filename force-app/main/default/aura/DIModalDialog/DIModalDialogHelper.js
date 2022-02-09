({
    userId: null,
    startDate: null,
    endDate: null,    
    columns: [
        {id: 'c_check', prefix: 'c_', label: ''},
        {id: 'c_date', prefix: 'c_', label: 'Date'},
        {id: 'c_totalTime', prefix: 'c_', label: 'Total Time'},
        {id: 'c_totalExpenses', prefix: 'c_', label: 'Total Expenses'}
    ],
    rows: null,
    childsData: [],
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:DIDatePicker:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
        if(this.showModalDialog(component)) {
            this.load(component);
        }
    },
    load: function(component) {
        if(this.canLoad()) {
            this.updateMessage(component, true, 'Load data. Please wait...');

            let params = {
                employeeId: this.userId,
                startDate: this.startDate,
                endDate: this.endDate,
                status: component.get('v.type') == 'approve' ? 'unlocked' : 'approved'
            };

            let timesheetId = this.getView(component, 'timesheetId');

            if(timesheetId) {
                params['timesheetId'] = timesheetId;
            }

            this.sendRequest(component, 'c.getReport', params)
            .then((data) => {
                console.log('DEBUG:DiMoalDialogHelper: Load:Success: ', data);

                if(distdlib.isObject(data.data) && Array.isArray(data.data.list)) {
                    this.setView(component, 'columns', this.columns);
                    this.createRows(component, data.data.list);  
                    this.setView(component, 'rows', this.rows);

                    if(data.data.list.length === 0) {
                        this.setView(component, 'description', '');
                        this.updateMessage(component, true, 'This Time Report contains locked Time Entries included into Timesheet with status Paid. \nYou cannot unlock them.');
                    } else {
                        this.updateMessage(component, false, '');
                    }
                    
                } else {
                    this.updateMessage(component, true, 'Data are absent.');
                }
                
            })
            .catch((errors) => {
                console.error('DEBUG:DiMoalDialogHelper: Load:Error: ', errors);
            });

        } else {
            this.updateMessage(component, true, 'Data can not load. User or date range are absent');
        }
    },
    showModalDialog: function(component) {
        return (this.getView(component, 'opened') == true);
    },
    canLoad: function() {
        return (this.existUser() && this.startDate !== null && this.endDate !== null);
    },
    createRows: function(component, data) {
        this.rows = [];

        let selectedRows = false;

        let type = this.getView(component, 'type');

        let status = this.getView(component, 'status');

        console.log('DEBUG:DiMoalDialogHelper: createRows:status:type', status, type);

        data.forEach((item, index) => {
            let totalHours = distdlib.time.convert(item.totalMinutes, 'mm', 'hh:mm');

            let checked = false;
            let disabled = false;

            if(item.status === 'for_approval') {
                checked = true;
            }

            let classRow = '';
            
            switch(status) {
                //case 'approved':
                //case 'for_approval':
                case 'in_progress':
                    if(type === 'approve') {
                        if(item.status === 'approved') {
                            classRow = 'di-row-disabled';
                            disabled = true;
                        }
                    } else {
                        if(item.status === 'for_approval') {
                            classRow = 'di-row-disabled';
                            disabled = true;
                        } else {
                            checked = false;
                        }
                    }
                    break;
            }

            if(checked && !disabled) {
                selectedRows = true;
            }

            let currentDate = this.createDate(item.date);

            let totalExpenses = (distdlib.isNumeric(item.totalPrice)) ? distdlib.math.roundTo2Digit(item.totalPrice) : item.totalPrice;

            let row =  {
                id: index,
                prefix: 'r_',
                class: classRow,
                fields: {
                    check: {id: index+'c_check', rowId: index, columnId: 'c_check', value: checked, label: '', disabled: disabled},
                    date: {id: index+'c_date', rowId: index, columnId: 'c_date', value: item.date, label: currentDate.getDate() + ' ' + distdlib.date.months[currentDate.getMonth()].label + ' ' + currentDate.getFullYear()},
                    totalTime: {id: index+'c_totalTime', rowId: index, columnId: 'c_totalTime', value: totalHours, label: totalHours},
                    totalExpenses: {id: index+'c_totalExpenses', rowId: index, columnId: 'c_totalExpenses', value: totalExpenses, label: totalExpenses},
                },
            };
    
            this.rows.push(row);
        });


        this.setView(component, 'disableSubmit', !selectedRows);        
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
    existUser: function() {
        return this.getUserId() !== null;
    },
    getUserId: function() {
        return this.userId;
    },
    updateMessage: function(component, show, description) {
        this.setView(component, 'message', {show: show, description: description});
    },
    updateStatus: function(component, event, status) {
        if(typeof status !== 'undefined' && this.existUser()) {
            let dateList = [];

            let rows = component.get('v.rows');

            rows.forEach((row) => {
                if(row.fields.check.value && !row.fields.check.disabled) {
                    dateList.push(row.fields.date.value);
                }
            });


            let params = {
                dateList: dateList, 
                employeeId: this.getUserId(),
                status: status
            };

            let timesheetId =  component.get('v.timesheetId');
            if(timesheetId) {
                params['timesheetId'] = timesheetId;
            }
            
            this.sendRequest(component, 'c.setMultipleStatus', params)
            .then(result => {
                console.log('DEBUG:DIModalDialogHelper:updateStatus:SUCCESS:result', result);
                this.closeModal(component);
                $A.get('e.force:refreshView').fire();
            }).catch(function(errors) {
                console.error('DEBUG:DIModalDialogHelper:updateStatus:ERROR: ', errors);
            });
        }
    },
    updateView: function(component, data) {
        console.log('DEBUG: DIModalDialogHelper: updateView:', data.timesheetId,
        data.open, data.type, data.title, data.description, data.userId, data.startDate,data.endDate);
    
        if(data.open) {
            distdlib.scroll.disable();
        }

        if(data.timesheetId) {
            this.setView(component, 'timesheetId', data.timesheetId);
        }

        this.setView(component, 'opened', data.open);
        this.setView(component, 'type', data.type);
        this.setView(component, 'status', data.status);
        this.setView(component, 'title', data.title);
        this.setView(component, 'description', data.description);

        //approved
        //in_progress
        //for_approval

        switch(this.getView(component, 'type')) {
            case 'approve':
                this.setView(component, 'submitLabel', 'Approve');         
               break;
            case 'unlock':
                this.setView(component, 'submitLabel', 'Unlock');
               break;
         }

         this.userId = data.userId;
         this.startDate = data.startDate;
         this.endDate = data.endDate;     
         
         this.load(component);
    },
    updateSubmit: function(component) {
        let rows = component.get('v.rows');

        let enableSubmit =  rows.some((row) => {
            return row.fields.check.value && !row.fields.check.disabled;       
        });

        this.setView(component, 'disableSubmit', !enableSubmit);
    },
    getView: function(component, view) {
        return component.get('v.' + view);
    },
    setView: function(component, view, value) {
        return component.set('v.' + view, value);
    },
    openModal: function(component) {
        this.setView(component, 'opened', true);
        distdlib.scroll.disable();
    },
    closeModal: function(component) {
        this.setView(component, 'opened', false);
        distdlib.scroll.enable();
    },
    update: function (component, data) {
        this.childsData.push(data);

        if(this.isReady(component)) {
            this.childsData.forEach(data => {
                if(distdlib.isObject(data)) {
                    console.log('DEBUG: DiModalDialogHelper: update ', data.open, data.title, data.description, data.type, data.userId, data.startDate,data.endDate);
                    this.updateView(component, data);        
                 } else {
                    console.log('DEBUG: DiModalDialogHelper: update: not is object');
                 }     
            }); 

            this.childsData.length = 0;
        }
    },
    isReady: function(component) {
        return this.getView(component, 'stateProcess') === 'ready';
    },
    createDate: function(value) {
        return moment(value).toDate();
    }
})