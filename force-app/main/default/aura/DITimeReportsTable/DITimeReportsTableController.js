({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    loadMoreData: function(component, event, helper) {
        helper.getData(component, event);
    },
    updateColumnSorting: function(component, event, helper) {
        let fieldName = event.getParam('fieldName');
        helper.updateViewSort(component, fieldName);       

        let sortDirection = event.getParam('sortDirection');
        helper.setView(component, 'sortedDirection', sortDirection);

        helper.setView(component, 'data', helper.sortData(helper.getView(component, 'data'), fieldName, sortDirection));

        //TODO: extract method
        let data = {
            totalNumberRows: helper.getView(component, 'currentCountRows'),
            sortedBy: helper.getLableByColumnName(component, helper.getView(component, 'sortedBy')),
            lastModified: helper.formatLastModified(helper.lastModified)
        }                
        helper.notify(component, 'change', data);
    },
    handleHeaderAction: function(component, event, helper) {  
        let actionName = event.getParam('action').name;
        let columnDefinition = event.getParam('columnDefinition');
        let columns = helper.getView(component, 'columns');
        let activeFilter = helper.getView(component, 'activeFilter');

        if (actionName !== activeFilter) {
            let index = columns.indexOf(columnDefinition);
            let actions = columns[index].actions;

            actions.forEach(action => {
                action.checked = (action.name === actionName);
            });

            helper.setView(component, 'activeFilter', actionName);
            helper.updateBooks(component);
            helper.setView(component, 'columns', columns);
        }
    },
    handleRowAction: function(component, event, helper) {
        let action = event.getParam('action');     

        switch (action.name) {
            case 'mark_approved':
                helper.showModalDialog(component, event, 'approve');                
                break;
            case 'unlock':
                helper.showModalDialog(component, event, 'unlock');
                break;
            case 'edit':
                helper.editData(component, event);               
                break;
            case 'details':
                helper.detailsData(component, event);
                break;
        }
    },
    filter: function(component, event, helper) {
        let data = helper.getView(component, 'data');
        let term = helper.getView(component, 'filter');
        let results = data;

        try {
            let regex = new RegExp(term, 'i');            
            results = data.filter(row => regex.test(row.name) || regex.test(row.age.toString()));// filter checks each row, constructs new array where function returns true
        } catch(e) {
            // invalid regex, use full list
        }
        helper.setView(component, 'filteredData', results);
    },
    updateSelectedText : function(component, event, helper) {
        let selectedRows = event.getParam('selectedRows');

        helper.setView(component, 'selectedRowsCount' , selectedRows.length);

        let obj =[] ; 
        for (let i = 0; i < selectedRows.length; i++) {            
            obj.push({Name:selectedRows[i].Name});            
        }
        
        helper.setView(component, 'selectedRowsDetails', JSON.stringify(obj));
        helper.setView(component, 'selectedRowsList', event.getParam('selectedRows'));
    },
    update: function (component, event, helper) {
        let params = event.getParam('arguments');
        let data = params['data'];

        console.log('DEBUG:EVENT:CHAINS:TABLE', data.id,  data.state);
        helper.update(component, data);
    },
    handleClickRefresh: function(component, event, helper) {
        console.log('DEBUG:handleClickRefresh:SUCCESS:');
    },
    handleClickFilter: function(component, event, helper) {
        console.log('DEBUG:handleClickFilter:SUCCESS:');
    },
    handleSaveEdition: function (cmp, event, helper) {
        let draftValues = event.getParam('draftValues');
        console.log('DEBUG:handleSaveEdition:', draftValues);
    },
    handleCancelEdition: function (cmp) {
        console.log('DEBUG:handleCancelEdition:');
    },
    handleChange: function(component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        let data = event.getParam('data');

        helper.handleChange(component, data);
    }
})