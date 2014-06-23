<!DOCTYPE html>
<html>
<head>
    <title>Hello, App Engine!</title>
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
</head>
<body role="document" style="padding-top: 70px;">

<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Hello, App Engine!</a>
        </div>
        <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav">
                <li><a href="https://developers.google.com/appengine/docs/java/">Google App Engine documentation</a></li>
                <li><a href="https://console.developers.google.com">Google Developers Console</a></li>
            </ul>
        </div>
    </div>
</div>

<div class="container theme-showcase" role="main">
    <div class="jumbotron">
        <div class="row">
            <div class="col-lg-12">
                <h1>Hello, App Engine!</h1>
                <p>Enter your name and press the button below to call <code>MyServlet</code>.</p>

                <form action="/hello" method="POST">
                    <div class="input-group">
                        <input type="text" class="form-control input-lg" placeholder="Name" name="name" />
                          <span class="input-group-btn">
                             <button class="btn btn-default btn-primary btn-group btn-lg" type="submit" id="helloButton">Say "Hello";</button>
                          </span>
                    </div>
                </form>
                <br/>
                <p>For more information about Google App Engine for Java, check out the <a href="https://developers.google.com/appengine/docs/java/">App Engine documentation</a>.</p>
                <p>If you need step-by-step instructions for connecting your Android application to this backend module, see <a href="https://github.com/GoogleCloudPlatform/gradle-appengine-templates/tree/master/HelloWorld">"App Engine Java Servlet Module" template documentation</a>.</p>
            </div>
        </div>
    </div>
</div>

</body>
</html>
