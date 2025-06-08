// Show banner if no choice has been made
(function() {
  var banner = document.getElementById('cookie-banner');
  var accepted = localStorage.getItem('ga_cookie_consent');
  if (!accepted) {
    banner.style.display = 'block';
  }

  document.getElementById('cookie-accept').onclick = function() {
    localStorage.setItem('ga_cookie_consent', 'accepted');
    banner.style.display = 'none';
  };

  document.getElementById('cookie-deny').onclick = function() {
    localStorage.setItem('ga_cookie_consent', 'denied');
    banner.style.display = 'none';
  };
})();