'use strict';

/*!
 * ML in PL Jekyll Theme - Countdown
 * This script initiates countdown to the event
 */

var eventCountdownElement = document.getElementById("event-countdown");
if(eventCountdownElement){
    var introTimer = countdown(
        function(ts) {
            if(ts.value > 0){
                document.getElementById("d-left").innerHTML = ts.days;
                document.getElementById("h-left").innerHTML = ("0" + ts.hours).slice(-2);
                document.getElementById("m-left").innerHTML = ("0" + ts.minutes).slice(-2);
                document.getElementById("s-left").innerHTML = ("0" + ts.seconds).slice(-2);
            }
        },
        new Date("{{ site.header.countdown-date }}"),
        countdown.DAYS|countdown.HOURS|countdown.MINUTES|countdown.SECONDS);
}
