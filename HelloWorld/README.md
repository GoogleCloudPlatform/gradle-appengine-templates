"App Engine Java Servlet Module" Template
===========================================

This Java servlet template is a simplest example of an App Engine backend. It contains the smallest amount of boilerplate code, which makes it perfect for setting up the backend development environment in Android Studio.

If you need more abstractions/protections that Endpoints provide (like automated object marshalling/unmarshalling, OAuth 2.0) or push notification support have a look at [App Engine Java Endpoints Module](/HelloEndpoints) and [App Engine Backend with Google Cloud Messaging](/GcmEndpoints) templates.

# 1. Adding a backend in Android Studio

To add the backend to your existing Android app from this backend template, open Android Studio ([installation instructions](https://developer.android.com/sdk/installing/studio.html)) and navigate to "File &rarr; New Module..." or right-click on your project and choose "New &rarr; Module".

![New &rarr; Module](/doc/img/add-app-engine-backend-menu-scaled.png)

In the "New Module" that appears, choose "App Engine Java Servlet Module".

![App Engine Java Servlet Module](/doc/img/add-app-engine-backend-menu-helloworld.png)

Enter the module/package names for your new backend, and choose the "client" module in your project which contains your Android app. 

![App Engine Java Servlet Module](/doc/img/add-app-engine-backend-menu-dialog-step-2.png)

Module name which you've entered above (marked with red 1) will be used in your Android Studio project. Package name (marked with red 2) will be used for all classes imported from this template, as shown in the image below.

![Added "HelloWorld" backend. Red numbers 1 and 2 indicate that the module name and the package name came from "New App Engine Module" dialog](/doc/img/added-backend-helloworld.png)

## 1.1. Debugging the backend locally

As soon as the backend module is added to your project and Gradle sync finishes, a new run configuration with your backend's module name should be created:

![Created run configuration](/doc/img/run-configuration.png)

Launching this run configuration will invoke `appengineRun` task in [Gradle plug-in for App Engine](https://github.com/GoogleCloudPlatform/gradle-appengine-plugin), which in turn will start the local App Engine [Java development server](https://developers.google.com/appengine/docs/java/tools/devserver).

To ensure that your backend started successfully, navigate to [http://localhost:8080](http://localhost:8080). If everything went well, you should see the following page:

!["HelloWorld" backend running in local Java development server](/doc/img/devappserver-helloworld.png)

# 2. Connecting your Android app to the backend

First of all, you need to add the permission to access internet into the Android manifest of your app (if it's not already there). To achieve this, copy and paste the following line into your `AndroidManifest.xml` file:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

Secondly, you need to make an HTTP request from your Android app to call this backend. The following code snippet illustrates how to create an [AsyncTask](http://developer.android.com/reference/android/os/AsyncTask.html) which makes the HTTP request to the backend and prints the incoming result string to a [toast](http://developer.android.com/guide/topics/ui/notifiers/toasts.html) in a given context:

```java
class ServletPostAsyncTask extends AsyncTask<Pair<Context, String>, Void, String> {
    private Context context;

    @Override
    protected String doInBackground(Pair<Context, String>... params) {
        context = params[0].first;
        String name = params[0].second;

        HttpClient httpClient = new DefaultHttpClient();
        HttpPost httpPost = new HttpPost("http://10.0.2.2:8080/hello"); // 10.0.2.2 is localhost's IP address in Android emulator
        try {
            // Add name data to request
            List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(1);
            nameValuePairs.add(new BasicNameValuePair("name", name));
            httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

            // Execute HTTP Post Request
            HttpResponse response = httpClient.execute(httpPost);
            if (response.getStatusLine().getStatusCode() == 200) {
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
        Toast.makeText(context, result, Toast.LENGTH_LONG).show();
    }
}
```

Finally, you need to invoke this AsyncTask from one of your Android activities. For example, to execute it from `MainActivity` class, add the following code snippet to `MainActivity.onCreate` method:
```java
new ServletPostAsyncTask().execute(new Pair<Context, String>(this, "my favorite name"));
```

## 2.1. Testing your app in an emulator

If you have added the internet access permission to your `AndroidManifest.xml` file, created a `ServletPostAsyncTask` and added its invokation to one of your Android app activities as per steps above, you should be all set to test your backend locally!

First, launch your backend locally as described in section 1.1. and ensure that you can access it via [http://localhost:8080](http://localhost:8080). Then, change the run configuration back to your Android app and run the Android emulator.

If everything goes well, you should see the following toast in your app:

!["HelloWorld" backend connected to Android emulator](/doc/img/emulator-helloworld.png)

## 2.2. Deploying the backend live to App Engine

If your backend is working locally, you can deploy it to Google App Engine. To begin with, create a new project on [Google Developers Console](https://console.developers.google.com) (or choose an existing project, if you have one already).

![Project creation in Google Developers Console](/doc/img/new-developer-console-project.png)

Note down the "Project ID" (in this case "android-app-backend") and switch back to Android Studio. In Android Studio, open `<backend>/src/main/webapp/WEB-INF/appengine-web.xml` file and change
```xml
<application>myApplicationId</application>
```
to contain your real Project ID (in this case, again, "android-app-backend"):
```xml
<application>android-app-backend</application>
```

If you have started the local Java development server in an earlier step, stop it by opening "Run" tool window (1), choosing your backend run session (2) and pressing the red "Stop" button (3). 

![Stop local Java development server](/doc/img/stop-devappserver-helloworld.png)

Then, switch to the "Terminal" tab and execute `./gradlew backend:appengineUpdate` command:

![Deployment from terminal, step 1](/doc/img/update-helloworld-1.png)

If you are running this task for the first time, you will be prompted to sign-in with your Google Account. After choosing the account and signing-in, give permissions to Google App Engine's "appcfg" tool and copy-paste the generated key back into Terminal:

![App Engine permissions request](/doc/img/app-engine-permissions.png)

![Deployment from terminal, step 1](/doc/img/update-helloworld-2.png)

After you paste the key and hit Return, your backend will be deployed to App Engine and will be accessible live at [https://&lt;Project ID&gt;.appspot.com](https://cloud.google.com). (In this example, the backend would be hosted at [https://android-app-backend.appspot.com](https://android-app-backend.appspot.com).)

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
