var tls = require('tls'),
    fs = require('fs'),
    msg = [
            ".-..-..-.  .-.   .-. .--. .---. .-.   .---. .-.",
            ": :; :: :  : :.-.: :: ,. :: .; :: :   : .  :: :",
            ":    :: :  : :: :: :: :: ::   .': :   : :: :: :",
            ": :: :: :  : `' `' ;: :; :: :.`.: :__ : :; ::_;",
            ":_;:_;:_;   `.,`.,' `.__.':_;:_;:___.':___.':_;"
          ].join("\n").cyan;

var options = {
  ca: fs.readFileSync('./credentials/ca.cert'),
  key: fs.readFileSync('./credentials/server.key'),
  cert: fs.readFileSync('./credentials/server.cert'),
  ecdhCurve: 'secp256k1',
  maxVersion: 'TLSv1.2',
  ciphers: 'ECDHE-ECDSA-AES256-GCM-SHA384'
};

tls.createServer(options, function (s) {
  s.write(msg+"\n");
  s.pipe(s);
}).listen(8000);

