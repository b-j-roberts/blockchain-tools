var keythereum = require("keythereum");

var password = "password";

// Take the following as process variables: datadir, address
var datadir = process.argv[2];
var address = process.argv[3];

var keyObject = keythereum.importFromFile(address, datadir);
var privateKey = keythereum.recover(password, keyObject);
console.log(privateKey.toString("hex"));
