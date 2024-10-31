'use strict';

/*!
 * ML in PL Jekyll Theme - Show the agenda for today in the slider
 * This script finds the tab for today's date and sets it as active
 */

document.addEventListener("DOMContentLoaded", () => {
    const today = new Date().toISOString().split("T")[0];
    const tabs = document.querySelectorAll(".slider-item");
    const contents = document.querySelectorAll(".slider-item-content");

    // Find the tab index for today's date
    tabs.forEach((tab, index) => {
        if (tab.getAttribute("data-date") === today) {
            // Remove active class from all tabs and contents
            tabs.forEach(tab => tab.classList.remove("active"));
            contents.forEach(content => content.classList.remove("active"));
        
            // Add active class to today's tab and content
            tabs[index].classList.add("active");
            contents[index].classList.add("active");
        }
    });
});