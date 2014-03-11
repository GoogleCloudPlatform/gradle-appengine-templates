HelloWorld - App Engine Java Servlet Module
===========================================

Freemarker template for a simple Hello World App Engine application using servlets

Talking to your Servlet... Servlets don't offer all the abstractions/protections that Endpoints give you, but if you want to connect with the Servlet in this template:

- Modifications to the Android Manifest (for internet access)
````
<uses-permission android:name="android.permission.INTERNET" />
````

- Create an AsyncTask to make the http request this will print the result to a toast
````
public class servletPostAsyncTask extends AsyncTask<String, Void, String> {
    @Override
    protected String doInBackground(String... params) {
        HttpClient httpclient = new DefaultHttpClient();
        // localhost option (10.0.2.2 is the Emulators connection to localhost)
        HttpPost httppost = new HttpPost("http://10.0.2.2:8080/hello");
        // your appengine deployment
        HttpPost httppost_remote = new HttpPost("http://myapp.appspot.com");

        try {
            // Add name data to request
            List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(1);
            nameValuePairs.add(new BasicNameValuePair("name", "MyName"));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

            // Execute HTTP Post Request
            HttpResponse response = httpclient.execute(httppost);
            if(response.getStatusLine().getStatusCode() == 200) {
                return EntityUtils.toString(response.getEntity());
            }
            return "Error: " + response.getStatusLine().getStatusCode() + " " + response.getStatusLine().getReasonPhrase();

        } catch (ClientProtocolException e) {
            return e.getMessage();
        } catch (IOException e) {
            return e.getMessage();
        }
    }

    @Override
    protected void onPostExecute(String result) {
        Toast.makeText(MainActivity.this, result, Toast.LENGTH_LONG).show();
    }
}
````

- Invoke the AsyncTask
````
  new servletPostAsyncTask().execute("someName");
````
