({
    afterRender: function(component, helper) {
           this.superAfterRender();
           let cellId = component.get('v.cellId');
           let cellRowId = component.get('v.cellRowId');
           let cellColumnId = component.get('v.cellColumnId');
           let elementRef = jQuery('input[data-row-id=' + cellRowId + '][data-column-id=' + cellColumnId + ']');   

           let maskOptions =  {
                placeholder: "",
                translation: {
                   A: {pattern: /[0-2]/},                   
                   B: {pattern: /[0-9]/},
                   C: {pattern: /[0-5]/},
                   D: {pattern: /[0-4]/},
                   Z: {pattern: /[0]/}
                },
                onComplete: function(cep, e) {
                   console.log('debug:onComplete');

                   let cell = $(e.target);
                   console.log('DEBUG:TimeTrackingTable:CELL:COMPONENT:afterRender:completed',  
                   cell.data('id'), cell.data('row-id'), cell.data('column-id'), cell.data('previous-value'), cell.val());

                   let currentValue = distdlib.time.convertFromHoursAndMinutes(cell.val());
                   let dayLimit = getDayLimit();

                   if(currentValue > dayLimit){
                        cell.val(distdlib.time.convertToHoursAndMinutes(dayLimit));
                   }

                   let data = {
                       id: cell.data('id'),
                       rowId: cell.data('row-id'),
                       columnId: cell.data('column-id'),
                       value: cell.data('previous-value'),
                       newValue: cell.val(),
                   };

                   helper.handleCellChange(component, data);
                },
                onKeyPress: function(val, e, field, options) {
                    let cell = $(e.target);

                    console.log('debug:onKeyPress:', typeof cell.data('id'));
                    field.mask(SPMaskBehavior.apply({}, arguments), options);
                    if(typeof cell.data('id')  != 'undefined' && !cell.val()) {
                        let data = {
                            id: cell.data('id'),
                            rowId: cell.data('row-id'),
                            columnId: cell.data('column-id'),
                            value: cell.data('previous-value'),
                            newValue: cell.val(),
                        };
     
                        helper.handleCellChange(component, data);
                    } else {
                        field.mask(SPMaskBehavior.apply({}, arguments), options);
                    }
                }
           };


           let masks = ['AB:CB', 'AD:CB', 'AD:ZZ'];

           let SPMaskBehavior = function (val) {                
                if(val[0] === '2'){
                    if(val[1] === '4'){
                        return masks[2];
                    } else {
                        return masks[1];
                    }
                }
                return masks[0];
           }

           let getDayLimit = function(){
                let result = 0;
                let items = document.querySelectorAll("[data-column-id='" + cellColumnId + "']");
                for(let i = 0, a; i < items.length; i++){
                    if(items[i].getAttribute("data-row-id") != cellRowId){
                        result += distdlib.time.convertFromHoursAndMinutes(items[i].value);                                                 
                    }
                }
                result = 1440 - result;
                if(result < 0){
                    return 0;
                }
                return result;
            }

           elementRef.mask(masks[0], maskOptions);
        
    }
})