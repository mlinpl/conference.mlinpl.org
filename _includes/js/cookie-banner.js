(function() {
  var banner = document.getElementById('cookie-banner');
  var consent = localStorage.getItem('ga_cookie_consent');

  if (!consent) {
    banner.style.display = 'block';
  } else if (consent === 'accepted') {
    loadGoogleAnalytics();
  }

  document.getElementById('cookie-accept').onclick = function() {
    localStorage.setItem('ga_cookie_consent', 'accepted');
    banner.style.display = 'none';
    loadGoogleAnalytics();
  };

  document.getElementById('cookie-deny').onclick = function() {
    localStorage.setItem('ga_cookie_consent', 'denied');
    banner.style.display = 'none';
  };

  function loadGoogleAnalytics() {
    var script = document.createElement('script');
    script.src = 'https://www.googletagmanager.com/gtag/js?id=AW-16939342125';
    script.async = true;
    document.head.appendChild(script);

    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    window.gtag = gtag;

    gtag('js', new Date());
    gtag('config', 'AW-16939342125');
  }
})();
