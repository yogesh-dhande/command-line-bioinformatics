// Credit: https://github.com/krasimir/evala/blob/master/src/server.js

var terminals = {}, logs = {};

const express = require('express');
const app = express();
const pty = require('node-pty');

const port = 3000;

const host = 'localhost';
const ALLOWED_ORIGINS = [
  '0.0.0.0',
  '127.0.0.1',
  'localhost',
  'chrome-extension://'
];

app.use(function (req, res, next) {
  console.log("Received request")
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'X-Requested-With');

  let origin = req.get('origin');
  let host = req.get('host');
  console.log(host)
  let foundOrigin = ALLOWED_ORIGINS.find(o => (origin && origin.indexOf(o) >= 0));
  let foundHost = ALLOWED_ORIGINS.find(h => (host && host.indexOf(h) >= 0));

  if (!foundOrigin && !foundHost) {
    res.status(403);
    res.send('Go away!');
    res.end();
    return;
  }
  next();
});

// TODO figure out how to build the Vue app for server-side rendering
// app.use('/', express.static(__dirname + '/../client/dist'));

require('express-ws')(app);

app.post('/terminals', function (req, res) {
  let cols = parseInt(req.query.cols, 10);
  let rows = parseInt(req.query.rows, 10);
  let term = pty.spawn('bash', ["sandbox.sh"], {
    name: 'xterm-color',
    cols: cols || 80,
    rows: rows || 24,
    cwd: process.env.PWD,
    env: process.env
  });

  terminals[term.pid] = term;
  console.log('Created terminal with PID: ' + term.pid);
  console.log(`${Object.keys(terminals).length} terminal running`);
  logs[term.pid] = '';
  term.on('data', function (data) {
    logs[term.pid] += data;
  });
  res.send(term.pid.toString());
  res.end();
});

app.post('/terminals/:pid/size', function (req, res) {
  let pid = parseInt(req.params.pid, 10);
  let cols = parseInt(req.query.cols, 10);
  let rows = parseInt(req.query.rows, 10);
  let term = terminals[pid];

  term.resize(cols, rows);
  console.log('Resized terminal ' + pid + ' to ' + cols + ' cols and ' + rows + ' rows.');
  res.end();
});

app.ws('/terminals/:pid', function (ws, req) {
  var term = terminals[parseInt(req.params.pid, 10)];

  if (!term) {
    ws.send('No such terminal created.');
    return;
  }

  console.log('Connected to terminal ' + term.pid);
  ws.send(logs[term.pid]);

  term.on('data', function (data) {
    // console.log('Incoming data = ' + data);
    try {
      ws.send(data);
    } catch (ex) {
      // The WebSocket is not open, ignore
    }
  });
  ws.on('message', function (msg) {
    console.log(msg)
    term.write(msg);
  });
  ws.on('close', function () {
    term.kill();
    console.log('Closed terminal ' + term.pid);
    // Clean things up
    delete terminals[term.pid];
    delete logs[term.pid];
  });
});


app.listen(port);
console.log('Listening at http://' + host + ':' + port);