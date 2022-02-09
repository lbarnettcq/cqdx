({
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:TimeTrackingHeader:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    notify: function(component, id) {
        console.log('DEBUG:TimeTrackingHeader:Helper:notify');
        let changeEvent = component.getEvent('changeEvent');
        changeEvent.setParams({data: {id: id, state: 'init', dependencies: this.getArrayDependencies(component)}});
        changeEvent.fire();
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
    getArrayDependencies: function(component) {        
        let dependencies = this.getView(component, 'dependencies');

        console.log('DEBUG:DITimeTrackingHeader:Helper:init:dependencies:', dependencies);

        if(dependencies && Array.isArray(dependencies)) {
            console.log('DEBUG:DITimeTrackingHeader:Helper:init:dependencies:array:', dependencies);
            return dependencies;
        }

        return [];
    }
})