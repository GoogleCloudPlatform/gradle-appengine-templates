HelloEndpoints : App Engine Java Endpoints Module
===============================================

Freemarker template for a simple Hello World App Engine application using Google Cloud Endpoints

Connecting this template with an Android Application :

Talking to your Endpoint

- Modifications to the Android Manifest (for internet access)
````
<uses-permission android:name="android.permission.INTERNET" />
````

- Modifications to Android build.gradle for endpoints dependencies:
````
repositories {
    // this is required to reference the locally installed endpoints
    mavenLocal()
}

dependencies {
    compile ('com.google.http-client:google-http-client-android:<google-client-lib-version>') {
        exclude (group: 'com.google.android', module: 'android')
        exclude (group: 'org.apache.httpcomponents', module: 'httpclient')
    }

    // custom endpoints (includes google-api-client automatically)
    compile ('<your package name>:myApi:v1-<google-client-lib-version>-SNAPSHOT') {
        exclude (group: 'org.apache.httpcomponents', module: 'httpclient')
    }
}
````
The client library version for generated endpoints is the latest version of the google client libraries that is available (http://mvnrepository.com/artifact/com.google.api-client/google-api-client)
You can also see what the generated client library versions are by inspecting the zip file that came down when the gradle task "appengineEndpointsGetClientLibs" was called in the build/client-libs directory
We have to exclude httpclient because gradle will throw a warning about the module already being included by android and conflicts with that included version.

- Define your endpoint service somewhere
````
MyApi myApiService;
````
- Build the endpoint service using the Builder
````
MyApi.Builder builder = new MyApi.Builder(AndroidHttp.newCompatibleTransport(), new AndroidJsonFactory(), null)
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
myApiService = builder.build();
````

- You can now make calls to your endpoint, since it is a network task be sure to call it wrapped in an Android `AsyncTask`

````
myApiService.sayHi("MyName");
````
