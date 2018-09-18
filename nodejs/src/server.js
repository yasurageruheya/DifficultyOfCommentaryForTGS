import express from "express";
import bodyParser from "body-parser";

const app = express();

app.use(express.static("public"));
app.use(bodyParser.urlencoded({
	extended: true
}));
app.use(bodyParser.json());

app.use((req, res, next) =>
{
    const origin = req.headers.origin;
    
    if(checkDomain(origin))
    {
        res.header("Access-Control-Allow-Origin", origin);
        res.header("Access-Control-Allow-Methods", "GET, POST");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    }
    next();
});

const checkDomain = (origin) =>
{
	switch(origin)
	{
        case "http://192.168.43.155:3000":
        case "http://192.168.43.0:3000":
		case "http://localhost:3000":
			return true;
		default:
			return false;
	}
};

const allLog = [];
const prevLog = [];

app.post("/getLog", (request, response) =>
{
	let responseLog = "";
	let i = prevLog.length;
	while(i--)
	{
		responseLog += prevLog.pop() + "\n";
	}
	response.send(responseLog);
});

app.post("/sendLog", (request, response) =>
{
	allLog.push(request.body.message);
	prevLog.push(request.body.message);
	console.log("message : " + request.body.message);
	response.send("request received");
});

app.post("/exit", (request, response) =>
{
	server.close();
	response.send("server end");
});

const server = app.listen(3000, () =>
{
	console.log("difficulty-of-commentary app listening on port 3000!");
});