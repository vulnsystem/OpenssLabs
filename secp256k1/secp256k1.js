const assert  = require('node:assert');
const crypto = require('node:crypto');
const buffer = require('node:buffer')
var jose = require('jose');
const { KeyObject } = require('node:crypto');

const alg = 'secp256k1'

/* 
Computes the shared secret using otherPublicKey as the other party's public key and 
returns the computed shared secret. 
*/
//First Method to use node:crypto to compute shared secret
// Generate Alice's keys...
const alice = crypto.createECDH(alg);
const aliceKey = alice.generateKeys();

// Generate Bob's keys...
const bob = crypto.createECDH(alg);
const bobKey = bob.generateKeys();

// Exchange and generate the secret...
const aliceSecret = alice.computeSecret(bobKey);
const bobSecret = bob.computeSecret(aliceKey);

//The secrets of alice and bob must equal
assert.strictEqual(aliceSecret.toString('hex'), bobSecret.toString('hex'));

/*
1. Sign and verify the data with private and public key
 */
//Generate private and public key of secp256k1
const { privateKey, publicKey } = crypto.generateKeyPairSync('ec', {
  namedCurve: alg,
});
const data = 'data to sign and verfiy'

//Sign the data with the private key
const sign = crypto.createSign('SHA256');
sign.update(data);
sign.end();
const signature = sign.sign(privateKey);

//verify the data with the public key
const verify = crypto.createVerify('SHA256');
verify.update(data);
verify.end();
console.log(verify.verify(publicKey, signature));

/* 
2. Computes the shared secret using otherPublicKey as the other party's public key and 
returns the computed shared secret. 
*/
console.log(privateKey.toString())
for (const [key, value] of Object.entries(privateKey.asymmetricKeyDetails)) {
  console.log(`${key}: ${value}`);
}

console.log(privateKey.export({format:'jwk'}))
const jwk = privateKey.export({format:'jwk'})
console.log(jwk.d)
console.log(jwk.d.length*6)
console.log(buffer.Buffer.from(jwk.d, 'base64url'))
console.log(buffer.Buffer.from(jwk.d, 'base64url').length)
key = buffer.Buffer.from(jwk.d, 'base64url');

/*
console.log(publicKey.export({format:'jwk'}))

console.log(privateKey.export({type:'sec1', format:'pem'}))
console.log(privateKey.export({type:'sec1', format:'der'}))

console.log('alice.getPrivateKey()')
console.log(alice.getPrivateKey())
console.log('alice.getPublicKey()')
console.log(alice.getPublicKey())
const key = crypto.createPrivateKey({
  key: privateKey.export({type:'sec1', format:'der'}),
  format:'der',
  type:'sec1'
}
)

console.log(key)
*/

const gg = crypto.createECDH(alg);
gg.setPrivateKey(key)
//gg.generateKeys()

console.log(gg.getPrivateKey());
//console.log(alice.getPrivateKey());


const asn = require('@panva/asn1.js')

(async ()=>{

const privatePem = privateKey.export({type:'sec1', format:'pem'});
const privat = await jose.importSPKI(privatePem, 'es256k')
console.log(privat)

})()
