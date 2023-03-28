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

app.get("/auth", function (req, res) {
    res.render("index")
});

app.get("/main", function (req, res) {
    let cookieVal = req.cookies.token;
    console.log(cookieVal)
    if (cookieVal){
        res.render("main")
    }
    //res.render("main")
    else{
        res.redirect(401, "auth")
    }
});

app.get("", function (req, res){
    res.redirect(301, "main")
})

app.listen(port, () => console.info(`App listening on port:  ${port}`))