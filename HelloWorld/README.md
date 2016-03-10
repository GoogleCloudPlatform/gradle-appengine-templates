"App Engine Java Servlet Module" Template
===========================================

This Java servlet template is a simplest example of an App Engine backend. It contains the smallest amount of boilerplate code, which makes it perfect for setting up the backend development environment in Android Studio.

If you need more abstractions/protections that Endpoints provide (like automated object marshalling/unmarshalling, OAuth 2.0) or push notification support have a look at [App Engine Java Endpoints Module](/HelloEndpoints) and [App Engine Backend with Google Cloud Messaging](/GcmEndpoints) templates.

# 1. Adding a backend in Android Studio

To add the backend to your existing Android app from this backend template, open Android Studio ([installation instructions](https://developer.android.com/sdk/installing/studio.html)) and navigate to "File &rarr; New Module..." or right-click on your project and choose "New &rarr; Module".

![New &rarr; Module](/doc/img/add-app-engine-backend-menu-scaled.png)

In the "New Module" wizard that appears, choose "Google Cloud Module":

![Add App Engine Backend Choose Module](/doc/img/choose_module.png)

Then choose "App Engine Java Servlet Module".

![App Engine Java Servlet Module](/doc/img/servlet2.png)

Enter the module/package names for your new backend, and choose the "client" module in your project which contains your Android app. The client module will be set up to call your newly generated backend. Module name which you've entered above (marked with red **1**) will be used in your Android Studio project. Package name (marked with red **2**) will be used for all classes imported from this template, as shown in the image below.

![Added "HelloWorld" backend. Red numbers 1 and 2 indicate that the module name and the package name came from "New App Engine Module" dialog](/doc/img/added-backend-helloworld.png)

## 1.1. Debugging the backend locally

As soon as the backend module is added to your project and Gradle sync finishes, a new run configuration with your backend's module name should be created:

![Created run configuration](/doc/img/run-configuration.png)

Rebuild your project (via "Build &rarr; Rebuild Project") and launch this run configuration. It will invoke `appengineRun` task in [Gradle plug-in for App Engine](https://github.com/GoogleCloudPlatform/gradle-appengine-plugin), which in turn will start the local App Engine [Java development server](https://developers.google.com/appengine/docs/java/tools/devserver).

To ensure that your backend started successfully, navigate to [http://localhost:8080](http://localhost:8080). If everything went well, you should see the following page:

!["HelloWorld" backend running in local Java development server](/doc/img/devappserver-helloworld.png)

# 2. Connecting your Android app to the backend

When you created a backend module, your client module has been set up to access internet. In particular, the following permission has been added into your `AndroidManifest.xml` file:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

To call this backend from your Android app, you simply need to make an HTTP request. The following code snippet illustrates how to create an [AsyncTask](http://developer.android.com/reference/android/os/AsyncTask.html) which makes the HTTP request to the backend and prints the incoming result string to a [toast](http://developer.android.com/guide/topics/ui/notifiers/toasts.html) in a given context:

```java
class ServletPostAsyncTask extends AsyncTask<Pair<Context, String>, Void, String> {
    private Context context;

    @Override
    protected String doInBackground(Pair<Context, String>... params) {
        context = params[0].first;
        String name = params[0].second;

        try {
            // Set up the request
            URL url = new URL("http://10.0.2.2:8080/hello");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setDoInput(true);
            connection.setDoOutput(true);

            // Build name data request params
            Map<String, String> nameValuePairs = new HashMap<>();
            nameValuePairs.put("name", name);
            String postParams = buildPostDataString(nameValuePairs);

            // Execute HTTP Post
            OutputStream outputStream = connection.getOutputStream();
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream, "UTF-8"));
            writer.write(postParams);
            writer.flush();
            writer.close();
            outputStream.close();
            connection.connect();

            // Read response
            int responseCode = connection.getResponseCode();
            StringBuilder response = new StringBuilder();
            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            reader.close();

            if (responseCode == HttpsURLConnection.HTTP_OK) {
                return response.toString();
            }
            return "Error: " + responseCode + " " + connection.getResponseMessage();

        } catch (IOException e) {
            return e.getMessage();
        }
    }

    private String buildPostDataString(Map<String, String> params) throws UnsupportedEncodingException {
        StringBuilder result = new StringBuilder();
        boolean first = true;
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (first) {
                first = false;
            } else {
                result.append("&");
            }

            result.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
            result.append("=");
            result.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
        }

        return result.toString();
    }

    @Override
    protected void onPostExecute(String result) {
        Toast.makeText(context, result, Toast.LENGTH_LONG).show();
    }
}
```

Finally, you need to invoke this AsyncTask from one of your Android activities. For example, to execute it from `MainActivity` class, add the following code snippet to `MainActivity.onCreate` method:
```java
new ServletPostAsyncTask().execute(new Pair<Context, String>(this, "Manfred"));
```

## 2.1. Testing your app in an emulator

If you have created a `ServletPostAsyncTask` and added its invokation to one of your Android app activities as per steps above, you should be all set to test your backend locally!

First, launch your backend locally as described in section 1.1. and ensure that you can access it via [http://localhost:8080](http://localhost:8080). Then, change the run configuration back to your Android app and run the Android emulator.

If everything goes well, you should see the following toast in your app:

!["HelloWorld" backend connected to Android emulator](/doc/img/emulator-helloworld.png)

## 2.2. Deploying the backend live to App Engine

If your backend is working locally, you can deploy it to Google App Engine.

1. Stop the backend, if it is running locally, by selecting
**Run** > **Stop**.

2. Run **Build** > **Deploy Module to App Engine**.

![Deploy module to App Engine](/doc/img/deploy-addacct.png)

3. In the **Deploy to App Engine** dialog, select your module. From the **Deploy To:** dropdown list, choose "Click here to create a new Google Developers Console project."  This will open [Google Developers Console](https://console.developers.google.com)

    + If you are running this task for the first time, you will be prompted to
sign-in with your Google Account. Choose an account and sign in.<br>

4. Create a new project and switch back to the **Deploy to App Engine** dialog in Android Studio.

5. This would probably be a good time to update your `src/main/webapp/WEB-INF/appengine-web.xml` file's `<application>` property and replace `myApplicationId` with the ID of the project that you just created. This will be important if you try to deploy from the command line.

6. Click the Refresh button ![Deploy module to App Engine](/doc/img/refresh.png) in the bottom right corner of the **Deploy To:** dropdown list and then select the project you just created.

7. Click **Deploy**. You can monitor the status of your deployment in the Android Studio console.

## 2.3. Testing against a deployed backend

Once you have deployed your backend to App Engine, you can connect your Android app to it by modifying `ServletPostAsyncTask` class defined in section 2 above. In particular, replace the line
```java
HttpPost httpPost = new HttpPost("http://10.0.2.2:8080/hello");
```
with
```java
HttpPost httpPost = new HttpPost("http://android-app-backend.appspot.com/hello");
```
where `android-app-backend` corresponds to your own Project ID created in section 2.2.

At this point you should be all set to run your Android app in an emulator or on the physical device, and successfully communicate with your new App Engine backend!
