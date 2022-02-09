({
    render : function(component, helper) {
        let ret = this.superRender();
        helper.updateView(component);
        return ret;
    },
    rerender: function(component, helper) {
        this.superRerender();
        helper.updateView(component);
    },
    afterRender: function (component, helper) {
        this.superAfterRender();
        helper.updateView(component);
    },
})