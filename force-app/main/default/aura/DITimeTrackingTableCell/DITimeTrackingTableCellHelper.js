({
    //https://www.npmjs.com/package/jquery.maskedinput
	handleCellChange : function(component, data) {      
        console.log('DEBUG:TimeTrackingTable:CELL:COMPONENT:OnInput',  data);      
        let change = component.getEvent('timeCellChange');
        change.setParams({data: data});
        change.fire();
    },
})