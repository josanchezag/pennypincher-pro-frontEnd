// Redirect target of the Google authorization request. Hands the callback
// URL (authorization code and state) back to the app that opened this
// window, using the message key that flutter_web_auth_2 listens for. It is
// an external file because the Content-Security-Policy forbids inline
// scripts.
(function () {
  'use strict';

  var MESSAGE_KEY = 'flutter-web-auth-2';
  var message = {};
  message[MESSAGE_KEY] = window.location.href;

  if (window.opener) {
    window.opener.postMessage(message, window.location.origin);
    window.close();
  } else if (window.parent && window.parent !== window) {
    window.parent.postMessage(message, window.location.origin);
  } else {
    // Opened with noopener: the app polls this key and removes it at once.
    // The code alone is useless without the PKCE verifier held in memory.
    window.localStorage.setItem(MESSAGE_KEY, window.location.href);
    window.close();
  }
}());
