({
    id: 'diPaymentsHeader',
    delimiter: ' • ',
    data: [],
    modalDialog: {
        id: null,
        action: null,
        mark_paid: {
            title: 'Mark Paid Payment'
        },
        send: {
            title: 'Send Payment'
        },
        delete: {
            title: 'Delete Payment'
        }
    },
    loadedPaymentInformation: false,
    payment: null,
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:PaymentsHeader:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
        console.log('DEBUG:PaymentsHeader:Helper:init');
        this.updatePanelInformation(component);
        this.notify(component, 'init');         
    },
    updatePanelInformation : function(component) {
        console.log('DEBUG:PaymentsHeader:Helper:updatePanelInformation:');

        let paymentId = this.getView(component, 'paymentId');

        if(paymentId) {
            let params = {
                paymentId: paymentId
            };

            this.sendRequest(component, 'c.getInformation', params)
            .then((data) => {
                console.log('DEBUG:PaymentsHeader: Load:Success: ', data);     
                if(distdlib.isObject(data.data) && distdlib.isObject(data.data.item)) {
                    this.payment = data.data.item;

                    let paymentNumber = 'Undefined';
                    if(this.payment.paymentNumber) {
                        paymentNumber = this.payment.paymentNumber;
                    }

                    this.setView(component, 'details', paymentNumber);

                    let lastModified = this.getView(component, 'lastModified');
                    if(this.payment.lastModifiedDate) { 
                        lastModified = moment(this.payment.lastModifiedDate).format('MM/DD/YYYY hh:mm A');
                    }
        
                    console.log('DEBUG:PaymentsHeader: Load:Success:status:', this.payment.status);  
                    if(this.payment.status) {
                        this.payment.status = this.payment.status.toLowerCase();
                    }

                    this.setView(component, 'status', this.payment.status);

                    this.setView(component, 'panelInformation', this.createInformation(null, null, lastModified));

                    this.setView(component, 'loadedPaymentInformation', true);
                }                
            })
            .catch((errors) => {
                console.error('DEBUG:PaymentsHeader: Load:Error: ', errors);
            });
        } else {
            let totalNumberRows = this.getView(component, 'totalNumberRows');
            let sortedBy = this.getView(component, 'sortedBy');
            let lastModified = this.getView(component, 'lastModified');
            this.setView(component, 'panelInformation', this.createInformation(totalNumberRows, sortedBy, lastModified));
        }
    },
    createInformation: function(totalNumberRows, sortedBy, lastModified) {
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

        console.log('DEBUG:DIPaymentsHeader:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DIPaymentsHeader:Helper:init:dependencies:array:', dependencies);
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
    showModalDialog: function(component, event, type) {
        console.log('DEBUG:PaymentsTable:Helper:showModalDialog', type);
        let modalDialog = null;
        let data = null;

        switch(type) {
            case 'mark_paid':
            case 'send':
            case 'delete':
                console.log('DEBUG:PaymentsTable:Helper:showModalDialog:update:before', type);
                modalDialog = component.find('diModalDialogConfirm');

                data = {
                    open: true,
                    view: type,
                    name: this.getView(component, 'details'),
                    title: this.modalDialog[type]['title']
                }

                this.modalDialog.id = 'diModalDialogConfirm';
                this.modalDialog.action = type;
                console.log('DEBUG:PaymentsTable:Helper:showModalDialog:update', type);
                modalDialog.update(data); 
                break;
            case 'edit':
                modalDialog = component.find('diModalDialogPayment');

                data = {
                    open: true,
                    view: type,
                    paymentTypeId: this.payment.paymentType,
                    receiverId: this.payment.receiverId,
                    paymentId: this.payment.paymentId,
                    paymentNumber: this.payment.paymentNumber,
                    startDate: this.payment.startDate,
                    endDate: this.payment.endDate,
                    paidInvoices: this.payment.paidInvoices,
                    pendingInvoices: this.payment.pendingInvoices,
                    pendingInvoicesStartDate: this.payment.pendingInvoicesStartDate
                }

                modalDialog.update(data);
                break;
            case 'create':
                modalDialog = component.find('diModalDialogPayment');

                data = {
                    open: true,
                    view: type,     
                }

                modalDialog.update(data);
                break;
        }
    },
    handleChange: function(component, data) {
        switch(data['id']) {
            case 'diModalDialogConfirm':
                console.log('DEBUG:PaymentsHeader:Helper:handleChange:diModalDialogConfirm', this.modalDialog);
                if(this.modalDialog.id == 'diModalDialogConfirm' && data['action'] == 'submit') {
                    switch(this.modalDialog.action) {
                        case 'send':
                        case 'delete':
                        case 'mark_paid':
                            console.log('DEBUG:PaymentsHeader:Helper:handleChange:action', this.modalDialog.action);                            
                            let paymentId = this.getView(component, 'paymentId');
                            paymentId && this[this.modalDialog.action + 'Payment'](component, paymentId, data['data']);
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
    },
    sendPayment: function(component, paymentId) {
        console.log('DEBUG:PaymentsHeader:Helper:sendPayment');
        
        let params = {
            paymentId: paymentId
        };

        console.log('DEBUG:PaymentsHeader:Helper:sendPayment: params:', params);

        this.sendRequest(component, 'c.updateStatus', params)
        .then((data) => {
            console.log('DEBUG:PaymentsHeader:Helper:sendPayment: Load:Success:', data);
            this.clearModalDialogData();
            $A.get('e.force:refreshView').fire(); 
        })
        .catch((errors) => {
            console.error('DEBUG:PaymentsHeader:Helper:sendPayment: Load:Error:', errors);
        });        
    },
    mark_paidPayment: function(component, paymentId, data) {
        console.log('DEBUG:PaymentsHeader:Helper:approvePayment');
        
        let params = {
            paymentId: paymentId
        };

        if(distdlib.isObject(data)) {
            data.paymentDate && (params['paymentDate'] = data.paymentDate);
        }

        console.log('DEBUG:PaymentsHeader:Helper:approvePayment: params:', params);

        this.sendRequest(component, 'c.updateStatus', params)
        .then((data) => {
            console.log('DEBUG:PaymentsHeader:Helper:updatePaymentStatus: Load:Success:', data);
            this.clearModalDialogData();
            $A.get('e.force:refreshView').fire(); 
        })
        .catch((errors) => {
            console.error('DEBUG:PaymentsHeader:Helper:approvePayment: Load:Error:', errors);
        }); 
    },
    deletePayment: function(component, paymentId) {
        console.log('DEBUG:PaymentsHeader:Helper:deletePayment');
        
        let params = {
            paymentId: paymentId
        };

        console.log('DEBUG:PaymentsHeader:Helper:deletePayment: params:', params);

        this.sendRequest(component, 'c.deleteEntry', params)
        .then((data) => {
            console.log('DEBUG:PaymentsHeader:Helper:deletePayment: Load:Success:', data);
            this.clearModalDialogData();
            this.notify(component, 'change', {'action': 'showList'});         
        })
        .catch((errors) => {
            console.error('DEBUG:PaymentsHeader:Helper:deletePayment: Load:Error:', errors);
        }); 
    },
    clearModalDialogData: function() {
        this.modalDialog.id = null;
        this.modalDialog.action = null;
    },
    hideView: function(component, view) {
        //$A.util.toggleClass(toggleText, "toggle");
        $A.util.addClass(button, 'invisible');
    },
    getPaymentUrl: function(component, paymentId) {  
        let options = this.getView(component, 'options');

        console.log('DEBUG:DIPaymentsTable:Helper:getPaymentUrl:options:', options);

        let url = null;

        if(options && options.paymentsUrl) {
            url = options.paymentsUrl;
        }
        
        let params = null;

        if(paymentId) { 
            params = new Map([
                ['paymentId', paymentId],
            ])
        }

        return distdlib.location.createUrl(url, params);
    },
})