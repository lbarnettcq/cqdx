({
    rerender : function(component, helper) {
        this.superRerender();


        $('body').on('click', function (e) {

            let items = [
                e.target.classList,
                e.target.parentNode.classList,
                e.target.parentNode.parentNode.classList,
                e.target.parentNode.parentNode.parentNode.classList
            ];

            let closePopover = true;
            for(let i = 0; i < items.length; i++){
                if(items[i].contains('popover') || items[i].contains('slds-button_reset')){
                    closePopover = false;
                    return;
                }
            }

            if(closePopover) {
                $('.popover').popoverX('hide');
            }

        });

    }
})