<!DOCTYPE html>
<html>
<head>
  <title>App Engine Endpoints with Google Cloud Messaging</title>
</head>
<body>
  <!--
    A form that takes a text value and submits it to the endpoint,
    access to the endpoint is enabled once the client is loaded below
  -->
  <form action="javascript:void(0);">
    <input id="myMessage" type="text" name="message" />
    <input id="mySubmit" type="submit" value="Send Message" />
  </form>
  <br />
  Your App Engine <a href="/_ah/admin">Admin Console</a> provides some information about your App Engine app.
  <br />
  Endpoints <a href="/_ah/api/explorer">Api Explorer</a> lets you access the endpoints API directly.
  <br />
  Check out the <a href="https://developers.google.com/appengine/docs/java/">documentation</a> for more information on Google App Engine for Java.
  <br />
  Check out the <a href="https://developers.google.com/appengine/docs/java/endpoints/">endpoints documentation</a> for more information on Google Endpoints for Java.
  <script type="text/javascript">
    // a function that enables clicking on the from defined above
    function enableClick() {
      document.getElementById('mySubmit').onclick = function() {
        var name = document.getElementById('myMessage').value
        gapi.client.messaging.messagingEndpoint.sendMessage({'message': name}).execute(
          function(response) {
            if(response && response.error) {
              alert("Error Code : " + response.error.code + " - " + response.error.message);
            }
          }
        );
      }
    }
    // Once the gapis are loaded, we can load the Messaging Endpoint's javascript client libraries
    function init() {
      var apiName = 'messaging'
      var apiVersion = 'v1'
      // set the apiRoot to work on a deployed app and locally with devappserver
      var apiRoot = '//' + window.location.host + '/_ah/api';
      var callback = function() {
        enableClick();
      }
      gapi.client.load(apiName, apiVersion, callback, apiRoot);
    }
  </script>
  // Load the Google APIs Client Library for JavaScript
  // More info here : https://developers.google.com/api-client-library/javascript/reference/referencedocs
  <script src="https://apis.google.com/js/client.js?onload=init"></script>
</body>
</html>