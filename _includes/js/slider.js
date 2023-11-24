'use strict';

/*!
 * ML in PL Jekyll Theme - Sliders
 * This script take care of sliders behaviour
 */

let sliders = document.getElementsByClassName('slider-container');

if (sliders === null) {
  sliders = [];
}

for(let slider of sliders) {
  // Slider elements
  let sliderTabs = slider.getElementsByClassName('slider-tabs')[0];
  let sliderItems = sliderTabs.querySelectorAll('.slider-item');
  let sliderContent = slider.getElementsByClassName('slider-content')[0];
  let sliderItemContents = sliderContent.querySelectorAll('.slider-item-content');

  let timeoutId = null;
  function handlesliderItemClick(clickedElement) {
    // Deactivate all sliders in the tab
    slider.querySelectorAll('.slider-item.active').forEach(function(item) {
      item.classList.remove('active');
    });

    // Deactivate timer indicator
    let sliderTimer = slider.getElementsByClassName('slider-timer')[0];
    if(sliderTimer) sliderTimer.classList.remove('width-from-0-to-100');

    // Mark the clicked slider item as active
    clickedElement.classList.add('active');

    let currentItemContent = sliderContent.querySelector('.slider-item-content.fade-in');
    currentItemContent.classList.remove('fade-in'); // There should be checked if it is not null
    let nextItemContent = sliderItemContents[clickedElement.dataset.index];
    
    currentItemContent.classList.add('fade-out');
    
    // Display slider details
    currentItemContent.addEventListener('animationend', function() {
      currentItemContent.classList.remove('fade-out');

      // Fade in the new slider detail
      nextItemContent.classList.add('fade-in');
      
      // Clear timer and setup new one
      if(sliderTimer){
        sliderTimer.classList.add('width-from-0-to-100');
        if(timeoutId) clearTimeout(timeoutId);
        timeoutId = setTimeout(function() {
          let newItem = sliderItems[(parseInt(clickedElement.dataset.index) + 1) % sliderItems.length];
          handlesliderItemClick(newItem);
        }, 30000);
      }
    }, { once: true });
  }

  // Sliders preview in the tab
  sliderItems.forEach(function(sliderItem, index) {
    sliderItem.addEventListener('click', handlesliderItemClick.bind(null, sliderItem));
  });

  let firstSliderItem = slider.querySelector('.slider-item');
  let firstSliderItemContent = slider.querySelector('.slider-item-content');
  firstSliderItemContent.classList.add('fade-in');
  handlesliderItemClick(firstSliderItem);
}
