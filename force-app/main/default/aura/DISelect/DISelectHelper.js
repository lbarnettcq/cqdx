({
    init: function(component, event) {
      this.setSelected(component);
    },
    setSelected: function(component) {
      let value = component.get('v.value');
      //let values = component.get('v.options');

      window.setTimeout(
        $A.getCallback(function() {

          if (!component.isValid()) {
            return;
          }

          let selectL = component.find('select-element');
          let select = selectL.getElement();

          if (!value || !select || select.options.length === 0) {
            return;
          }

          for (let i = 0; i < select.options.length; i++) {
            if (select.options[i].value == value) {
              select.options[i].selected = true;
              return;
            }
          }
        }), 200
      );
    }
  })