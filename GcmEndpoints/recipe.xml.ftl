<?xml version="1.0"?>
<recipe>
    <instantiate from="build.gradle.ftl" to="${projectOut}/build.gradle" />
    <merge from="settings.gradle.ftl" to="${topOut}/settings.gradle" />

    <instantiate from="src/main/MessagingEndpoint.java.ftl" to="${srcOut}/MessagingEndpoint.java" />
    <instantiate from="src/main/OfyService.java.ftl" to="${srcOut}/OfyService.java" />
    <instantiate from="src/main/RegistrationEndpoint.java.ftl" to="${srcOut}/RegistrationEndpoint.java" />
    <instantiate from="src/main/RegistrationRecord.java.ftl" to="${srcOut}/RegistrationRecord.java" />

    <instantiate from="src/webapp/appengine-web.xml.ftl" to="${webOut}/WEB-INF/appengine-web.xml" />
    <instantiate from="src/webapp/index.html.ftl" to="${webOut}/index.html" />
    <instantiate from="src/webapp/web.xml.ftl" to="${webOut}/WEB-INF/web.xml" />
    <instantiate from="src/webapp/logging.properties.ftl" to="${webOut}/WEB-INF/logging.properties" />

    <mkdir at="${webOut}/js" />
    <mkdir at="${webOut}/css" />
</recipe>
