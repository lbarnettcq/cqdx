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
            sortedBy: helper.getLabelByColumnName(component, helper.getView(component, 'sortedBy')),
            lastModified: helper.formatLastModified(helper.lastModified)
        }                
        helper.notify(component, 'change', data);
    },
    handleChange: function(component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        let data = event.getParam('data');

        console.log('DEBUG:PaymentsLineItemsTable:Controller:handleChange', data['id'], data['action']);

        helper.handleChange(component, data);
    }
})