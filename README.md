App Engine backend templates in Android Studio
==========================

You can use [Google App Engine](https://developers.google.com/appengine) backend templates hosted in this repository to add a backend to your existing (or new) Android application from [Android Studio IDE](http://developer.android.com/sdk/installing/studio.html).

All of these backends are designed to be hosted on App Engine (which provides autoscaling and high-availability out-of-the-box), and can be used under App Engine's [free resource quotas](https://developers.google.com/appengine/docs/quotas).

# 1. Usage

This repository contains three backend template types, which can be added into your Android app by navigating to "Tools &rarr; Google Cloud Tools &rarr; Add App Engine Backend".

![Tools &rarr; Google Cloud Tools &rarr; Add App Engine Backend](/doc/img/add-app-engine-backend-menu.png)

In the dialog that appears, choose one out of the following template types:

![Add App Engine Backend Menu](/doc/img/add-app-engine-backend-dialog.png)

1. [App Engine Java Servlet Module](/HelloWorld) [[HelloWorld](/HelloWorld)]: a simple App Engine Java backend servlet with minimal boilerplate code,
2. [App Engine Java Endpoints Module](/HelloEndpoints) [[HelloEndpoints](/HelloEndpoints)]: a backend which leverages [Google Cloud Endpoints](https://developers.google.com/appengine/docs/java/endpoints) for automated object marshalling/unmarshalling, generation of strongly-typed Java client libraries and so on,
3. [App Engine Backend with Google Cloud Messaging](/GcmEndpoints) [[GcmEndpoints](/GcmEndpoints)]: a mobile backend with Google Cloud Endpoints and [Google Cloud Messaging](http://developer.android.com/google/gcm) integration, which supports more advanced features like push notifications.

For detailed instructions on how to use each of these templates to add a backend to your Android app see the individual template directories ([HelloWorld](/HelloWorld), [HelloEndpoints](/HelloEndpoints) or [GcmEndpoints](/GcmEndpoints)).

# 2. Prerequisites

App Engine requires Java 7 SDK. You can check which SDK your project is using by navigating to "File &rarr; Project Structure...".

![JDK settings in File &rarr; Project Structure...](/doc/img/jdk-settings.png)

These templates use [FreeMarker](http://freemarker.org) (but it is not required if you are adding these templates via Android Studio).

# 3. Troubleshooting

If you have any problems adding these backends to your Android applications, contact us on [Android Developers G+ community](https://plus.google.com/+AndroidDevelopers) or write us a question on StackOverflow using [google-app-engine](http://stackoverflow.com/questions/tagged/google-app-engine) or [google-cloud-endpoints](http://stackoverflow.com/questions/tagged/google-app-engine) tags.

## 3.1. Useful links

Click on the following links to get more information about:
* [Google App Engine](https://developers.google.com/appengine/),
* [Google Cloud Endpoints](https://developers.google.com/appengine/docs/java/endpoints/),
* [Google Cloud Messaging](http://developer.android.com/google/gcm/index.html),
* [Android Studio](developer.android.com/sdk/installing/studio.html).
