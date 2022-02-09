({
    id: 'diFilter',
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        if(process[currentState] == previousState) {
            console.log(':DEBUG:FILTER:helper:ready');
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {  
        console.log('DEBUG:listViewFieldCriteria:init');
        let table = this.getView(component, 'table');

        if(table) {
            let fields = this.getView(component, 'fields');

            if(!fields) {
                this.getFields(component);
            } else {
                let listViewScope = this.getView(component, 'listViewScope');
                let listViewFieldCriteria = this.getView(component, 'listViewFieldCriteria');

                if(listViewScope.length === 0 || listViewFieldCriteria.legth === 0) {
                    this.getHistory(component);
                }
            }
        }
    },
    getFields: function(component) {
        let fields = {
            'startDate': {
                'label': 'Start date',
                'operators': [
                    {'label': 'equals', 'value': 'EQUALS'},
                    {'label': 'not equal', 'value': 'NOT_EQUAL'},
                    {'label': 'less than', 'value': 'LESS_THAN'},
                    {'label': 'greater than', 'value': 'GREATER_THAN'},
                    {'label': 'less or equal', 'value': 'LESS_OR_EQUAL'},
                    {'label': 'greater or equal', 'value': 'GREATER_OR_EQUAL'},
                    {'label': 'contains', 'value': 'CONTAINS'},
                    {'label': 'not contain', 'value': 'NOT_CONTAIN'},
                    {'label': 'starts with', 'value': 'STARTS_WITH'},
                ],
                'defaultOperator': 'EQUALS',
                'defaultValue': '15 Dec 2019',
            },
            'endDate': {
                'label': 'End date',
                'operators': [
                    {'label': 'equals', 'value': 'EQUALS'},
                    {'label': 'not equal', 'value': 'NOT_EQUAL'},
                    {'label': 'less than', 'value': 'LESS_THAN'},
                    {'label': 'greater than', 'value': 'GREATER_THAN'},
                    {'label': 'less or equal', 'value': 'LESS_OR_EQUAL'},
                    {'label': 'greater or equal', 'value': 'GREATER_OR_EQUAL'},
                    {'label': 'contains', 'value': 'CONTAINS'},
                    {'label': 'not contain', 'value': 'NOT_CONTAIN'},
                    {'label': 'starts with', 'value': 'STARTS_WITH'},
                ],
                'defaultOperator': 'EQUALS',
                'defaultValue': '21 Dec 2019',
            },
            'name': {
                'label': 'Name',
                'operators': [
                    {'label': 'equals', 'value': 'EQUALS'},
                    {'label': 'not equal', 'value': 'NOT_EQUAL'},
                    {'label': 'less than', 'value': 'LESS_THAN'},
                    {'label': 'greater than', 'value': 'GREATER_THAN'},
                    {'label': 'less or equal', 'value': 'LESS_OR_EQUAL'},
                    {'label': 'greater or equal', 'value': 'GREATER_OR_EQUAL'},
                    {'label': 'contains', 'value': 'CONTAINS'},
                    {'label': 'not contain', 'value': 'NOT_CONTAIN'},
                    {'label': 'starts with', 'value': 'STARTS_WITH'},
                ],
                'defaultOperator': 'EQUALS',
                'defaultValue': 'User User',
            },
            'hoursTotal': {
                'label': 'Hours Total',
                'operators': [
                    {'label': 'equals', 'value': 'EQUALS'},
                    {'label': 'not equal', 'value': 'NOT_EQUAL'},
                    {'label': 'less than', 'value': 'LESS_THAN'},
                    {'label': 'greater than', 'value': 'GREATER_THAN'},
                    {'label': 'less or equal', 'value': 'LESS_OR_EQUAL'},
                    {'label': 'greater or equal', 'value': 'GREATER_OR_EQUAL'},
                    {'label': 'contains', 'value': 'CONTAINS'},
                    {'label': 'not contain', 'value': 'NOT_CONTAIN'},
                    {'label': 'starts with', 'value': 'STARTS_WITH'},
                ],
                'defaultOperator': 'EQUALS',
                'defaultValue': '48:51',
            },
            'status': {
                'label': 'Status',
                'operators': [
                    {'label': 'equals', 'value': 'EQUALS'},
                    {'label': 'not equal', 'value': 'NOT_EQUAL'},
                    {'label': 'less than', 'value': 'LESS_THAN'},
                    {'label': 'greater than', 'value': 'GREATER_THAN'},
                    {'label': 'less or equal', 'value': 'LESS_OR_EQUAL'},
                    {'label': 'greater or equal', 'value': 'GREATER_OR_EQUAL'},
                    {'label': 'contains', 'value': 'CONTAINS'},
                    {'label': 'not contain', 'value': 'NOT_CONTAIN'},
                    {'label': 'starts with', 'value': 'STARTS_WITH'},
                ],
                'defaultOperator': 'EQUALS',
                'defaultValue': 'For Approval',
            },
        };

        this.setView(component, 'fields', fields);

        this.getHistory(component);
    },
    getHistory: function(component) {
        let listViewScope = [];
        let selectedValueViewScope = null;

        this.setView(component, 'selectedValueViewScope', selectedValueViewScope)
        this.setView(component, 'listViewScope', listViewScope);

        let listViewFieldCriteria =  [];

        this.setView(component, 'listViewFieldCriteria', listViewFieldCriteria);

        if(this.getCountListViewFieldCriteria(component) > 0) {
            this.setView(component, 'showFilterLogic', true);
        }

        let filterLogic = {
            previous: {
                text: ""
            },
            current: {
                text: ""
            }
        };

        this.setView(component, 'filterLogic', filterLogic);

        this.setView(component, 'showFilterLogicText', filterLogic.current.text.length > 0); 

        this.setView(component, 'showPanelButtons', false);
    },
    addFilter: function(component, event) {
        console.log('debug:helper:addFilter:init:');
        let picklistValues = [];

        let supportedOperators = [];

        let defaultColumn = null;
        let defaultValue = null;
        let defaultLabel = null;
        let defaultOperator = null;
        
        let listViewFieldCriteria = this.getView(component, 'listViewFieldCriteria');

        let fields = this.getView(component, 'fields');

        console.log('debug:helper:addFilter:fields:', fields);

        Object.keys(fields).forEach((name, index) => {
            let field = fields[name];

            picklistValues.push({'label': field.label, 'value': name});

            if(index === 0) {
                field.operators.forEach(operator => {
                    supportedOperators.push({'label': operator.label, 'value': operator.value});
                });

                defaultColumn = name;
                defaultValue = field.defaultValue;
                defaultLabel = field.label;
                defaultOperator = field.defaultOperator;
            }
        });

        console.log('debug:handleAddFilter:listViewFieldCriteria:', listViewFieldCriteria);

        let  filter =  {
            'id': listViewFieldCriteria.length, 
            'prefix': 'filter_', 
            'hasBeenEdited': true,
            'removed': false,
            'previous': {
                'column': '', 
                'value': '', 
                'label': '',  
                'operator': '', 
            },
            'current': {
                'column': '', 
                'value': '', 
                'label': 'New Filter*', 
                'operator': '', 
            },
            'next': {
                'column': defaultColumn, 
                'value': defaultValue, 
                'label': defaultLabel, 
                'operator': defaultOperator, 
            },  
            'dataType': 'string', 
            'picklistValues': picklistValues,  
            'supportedOperators': supportedOperators, 
            'isEditable': true, 
            'entityKeyPrefixOrApiName': 'timereports'
        };

        listViewFieldCriteria.push(filter);

        this.setView(component, 'listViewFieldCriteria', listViewFieldCriteria);       

        console.log('--DEBUG--listViewFieldCriteria', listViewFieldCriteria);

        let countEditedListViewFieldCriteria = 0;
        let countListViewFieldCriteria = 0;

        listViewFieldCriteria.forEach((field) => {
            countListViewFieldCriteria++;

            if(field.hasBeenEdited) {
                countEditedListViewFieldCriteria++;
            }
        });

        if(countListViewFieldCriteria == 1) {
            this.setView(component, 'showFilterLogic', true);    
        }

        let showPanelButtons = this.setView(component, 'showPanelButtons');

        if(countEditedListViewFieldCriteria > 1 && !showPanelButtons) {
            this.setView(component, 'showPanelButtons', true);
        }

        this.closeAllPopovers(component);

        setTimeout(() => {
            $('[data-target="#'+filter.prefix + filter.id+'"]').popoverButton();
            $('#' + filter.prefix + filter.id).popoverX('show');
        }, 0);
    },
    closeAllPopovers: function(component) {
        $('.popover').popoverX('hide');
    },
    getCountListViewFieldCriteria: function(component) {
        let listViewFieldCriteria = this.getView(component, 'listViewFieldCriteria');

        let countListViewFieldCriteria = listViewFieldCriteria.reduce((accumulator, field) => {
            if(!field.removed) {
                accumulator++;
            }

            return accumulator;

        }, 0);

        //helper.setView(component, 'countListViewFieldCriteria', countListViewFieldCriteria);

        return countListViewFieldCriteria;
    },
    getView: function(component, view) {
        return component.get('v.' + view);
    },
    setView: function(component, view, value) {
        return component.set('v.' + view, value);
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

        if(dependencies && Array.isArray(dependencies)) {
            return dependencies;
        }

        return [];
    },
    isReady: function(component) {
        return (this.getView(component, 'stateProcess') === 'ready');
    },
    updateVisiblePanelButtons: function(component) {
        let listViewFieldCriteria = this.getView(component, 'listViewFieldCriteria');

        let showPanelButtons = false;

        listViewFieldCriteria.forEach(field => {
            if(!field.previous.column) {
                if(field.removed) {
                    return;
                } else {
                    if(field.current.column && field.current.value && field.current.operator) {
                        showPanelButtons = true;
                    }
                }
            } else if(field.hasBeenEdited) {
                showPanelButtons = true;
            }
        });

        this.setView(component, 'showPanelButtons', showPanelButtons);
    },
    revertDefaultState: function(component) {
        let listViewFieldCriteria = this.getView(component, 'listViewFieldCriteria');

        listViewFieldCriteria = listViewFieldCriteria.filter(field => {
            if(field.previous.column) {
                field.current.column = field.previous.column;
                field.current.value = field.previous.value;
                field.current.label = field.previous.label;
                field.current.operator = field.previous.operator;
            }

            return !!field.previous.column;
        });

        this.closeAllPopovers(component);
        this.setView(component, 'showPanelButtons', false); 
        this.setView(component, 'listViewFieldCriteria', listViewFieldCriteria);
    },
    saveCurrentState: function(component) {
        let listViewFieldCriteria = this.getView(component, 'listViewFieldCriteria');

        listViewFieldCriteria = listViewFieldCriteria.filter(field => {
            if(!field.removed && field.current.column && field.current.value && field.current.operator && field.current.label) {
                field.hasBeenEdited = false;
                field.previous.column = field.current.column;
                field.previous.value = field.current.value;
                field.previous.label = field.current.label;
                field.previous.operator = field.current.operator;

                return true;
            }

            return false;
        });

        this.closeAllPopovers(component);
        this.setView(component, 'showPanelButtons', false); 
        this.setView(component, 'listViewFieldCriteria', listViewFieldCriteria);
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
})