const jose = require('jose');
const crypto = require('node:crypto')

const secretKey= async () => {
  const alg = 'HS256'
  const secret = await jose.generateSecret(alg)
  const jwt = await new jose.SignJWT({ 'urn:example:claim': true })
    .setProtectedHeader({ alg })
    .setIssuedAt()
    .setIssuer('urn:example:issuer')
    .setAudience('urn:example:audience')
    .setExpirationTime('2h')
    .sign(secret)
  
  console.log(jwt)
}

secretKey();

(async () => {
  
  const alg1 = 'ES256K'
  const { publicKey, privateKey } = await jose.generateKeyPair(alg1)
  console.log(publicKey.constructor === crypto.KeyObject)
  console.log(typeof publicKey)
  console.log(publicKey instanceof crypto.KeyObject)
  console.log(publicKey.asymmetricKeyDetails)
  console.log(publicKey.export({type:'spki', format:'jwk'}))


  const jwt1 = await new jose.SignJWT({ 'urn:example:claim': true })
    .setProtectedHeader({alg:alg1})
    .setIssuedAt()
    .setIssuer('urn:example:issuer')
    .setAudience('urn:example:audience')
    .setExpirationTime('2h')
    .sign(privateKey)
  
  console.log(jwt1)
})()
