const express = require('express'),
    es6Renderer = require('express-es6-template-engine')
const config = require('config')
const cookieParser = require('cookie-parser');

const app = express()

const port = config.get('web.port');

app.engine('html', es6Renderer);
app.set('view engine', 'html');
app.use(express.static('public'));
app.use(cookieParser());
app.set('views', './views');
app.set('css', './css');
app.set('js', './js');
app.set('images', './images');

app.get("/auth", function (req, res) {
    res.render("index")
});

app.get("/main", function (req, res) {
    let cookieVal = req.cookies.MonitoringCookieToken;
    if (cookieVal){
        res.render("main")
    }
    else{
        res.redirect(401, "auth")
    }
});

app.get("/profile", function (req, res) {
    let cookieVal = req.cookies.MonitoringCookieToken;
    if (cookieVal){
        res.render("profile")
    }
    else{
        res.redirect(401, "auth")
    }
});

app.get("/log", function (req, res) {
    let cookieVal = req.cookies.MonitoringCookieToken;
    if (cookieVal){
        res.render("log")
    }
    else{
        res.redirect(401, "auth")
    }
});

app.get("/users", function (req, res) {
    let cookieVal = req.cookies.MonitoringCookieToken;
    if (cookieVal){
        res.render("users")
    }
    else{
        res.redirect(401, "auth")
    }
});

app.get("", function (req, res){
    res.redirect(301, "auth")
})

app.listen(port
    //, () => console.info(`App listening on port:  ${port}`)
)