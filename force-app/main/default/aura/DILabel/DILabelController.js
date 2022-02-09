({
    onTypeAttributeChange: function(component, event, helper) {
        console.log('DEBUG: DILabel: Old value: ' + event.getParam('oldValue'));
        console.log('DEBUG: DILabel: Current value: ' + event.getParam('value'));
        helper.updateView(component);
     }
})