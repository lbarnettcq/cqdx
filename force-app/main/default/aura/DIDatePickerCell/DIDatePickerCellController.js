({
	handleCellClick : function(component, event, helper) {
		let click = component.getEvent('dateCellClick');
        click.fire();
	}
})