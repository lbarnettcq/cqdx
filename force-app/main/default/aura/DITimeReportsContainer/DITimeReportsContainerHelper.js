({
    childsData: [],
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
        console.log('DEBUG:TimeReportsTracking:doInit:params');
        this.clearEvents();

        let role = distdlib.location.getQueryVariable('c__role');
        let userId = distdlib.location.getQueryVariable('c__userId');
        let startDate = distdlib.location.getQueryVariable('c__startDate');
        let endDate = distdlib.location.getQueryVariable('c__endDate');        

        if(role === 'manager' &&
            typeof startDate !== 'undefined' && 
            typeof endDate !== 'undefined' && 
            typeof userId !== 'undefined'
        ) {
            let data = {
                userId: userId,
                startDate: startDate,
                endDate: endDate                
            };

            this.showDetailedView(component, data);
        } else {
            this.showListView(component);
        }        
    },
    showDetailedView: function(component, data) {
        console.log('DEBUG:TimeReportsContainer::Helper:showDetailedView', data);
        //distdlib.scroll.enable();

        this.setView(component, 'role', 'manager');

        this.setView(component, 'title', 'Time Reports');

        this.setView(component, 'userId', data.userId);
        this.setView(component, 'startDate', data.startDate);
        this.setView(component, 'endDate', data.endDate);
    },
    getView: function(component, view) {
        return component.get('v.' + view);
    },
    setView: function(component, view, value) {
        return component.set('v.' + view, value);
    },
    showListView: function(component) {    
        //distdlib.scroll.disable();    
        this.setView(component, 'title', 'Time Reports')
        this.setView(component, 'details', 'Time Reports');    
        this.setView(component, 'role', 'employee');    
    },
    updateHeaderView: function(component, data) {
        component.find('diTimeReportsHeader').update(data);
    },
    goToDetailView: function (params) {
        distdlib.location.open(null, params);
    },
    changeStateComponent: function(name, state, data) {
        if(typeof registeredComponents[name] !== 'undefined') {
            registeredComponents[name] = state;
            registeredComponents['data'] = data;
        }
    },
    handleChange: function(component, data) {
        this.childsData.push(data);

        if(this.isReady(component)) {
            this.childsData.forEach(data => {
                if(typeof data['id'] != 'undefined') {
                    switch(data['state']) {
                        case 'init':     
                            let handler = distdlib.event.createHandler(data);
                            console.log('DEBUG:TimeReports:Helper:handleChange:createHandler', handler);
                            handler && distdlib.event.subscribe(handler);
                            distdlib.event.notify(component, handler);
                            break;
                        case 'change':
                            console.log('DEBUG:TimeReports:Helper:handleChange:createHandler:change', data['id'], data['data'], data['state'], data['dependencies']);
                            distdlib.event.updateHandler(data);
                            distdlib.event.notify(component, distdlib.event.getHandler(data['id']));

                            console.log('DEBUG:TimeReports:Helper:handleChange:createHandler:change:data.data', data.data);

                            if(typeof data.data != 'undefined') {
                                if(data['id'] === 'diFilter') {
                                    switch (data.data.event) {
                                        case 'close':
                                            component.find('diTimeReportsHeader').set('v.showFilter', false);
                                            break;
                                    }
                                } else {
                                    if(data.data.showFilter !== 'undefined') {
                                        component.find('diTimeReportsTable').set('v.showFilter', data.data.showFilter);
                                    }                       
                                }
                            }

                      
                            break;
                        case 'details':
                        case 'edit':
                            if(data['id']  === 'diTimeReportsTable' &&
                                typeof data.data['startDate'] != 'undefined' && 
                                typeof data.data['endDate'] != 'undefined' && 
                                typeof data.data['userId'] != 'undefined'
                            ) {   
                                let params = new Map([
                                    ['c__userId', data.data.userId],            
                                    ['c__startDate', data.data.startDate],
                                    ['c__endDate', data.data.endDate],
                                    ['c__role', 'manager']
                                ]);
        
                                this.goToDetailView(params);
                            } else {
                                console.log('DEBUG:TimeReports:Helper:handleChange:else', data.data, data.data.startDate, data.data.endDate, data.data.employeeId);
                            }
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
    clearEvents: function() {
        distdlib.event.clear();
    }
})