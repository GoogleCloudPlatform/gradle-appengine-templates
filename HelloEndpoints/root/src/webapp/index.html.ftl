<!DOCTYPE html>
<html>
<head>
  <title>Hello App Engine Endpoints</title>
</head>
<body>
  <!--
    A form that takes a text value and submits it to the endpoint,
    access to the endpoint is enabled once the client is loaded below
  -->
  <form action="javascript:void(0);">
    <input id="myName" type="text" name="name" />
    <input id="mySubmit" type="submit" value="Say Hello!" />
  </form>
  <br />
  Check out the <a href="https://developers.google.com/appengine/docs/java/">documentation</a> for more information on Google App Engine for Java.
  <br />
  Check out the <a href="https://developers.google.com/appengine/docs/java/endpoints/">endpoints documentation</a> for more information on Google Endpoints for Java.
  <script type="text/javascript">
    // a function that enables clicking on the from defined above
    function enableClick() {
      document.getElementById('mySubmit').onclick = function() {
        var name = document.getElementById('myName').value
        gapi.client.myApi.sayHi({'name': name}).execute(
          function(response) {
            if(!response.error) {
              alert(response.result.data);
            }
            else if(response.error) {
              alert("Error Code : " + response.error.code + " - " + response.error.message);
            }
          }
        );
      }
    }
    // this is called
    function init() {
      var apiName = 'myApi'
      var apiVersion = 'v1'
      var apiRoot = '//' + window.location.host + '/_ah/api';
      var callback = function() {
        enableClick();
      }
      gapi.client.load(apiName, apiVersion, callback, apiRoot);
    }
  </script>
  <script src="https://apis.google.com/js/client.js?onload=init"></script>
</body>
</html>
