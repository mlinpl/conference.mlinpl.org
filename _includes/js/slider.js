'use strict';

/*!
 * ML in PL Jekyll Theme - Sliders
 * This script manages sliders' behavior with visibility tracking, resume/pause functionality, and timer updates.
 */

const TIMEOUT_DURATION = 30000;

let sliders = document.getElementsByClassName('slider-container');

if (sliders === null) {
  sliders = [];
}

for (let slider of sliders) {
  // Slider elements
  let sliderTabs = slider.getElementsByClassName('slider-tabs')[0];
  let sliderItems = sliderTabs.querySelectorAll('.slider-item');
  let sliderContent = slider.getElementsByClassName('slider-content')[0];
  let sliderItemContents = sliderContent.querySelectorAll('.slider-item-content');

  let timeoutId = null;
  let currentIndex = 0;
  let isVisible = false;

  function updateSlider(clickedItem) {
    // Deactivate all sliders in the tab
    slider.querySelectorAll('.slider-item.active').forEach(function (item) {
      item.classList.remove('active');
    });

    // Deactivate timer indicator
    let sliderTimer = slider.getElementsByClassName('slider-timer')[0];
    if (sliderTimer) sliderTimer.classList.remove('width-from-0-to-100');

    // Mark the clicked slider item as active
    clickedItem.classList.add('active');

    let currentItemContent = sliderContent.querySelector('.slider-item-content.fade-in');
    if (currentItemContent) currentItemContent.classList.remove('fade-in');
    let nextItemContent = sliderItemContents[clickedItem.dataset.index];

    currentItemContent.classList.add('fade-out');

    // Display slider details
    currentItemContent.addEventListener('animationend', () => {
      currentItemContent.classList.remove('fade-out');

      // Fade in the new slider detail
      nextItemContent.classList.add('fade-in');

      // Clear timer and setup new one
      clearSliderTimeout();
      if (isVisible) {
        setSliderTimeout();
      }
    }, { once: true });
  }

  function handleSliderItemClick(clickedItem) {
    let clickedIndex = parseInt(clickedItem.dataset.index);
    currentIndex = clickedIndex;
    updateSlider(clickedItem);
  }

  function setSliderTimeout() {
    let sliderTimer = slider.getElementsByClassName('slider-timer')[0];
    if (sliderTimer) sliderTimer.classList.add('width-from-0-to-100');
    timeoutId = setTimeout(() => {
      currentIndex = (currentIndex + 1) % sliderItems.length;
      let nextItem = sliderItems[currentIndex];
      updateSlider(nextItem);
    }, TIMEOUT_DURATION);
  }

  function clearSliderTimeout() {
    if (timeoutId) clearTimeout(timeoutId);
    let sliderTimer = slider.getElementsByClassName('slider-timer')[0];
    if (sliderTimer) sliderTimer.classList.remove('width-from-0-to-100');
  }

  sliderItems.forEach((sliderItem, index) => {
    sliderItem.dataset.index = index;
    sliderItem.addEventListener('click', handleSliderItemClick.bind(null, sliderItem));
  });

  let observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        isVisible = true;
        setSliderTimeout();
      } else {
        isVisible = false;
        clearSliderTimeout();
      }
    });
  });

  observer.observe(slider);

  let firstSliderItem = slider.querySelector('.slider-item');
  let firstSliderItemContent = slider.querySelector('.slider-item-content');
  firstSliderItemContent.classList.add('fade-in');
  handleSliderItemClick(firstSliderItem);
}
