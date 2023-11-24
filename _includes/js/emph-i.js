/*!
 * ML in PL Jekyll Theme - Emphasize i/I in text
 * This script adds a span with class "emph" around every i/I in text of class "emph-i"
 */

function emphI(html){
    html = html.replaceAll('i', '<span class="emph">i</span>');
    html = html.replaceAll('I', '<span class="emph">I</span>');
    return html;
};

let toEmph = document.getElementsByClassName('emph-i');
for (let item of toEmph) {
    item.innerHTML = emphI(item.innerHTML);
};
