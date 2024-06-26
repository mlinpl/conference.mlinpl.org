/*!
 * ML in PL Jekyll Theme - Navigation
 * This script handles some events related with the navigation bar
 */

// jQuery to collapse the navbar on scroll
$(window).scroll(function() {
    if ($(".navbar").offset().top > 18) {
        $(".navbar-fixed-top").addClass("top-nav-collapse");
    } else {
        $(".navbar-fixed-top").removeClass("top-nav-collapse");
    }
});

// jQuery for page scrolling feature - requires jQuery Easing plugin
$(function() {
    $('a.page-scroll').bind('click', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: $($anchor.attr('href')).offset().top
        }, 1000, 'easeInOutExpo');
        event.preventDefault();
    });
});

// Closes the Responsive Menu on Menu Item Click
$('.navbar-collapse ul li a').click(function() {
    if($(this).attr('href')) $('.navbar-toggle:visible').click();
});

// Remove the focused state after click,
// otherwise bootstrap will still highlight the link
$("a").mouseup(function(){
    if($(this).attr('href')) $(this).blur();
});
