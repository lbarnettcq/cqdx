({
    id: 'diModalDialogConfirm',
    childsData: [],
    config: {
        send: {
            title: ['Send'],
            description: ['Are you sure you want to send', '', 'to the client?'],
            hintFirst: ['Not every time report included into this timesheet is in Approved status.'],
            hintSecond: ['Sending this timesheet to client automatically mark these time entries as Approved and they will be locked for editing.']
        },
        delete: {
            title: ['Delete'],
            description: ['Are you sure you want to delete', '', '?']
        }, 
        approve: {
            title: ['Approve'],
            description: ['Are you sure you want to mark', '', 'approved?']
        },
        mark_paid: {
            title: ['Mark Paid'],
            description: ['Are you sure you want to mark', '', 'paid?'],
            showPaymentDate: true
        }
    },
    errors: [],
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
        this.updateContent(component);
    },
    updateContent: function(component) {
        let view = this.getView(component, 'view');

        switch(view) {
            case 'send':
            case 'delete':
            case 'approve':
            case 'mark_paid':
                let title = this.getView(component, 'title');
                let description = this.getView(component, 'description');

                this.setView(component, 'showPaymentDate', this.config[view].showPaymentDate);

                this.setView(component, 'paymentDate', moment().format('YYYY-MM-DD'));

                (!description) && this.setView(component, 'description', this.createText(component, view, 'description'));

                if(this.getView(component, 'showHint') == true) {
                    this.config[view].hintFirst && this.setView(component, 'hintFirst', this.createText(component, view, 'hintFirst'));
                    this.config[view].hintSecond && this.setView(component, 'hintSecond', this.createText(component, view, 'hintSecond'));
                } else {
                    this.setView(component, 'hintFirst', '');
                    this.setView(component, 'hintSecond', '');
                }
                break;
        }
    },
    updateView: function(component, data) {
        console.log('DEBUG: DIModalDialogHelper: updateView:', data.open, data.view, data.showHint);
    
        if(data.open) {
            distdlib.scroll.disable();
        }

        Object.keys(data).forEach(key => {
            if(key === 'open') {
                this.setView(component, 'opened', data[key]);
            } else {
                this.setView(component, key, data[key]);
            }
        });

        this.updateContent(component);
    },
    isReady: function(component) {
        return (this.getView(component, 'stateProcess') === 'ready');
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
        this.setView(component, 'view', null); 
        this.setView(component, 'name', null);   
        this.setView(component, 'title', null);  
        this.setView(component, 'description', null);
        this.setView(component, 'showHint', false); 
        distdlib.scroll.enable();        
    },
    cancel: function(component) {
        this.closeModal(component);
        this.resetErrors(component);
        this.notify(component, 'cancel');
    },
    submit: function(component) {
        if(this.validate(component)) {
            this.resetErrors(component);
            this.closeModal(component);

            let data = {};

            if(this.getView(component, 'showPaymentDate')) {
                data['paymentDate'] =  this.getView(component, 'paymentDate');
            }

            this.notify(component, 'submit', data);
        } else {
            this.setView(component, 'showError', true);
            this.setView(component, 'errorsFields',  'These required fields must be completed: ' + this.errors.join(', '));
        }
    },
    createText: function(component, view, field) {
        let text = '';

        this.config[view][field].forEach(value => {
            if(value) {
                text += ' ' + value;
            } else {
                let name = this.getView(component, 'name');
                (name) && (text += ' ' + name);
            }
        });

        return text;
    },
    update: function (component, data) {
        this.childsData.push(data);

        if(this.isReady(component)) {
            this.childsData.forEach(data => {
                console.log('Debug:DIModalDialogConfirm:Helper:update:data', data.id, data.name, data.view, data.title);
                if(distdlib.isObject(data)) {
                    this.updateView(component, data);                    
                 } else {
                    console.log('DEBUG: DiModalDialogController: update: not is object');
                 }                
            }); 

            this.childsData.length = 0;
        }
    },
    notify: function(component, action, data) {
        let params = {id: this.id, action: action, view: this.getView(component, 'view')};

        if(distdlib.isObject(data)) {
            params['data'] = data;
        }

        let changeEvent = component.getEvent('changeEvent');    
        changeEvent.setParams({data: params});
        changeEvent.fire();
    },
    validate: function(component) { 
        return true; 
        console.log('DEBUG:DIModalDialogConfirm:Helper valid:');      
        let errorMessage = this.getView(component, 'errorBlankField');
        this.errors = [];

        let success = true;

        if(this.getView(component, 'showPaymentDate')) {
            if(!this.getView(component, 'paymentDate')) {
                success = false;
                this.errors.push('Payment Date');
                let dateCmp = component.find("paymentDate");
                dateCmp.set("v.errors", [{message: errorMessage}]);
            }
        }

        console.log('DEBUG:DIModalDialogConfirm:Helper valid:success:', success);  
        return success;
    },
    resetErrors: function(component) {
        this.errors = [];
        this.setView(component, 'showError', false);
        this.setView(component, 'errorsFields',  this.errors.join(', '));
    },
})