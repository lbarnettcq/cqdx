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
            case 'send':
            case 'edit':
            case 'delete':
                helper.showModalDialog(component, event, action.name);
                break;
            case 'mark_approved':
                helper.showModalDialog(component, event, 'approve');                
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
    handleSelect: function(component, event, helper) {},
    updateSelectedText : function(component, event, helper) {
        let selectedRows = event.getParam('selectedRows');

        helper.setView(component, 'selectedRowsCount' ,selectedRows.length);

        let obj =[] ; 
        for (let i = 0; i < selectedRows.length; i++) {            
            obj.push({Name:selectedRows[i].Name});            
        }
        
        helper.setView(component, 'selectedRowsDetails', JSON.stringify(obj));
        helper.setView(component, 'selectedRowsList', event.getParam('selectedRows'));
    },
    /*handleChange: function(component, event, helper) {
        let filterText = event.getSource().get('v.value');
        console.log('DEBUG:TimesheetsTable:Controller:handleChange:SUCCESS:', filterText,  helper.getView(component, 'searchValue'));
    },*/
    handleChange: function(component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        let data = event.getParam('data');

        console.log('DEBUG:TimesheetsTable:Controller:handleChange', data['id'], data['action']);

        helper.handleChange(component, data);
    },
    handleClickRefresh: function(component, event, helper) {
        console.log('DEBUG:TimesheetsTable:Controller:handleClickRefresh:SUCCESS:');
    },
    handleClickFilter: function(component, event, helper) {
        console.log('DEBUG:TimesheetsTable:Controller:handleClickFilter:SUCCESS:');
    },
    handleSaveEdition: function (cmp, event, helper) {
        let draftValues = event.getParam('draftValues');
        console.log('DEBUG:TimesheetsTable:Controller:handleSaveEdition:', draftValues);
    },
    handleCancelEdition: function (cmp) {
        console.log('DEBUG:TimesheetsTable:Controller:handleCancelEdition:');
    }
})