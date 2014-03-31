// Currently, the appengine gradle plugin's appengine devappserver launch doesn't interact well with Intellij/AndroidStudio's
// Gradle integration.  As a temporary solution, please launch from the command line.
// ./gradlew modulename:appengineRun
// If you would like more information on the gradle-appengine-plugin please refer to the github page
// https://github.com/GoogleCloudPlatform/gradle-appengine-plugin

buildscript {
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath 'com.google.appengine:gradle-appengine-plugin:${appEngineVersion}'
    }
}

repositories {
    mavenCentral();
}

apply plugin: 'java'
apply plugin: 'war'
apply plugin: 'appengine'

sourceCompatibility = 1.7
targetCompatibility = 1.7

dependencies {
  appengineSdk 'com.google.appengine:appengine-java-sdk:${appEngineVersion}'
  compile 'com.google.appengine:appengine-endpoints:${appEngineVersion}'
  compile 'com.google.appengine:appengine-endpoints-deps:${appEngineVersion}'
  compile 'javax.servlet:servlet-api:2.5'
}

appengine {
  downloadSdk = true
  appcfg {
    oauth2 = true
  }
  endpoints {
    getClientLibsOnBuild = true
    getDiscoveryDocsOnBuild = true
  }
}
