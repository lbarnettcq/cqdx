({
    id: 'diInvoicesHeader',
    delimiter: ' • ',
    data: [],
    modalDialog: {
        id: null,
        action: null
    },
    loadedInvoiceInformation: false,
    invoice: null,
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:InvoicesHeader:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
        console.log('DEBUG:InvoicesHeader:Helper:init');
        this.updatePanelInformation(component);
        this.notify(component, 'init');         
    },
    updatePanelInformation : function(component) {
        console.log('DEBUG:InvoicesHeader:Helper:updatePanelInformation:');

        let invoiceId = this.getView(component, 'invoiceId');

        if(invoiceId) {
            let params = {
                invoiceId: invoiceId
            };

            this.sendRequest(component, 'c.getInformation', params)
            .then((data) => {
                console.log('DEBUG:InvoicesHeader: Load:Success: ', data);     
                if(distdlib.isObject(data.data) && distdlib.isObject(data.data.item)) {
                    this.invoice = data.data.item;

                    let invoiceNumber = 'Undefined';
                    if(this.invoice.invoiceNumber) {
                        invoiceNumber = this.invoice.invoiceNumber;
                    }

                    this.setView(component, 'details', invoiceNumber);

                    let lastModified = this.getView(component, 'lastModified');
                    if(this.invoice.lastModifiedDate) { 
                        lastModified = moment(this.invoice.lastModifiedDate).format('MM/DD/YYYY hh:mm A');
                    }
        
                    console.log('DEBUG:InvoicesHeader: Load:Success:status:', this.invoice.status);  
                    if(this.invoice.status) {
                        this.invoice.status = this.invoice.status.toLowerCase();
                    }

                    this.setView(component, 'status', this.invoice.status);

                    this.setView(component, 'panelInformation', this.createInformation(null, null, lastModified));

                    this.setView(component, 'loadedInvoiceInformation', true);
                }                
            })
            .catch((errors) => {
                console.error('DEBUG:InvoicesHeader: Load:Error: ', errors);
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

        console.log('DEBUG:DIInvoicesHeader:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DIInvoicesHeader:Helper:init:dependencies:array:', dependencies);
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
        console.log('DEBUG:InvoicesTable:Helper:showModalDialog', type);
        let modalDialog = null;
        let data = null;

        switch(type) {
            case 'mark_paid':
            case 'send':
            case 'delete':
                console.log('DEBUG:InvoicesTable:Helper:showModalDialog:update:before', type);
                modalDialog = component.find('diModalDialogConfirm');

                let actionTitle = distdlib.capitalizeFirstLetter((type === 'mark_paid') ? 'Mark Paid' : type);
                if(type === 'mark_paid'){
                    actionTitle = 'Mark Paid';
                }

                data = {
                    open: true,
                    view: type,
                    name: this.getView(component, 'details'),
                    title: actionTitle + ' Invoice'
                }

                this.modalDialog.id = 'diModalDialogConfirm';
                this.modalDialog.action = type;
                console.log('DEBUG:InvoicesTable:Helper:showModalDialog:update', type);
                modalDialog.update(data); 
                break;
            case 'edit':
                modalDialog = component.find('diModalDialogInvoice');

                data = {
                    open: true,
                    view: type,
                    accountId: this.invoice.accountId,
                    userId: this.invoice.userId,  
                    contractId: this.invoice.contractId,
                    startDate: this.invoice.startDate,
                    endDate: this.invoice.endDate,
                    issueDate: this.invoice.issueDate,
                    dueDate: this.invoice.dueDate,
                    invoiceNumber: this.invoice.invoiceNumber,
                    invoiceId: this.invoice.invoiceId,
                    contractResourceId: this.invoice.contractResourceId
                }

                modalDialog.update(data);
                break;
            case 'create':
                modalDialog = component.find('diModalDialogInvoice');

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
                console.log('DEBUG:InvoicesHeader:Helper:handleChange:diModalDialogConfirm', this.modalDialog);
                if(this.modalDialog.id == 'diModalDialogConfirm' && data['action'] == 'submit') {
                    switch(this.modalDialog.action) {
                        case 'send':
                        case 'delete':
                        case 'mark_paid':
                            console.log('DEBUG:InvoicesHeader:Helper:handleChange:action', this.modalDialog.action);                            
                            let invoiceId = this.getView(component, 'invoiceId');
                            invoiceId && this[this.modalDialog.action + 'Invoice'](component, invoiceId, data['data']);
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
    sendInvoice: function(component, invoiceId) {
        console.log('DEBUG:InvoicesHeader:Helper:sendInvoice');
        
        let params = {
            invoiceId: invoiceId
        };

        console.log('DEBUG:InvoicesHeader:Helper:sendInvoice: params:', params);

        this.sendRequest(component, 'c.updateStatus', params)
        .then((data) => {
            console.log('DEBUG:InvoicesHeader:Helper:sendInvoice: Load:Success:', data);
            this.clearModalDialogData();
            $A.get('e.force:refreshView').fire(); 
        })
        .catch((errors) => {
            console.error('DEBUG:InvoicesHeader:Helper:sendInvoice: Load:Error:', errors);
        });        
    },
    mark_paidInvoice: function(component, invoiceId, data) {
        console.log('DEBUG:InvoicesHeader:Helper:approveInvoice');
        
        let params = {
            invoiceId: invoiceId
        };

        if(distdlib.isObject(data)) {
            data.paymentDate && (params['paymentDate'] = data.paymentDate);
        }

        console.log('DEBUG:InvoicesHeader:Helper:approveInvoice: params:', params);

        this.sendRequest(component, 'c.updateStatus', params)
        .then((data) => {
            console.log('DEBUG:InvoicesHeader:Helper:updateInvoiceStatus: Load:Success:', data);
            this.clearModalDialogData();
            $A.get('e.force:refreshView').fire(); 
        })
        .catch((errors) => {
            console.error('DEBUG:InvoicesHeader:Helper:approveInvoice: Load:Error:', errors);
        }); 
    },
    deleteInvoice: function(component, invoiceId) {
        console.log('DEBUG:InvoicesHeader:Helper:deleteInvoice');
        
        let params = {
            invoiceId: invoiceId
        };

        console.log('DEBUG:InvoicesHeader:Helper:deleteInvoice: params:', params);

        this.sendRequest(component, 'c.deleteEntry', params)
        .then((data) => {
            console.log('DEBUG:InvoicesHeader:Helper:deleteInvoice: Load:Success:', data);
            this.clearModalDialogData();
            this.notify(component, 'change', {'action': 'showList'});      
        })
        .catch((errors) => {
            console.error('DEBUG:InvoicesHeader:Helper:deleteInvoice: Load:Error:', errors);
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
    getInvoiceUrl: function(component, invoiceId) {  
        let options = this.getView(component, 'options');

        console.log('DEBUG:DIInvoicesTable:Helper:getInvoiceUrl:options:', options);

        let url = null;

        if(options && options.invoicesUrl) {
            url = options.invoicesUrl;
        }
        
        let params = null;

        if(invoiceId) { 
            params = new Map([
                ['invoiceId', invoiceId],
            ])
        }

        return distdlib.location.createUrl(url, params);
    },
})