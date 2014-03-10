GcmEndpoints : App Engine Backend with Google Cloud Messaging
=============================================================

Freemarker template for an Android Mobile Backend with Google Cloud Endpoints and Google Cloud Messaging

Connecting this template with an Android GCM Client :

Set up the AppEngine Backend Server :

In Android Studio (in the project with your GCM client), navigate to Tools -> Google Cloud Tools -> App Engine Gradle Module -> App Engine Backend with Google Cloud Messaging

Enter a module name (this is the name of the module/folder and will appear in the project directory), and a package path.

Let the project build, you now have a working android client and a GCM ready App Engine backend.  HOWEVER, they are not connected.

Connecting Server and Client :

Service Side Setup

1. ApiKey in MessagingEndpoint.java.  This is a step required to allow appengine to send message via GCM.  Currently it must be manually replaced.
2. Install Client Libraries via Tools -> Google Cloud Tools -> Install Client Libraries

Client Side Setup

1. Setup up dependencies for endpoints/client libs on android, editing the build.gradle file to include all necessary dependencies for Endpoints and our custom endpoints.
- Modifications to Android build.gradle for endpoints dependencies:
````
repositories {
    // this is required to reference the locally installed endpoints
    mavenLocal()
}

dependencies {
    // required for GCM
    compile 'com.google.android.gm:play-services:3.1.+'

    compile ('com.google.http-client:google-http-client-android:1.17.0-rc') {
        exclude (group: 'com.google.android', module: 'android')
        exclude (group: 'org.apache.httpcomponents', module: 'httpclient')
    }

    // custom endpoints (includes google-api-client automatically)
    compile ('<your package name>:messaging:v1-1.17.0-rc-SNAPSHOT') {
        exclude (group: 'org.apache.httpcomponents', module: 'httpclient')
    }
    compile ('<your package name>:registration:v1-1.17.0-rc-SNAPSHOT') {
        exclude (group: 'org.apache.httpcomponents', module: 'httpclient')
    }
}    
````
We have to exclude httpclient because gradle will throw a warning about the module already being included by android and conflicts with the included version.

- Modifications to the Android Manifest File (These should have already happened when following the instructions from the GCM guide)

- Adding in the endpoints call to register
  - In DemoActivity.java, add Registration(Endpoint) member
````
Registration regService;
````
  
In the `if (checkPlayServices())` block of `onCreate(Bundle savedInstance)`, after ensuring play services is installed but before registering in the background, instantiate the Registration Service
````
Registration.Builder builder = new Registration.Builder(AndroidHttp.newCompatibleTransport(), new AndroidJsonFactory(), null)
    // need setRootUrl and Initializer for running against devappserver, otherwise they can be skipped
        .setRootUrl("http://10.0.2.2:8080/_ah/api/")
        .setGoogleClientRequestInitializer(new GoogleClientRequestInitializer() {
            @Override
            public void initialize(
                AbstractGoogleClientRequest<?> abstractGoogleClientRequest) throws IOException {
                    abstractGoogleClientRequest.setDisableGZipContent(true);
                }
            }
        );
regService = builder.build();
````

If you want registration to run everytime, remove the `if (regid.isEmpty())` check that surrounds `registerInBackground()`. This might be necessary because if you’ve previously run through the registration flow on the android client, it saves the regId to the preferences and proceeds to skip the registration step on further invocation.

Now all we have to do is actually call the registration, modify `sendRegistrationIdToBackend()` to call our endpoint 
````
private void sendRegistrationIdToBackend(String regId) throws IOException {
    regService.register(regId).execute();
}
````

  Now we’re registered and good to go.

- Optional (add in a re-register button, in case registration fails)
  Add in another button the /res/layout/ .xml file for the DemoActivity
````
<Button
  android:id="@+id/reregister"
  android:layout_width="wrap_content"
  android:layout_height="wrap_content"
  android:onClick="onClick"
  android:text="@string/reregister" />
````
  In DemoActivity.java, add to the OnClick() method

````
else if (view == findViewById(R.id.reregister)) {
    registerInBackground();
}
````
