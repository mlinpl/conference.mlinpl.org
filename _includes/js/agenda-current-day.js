/*!
 * ML in PL Jekyll Theme - Set active
 * This script adds a span with class "emph" around every i/I in text of class "emph-i"
 */

// Get the current date
const today = new Date();

// Get all elements with the date attribute
const elements = document.querySelectorAll('[date]');

// Loop through each element
elements.forEach(element => {
    // Get the date attribute value
    const dateAttribute = element.getAttribute('date');

    // Convert the date attribute value to a Date object
    const date = new Date(dateAttribute);

    // Check if the date is equal to today's date
    if (date.toDateString() === today.toDateString()) {
        // Set the element to active
        element.classList.add('active');
    }
});