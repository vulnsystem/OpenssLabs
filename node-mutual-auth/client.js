var tls = require('tls'),
    fs = require('fs');

var options = {
  ca: fs.readFileSync('./credentials/ca.cert'),
  key: fs.readFileSync('./credentials/client.key'),
  cert: fs.readFileSync('./credentials/client.cert'),
  ecdhCurve: 'secp256k1',
  maxVersion: 'TLSv1.2',
  ciphers: 'ECDHE-ECDSA-AES256-GCM-SHA384'
};

var conn = tls.connect(8000, 'localhost', options, function() {
  if (conn.authorized) {
    console.log("Connection authorized by a Certificate Authority.");
  } else {
    console.log("Connection not authorized: " + conn.authorizationError)
  }
});

// Send a friendly message
conn.write("I am the client sending you a message.");

conn.on("data", function (data) {
  console.log('Receive:' + data.toString());
  conn.end();
});

conn.on('close', function() {
 console.log("Connection closed");
});

conn.on('error', function(error) {
  console.error(error);
  conn.destroy();
});
  
