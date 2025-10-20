'use strict';

/*!
 * ML in PL Jekyll Theme - Countdown
 * This script initiates countdown to the next meetup
 */

var meetupCountdownElement = document.getElementById("meetup-countdown");
var last_meetup_header = "/ Last meetup"
var next_meetup_header = "/ Next meetup"

if (meetupCountdownElement) {
    countdown(
        function(ts) {
            if (ts.value < 0) {
                meetupCountdownElement.innerHTML = last_meetup_header;
            }
            else if (ts.days == 0) {
                meetupCountdownElement.innerHTML = next_meetup_header + " today";
            }
            else if (ts.days == 1) {
                meetupCountdownElement.innerHTML = next_meetup_header + " in " + ts.days + " day";
            }
            else if (ts.days > 1) {
                meetupCountdownElement.innerHTML = next_meetup_header + " in " + ts.days + " days";
            }
        },
        new Date("{{ site.header.meetup-countdown-date }}"),
        countdown.DAYS,
    );
}
