({
    childsData: [],
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:TimeTrackingContainer:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init();
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    changeStateComponent: function(name, state, data) {
        if(typeof registeredComponents[name] !== 'undefined') {
            registeredComponents[name] = state;
            registeredComponents['data'] = data;
        }
    },
    init: function() {
        this.clearEvents();
    },
    handleChange: function(component, data) {
        this.childsData.push(data);

        if(this.isReady(component)) {
            this.childsData.forEach(data => {
                if(typeof data['id'] != 'undefined') {
                    switch(data['state']) {
                        case 'init':   
                            this.checkErrors(component, data);
                            this.updateLabel(component, data);

                            let handler = distdlib.event.createHandler(data);
                            console.log('DEBUG:TimeTrackingContainer:Helper:handleChange:createHandler', handler);
                            handler && distdlib.event.subscribe(handler);
                            distdlib.event.notify(component, handler);
                            break;
                        case 'change':
                            this.checkErrors(component, data);
                            this.updateLabel(component, data);

                            console.log('DEBUG:EVENT:CHAINS:TimeTrackingContainer:Helper:Change', data['id'], data['state'], data['data'], data['dependencies']);
                            console.log('DEBUG:TIMESHEET:TimeTrackingContainer:Helper:handleChange:createHandler:change', data['id'], data['data'], data['state'], data['dependencies']);

                            distdlib.event.updateHandler(data);
                            distdlib.event.notify(component, distdlib.event.getHandler(data['id']));
                            break;
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
    clearEvents: function() {
        distdlib.event.clear();
    },
    checkErrors: function(component, data) {
        if(data.status === 'error') {
            if(distdlib.isObject(data.errors) && Array.isArray(data.errors.list)) {
                this.setView(component, 'errors', data.errors.list);
            }        
        }  else {
            this.setView(component, 'errors', null);
        }
    },
    updateLabel: function(component, data) {
        if(distdlib.isObject(data['data']) && data['data']['state']) {
            this.setView(component, 'stateLabel', data['data']['state']);
        }
    }
})