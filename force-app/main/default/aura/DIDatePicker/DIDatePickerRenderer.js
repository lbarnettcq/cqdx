({
  afterRender: function(component, helper) {
    return this.superAfterRender();
  },
  rerender: function(component, helper) {
    //this is to determine the date input's relative location - we need to set the picker to the same location
    let formElement = component.find('dateInputFormElement').getElement();
    let input = component.find('dateInputControl').getElement();
    let grid = component.find('grid').getElement();
    let formElementOffset = formElement.getBoundingClientRect();
    let inputOffset = input.getBoundingClientRect();

    let right = inputOffset.right - formElementOffset.right;

    if(right === 0) {
      right = right + 4;
    }

    right = 4;
    
    grid.setAttribute('style', 'margin-left:' + right + 'px;');

    helper.renderGrid(component);
    this.superRerender();
  }
})