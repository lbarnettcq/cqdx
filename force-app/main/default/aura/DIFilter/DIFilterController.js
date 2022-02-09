({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    handleShowPopover: function (component, event, helper) {
        console.log('debug:handleShowPopover');

        let id = event.currentTarget.dataset.popoverId;

        console.log('debug:handleShowPopover:', id);

        $('#'+id).popoverX('show');
    },
    handleClose: function (component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        helper.closeAllPopovers(component);

        helper.notify(component, 'change', {'event': 'close'});
    },
    handleAddFilter: function(component, event, helper) {
        helper.addFilter(component, event);
    },
    handleRemoveFilter: function(component, event, helper){
        event.preventDefault();
        event.stopPropagation();

        let id = event.currentTarget.dataset.rowId;

        let countListViewFieldCriteria = 0;
        let listViewFieldCriteria = helper.getView(component, 'listViewFieldCriteria');

        let showPanelButtons = false;
        let countNewListViewFieldCriteria = 0;
        let removedNewFieldCriteria = false;

        listViewFieldCriteria.forEach(field => {
            if(field.previous.column === '') {
                countNewListViewFieldCriteria++;
            }

            if(field.id == id) {
                field.removed = true;

                if(field.previous.column !== '') {
                    showPanelButtons = true;
                } else {
                    removedNewFieldCriteria = true;
                }
            } else {
                countListViewFieldCriteria++;
            }
        });
        
        if(!showPanelButtons) {
            if(removedNewFieldCriteria && (countNewListViewFieldCriteria === 1)) {
                showPanelButtons = false;
            }
        }

        console.log('DEBUG:listViewFieldCriteria:data', listViewFieldCriteria);

        helper.closeAllPopovers(component);

        if(countListViewFieldCriteria == 0) {
            helper.setView(component, 'showFilterLogic', false);            
            helper.setView(component, 'showFilterLogicText', false);
        }

        helper.setView(component, 'listViewFieldCriteria', listViewFieldCriteria);

        helper.setView(component, 'showPanelButtons', showPanelButtons);
    },
    handleRemoveAll: function(component, event, helper) {
        let listViewFieldCriteria = helper.getView(component, 'listViewFieldCriteria');

        if(listViewFieldCriteria.length > 0) {
            helper.setView(component, 'listViewFieldCriteria', []);
            helper.setView(component, 'showFilterLogic', false);            
            helper.setView(component, 'showFilterLogicText', false);

            let showPanelButtons = listViewFieldCriteria.some(field => {
                return (field.previous.column != null);
            });

            helper.setView(component, 'showPanelButtons', showPanelButtons);      
        }

        helper.closeAllPopovers(component);

        helper.updateVisiblePanelButtons(component);
    },
    handleAddFilterLogic: function(component, event, helper) {
        helper.setView(component, 'showFilterLogicText', true);
        helper.closeAllPopovers(component);
    },
    handleRemoveFilterLogic: function(component, event, helper) {
        helper.setView(component, 'showFilterLogicText', false);
        helper.closeAllPopovers(component);
    },
    handleCancel: function(component, event, helper) {
        helper.revertDefaultState(component);
    },
    handleSave: function(component, event, helper) {
        helper.saveCurrentState(component);
    },
    handleSaveChangesField: function(component, event, helper) {
        let id = event.currentTarget.dataset.targetId;

        let listViewFieldCriteria = helper.getView(component, 'listViewFieldCriteria');

        let showPanelButtons = false;

        listViewFieldCriteria.some(field => {
            if(field.id == id) {
                if(field.next.column !== field.current.column) {  
                    field.current.label = field.next.label;                 
                    field.current.column = field.next.column;
                    field.hasBeenEdited = true;
                    showPanelButtons = true;
                } 
                
                if(field.next.value !== field.current.value) {
                    field.current.value = field.next.value;
                    field.hasBeenEdited = true;
                    showPanelButtons = true;
                } 
                
                if(field.next.operator_previous !== field.current.operator) {
                    field.current.operator = field.next.operator;
                    field.hasBeenEdited = true;
                    showPanelButtons = true;
                }
            }
        });

        helper.setView(component, 'listViewFieldCriteria', listViewFieldCriteria);
        helper.closeAllPopovers(component);
        helper.setView(component, 'showPanelButtons', showPanelButtons); 
    },
    handleChangeFilterLogic: function(component, event, helper) {
       let filterLogic = helper.getView(component, 'filterLogic');

       if(filterLogic.current.text != filterLogic.previous.text) {
            helper.setView(component, 'showPanelButtons', true);
       } else {
           helper.showPanelButtons(component);
       }
    }
})