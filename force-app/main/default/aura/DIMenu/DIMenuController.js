({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    handleClickIconList: function(component, event, helper) {
        console.log('DEBUG:DIMenu:Controler:handleClickIconList:', helper.getView(component, 'state'));
        helper.toogle(component);
        event.preventDefault();
        event.stopPropagation();
        return false;
    },
    hanldeClickItemList: function(component, event, helper) {
        console.log('DEBUG:DIMenu:Controller:hanldeClickItemList:', event.target, event.target.tagName);
        let element = event.target;
        let parentElement = element.closest('.slds-dropdown__item');

        if(parentElement) {
            let clientId = parentElement.getAttribute('data-client-id');
            let sowId = parentElement.getAttribute('data-sow-id');

            if(clientId && sowId) {
                helper.updateList(component, clientId, sowId);
            }
        }

        event.preventDefault();
        event.stopPropagation();
        return false;
    },
    update: function(component, event, helper) {
        let params = event.getParam('arguments');
        console.log('DEBUG:DIMenu:Update:Params:', params['data'].id,  params['data'].state,  params['data'].data);
        let data = params['data'];
        helper.update(component, data);
    }
})