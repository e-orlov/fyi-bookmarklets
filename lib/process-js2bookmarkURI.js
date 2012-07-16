var e = '', filename = process.argv[2];
if (filename) {
	try {
		var fs = require('fs');
		var fd = fs.readFileSync(filename,encoding='utf8');
		console.log('javascript:'+encodeURI(fd.split("\n")[0]));
		process.exit(0);
	}
	catch (e) {
		console.error('(' + process.argv[1].split('/').reverse().shift() + ') ' + e);
	}
}
else {
	console.error('Usage: ' + process.argv[0] + ' ' + process.argv[1].split('/').reverse().shift() + ' inputfile');
	console.error('   Reads utf-8 encoded inputfile, applies JavaScript encodeURI(), and writes to STDOUT');
}
process.exit(1);
