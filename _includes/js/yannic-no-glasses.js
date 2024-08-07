'use strict';

/*!
 * ML in PL Jekyll Theme - Navigation
 * This script implements small easteregg related to Yannic Kilcher
 */

let images = document.getElementsByTagName('img');

for (let image of images) {
    if(image.src.search('YannicKilcher') != -1) {
        function removeGlasses() {
            image.src = image.src.replace('YannicKilcher', 'YannicKilcherNoGlasses');
        }

        function addGlasses() {
            image.src = image.src.replace('YannicKilcherNoGlasses', 'YannicKilcher');
        }   
        
        image.onmouseenter = removeGlasses;
        image.onmouseout = addGlasses;
        image.parentNode.onmouseenter = removeGlasses;
        image.parentNode.onmouseout = addGlasses;
    }
};