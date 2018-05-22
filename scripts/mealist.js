var Mealist = Mealist || 
(function Mealist()
{
	var $_GET = {};
	var GLOBALS = {
		_intervalID 	: 0,
		_accessToken 	: ""
	};
	
	if(document.location.toString().indexOf('?') !== -1) 
	{
		var query = document.location
					   .toString()
					   // get the query string
					   .replace(/^.*?\?/, '')
					   // and remove any existing hash string (thanks, @vrijdenker)
					   .replace(/#.*$/, '')
					   .split('&');

		for(var i=0, l=query.length; i<l; i++) {
		   var aux = decodeURIComponent(query[i]).split('=');
		   $_GET[aux[0]] = aux[1];
		}
	}
	
	// https://developers.google.com/identity/protocols/OAuth2ServiceAccount
	// https://stackoverflow.com/questions/28751995/how-to-obtain-google-service-account-access-token-javascript
	function get_token(key, iss, cb)
	{
		//var key 					= "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC+kE1CqZxyxpHM\n78RnOaFuWRZwp1g0X/kJiQMhGytU+qFPGBLB3U5ztPuG06cg1YX1nKUqMa2c1o5E\nmGM3DYezxAMhKwYekm5C8s/RqiExlOmNVU0KGsirfyw5bd1Uezp6gfNXdQQewOJb\nD0+eXervVLZnv99yT9cckZkpyHlmWOfUhj31c9m4iLO6PR0guyfR1+M3QksjMAgo\nRwlBdWsYroL0r/Yl1CgIKb7VtLLUz/jnW6VQx9cfWp26eHlx+IYg8104+1oqGroW\ndsLQcprLlRbEHmt7jwr3j2JjHUPA60HCLgPhrO8nRUANJJElcBwUgKaerkK9HR8K\nLkOZMU17AgMBAAECggEADKbprO3e6GiSSzrLXZZ1cdfyBfZjrvfaQc2kyrYSPpj0\nocWK5UUrYsJBhYuYMoq1U1UcStIJNqWwxLwgsN8x7c0AmjClk4e2+19B+KfPfrUQ\n0TnjHLMiNJoDwSewBLO5HQ4eA7tN/o622JiKeYy/FDcZydydhL+T8XPMk/oZQ/gF\n3Y1s3RzyqIc8GObyZTQTSVTtoTEb5lTJXy7uEeDUmbYWGZ59V5DrG6Fc7E40SDSM\ndThtPWEwp1MoHR+IIwxp9BpPeOFktSXByb/a985SARBO3yifNMafDC+BXRxk/T62\nwJ4mUV5rOu659SYnJM9fAyLzOYiZoXMQtE5S2X5T2QKBgQD9ThHWEFZ+itC+Leaa\nG5kzFUJUn8jttT9esr/doJBcu8bFqge5fHdDuHeNEzTtrF09Tb3kC6VannXWho2D\nCDxH1yBUApCToKja9bwZIStynKW+BHFZVJ09KG7S/Fu4F+C9hBIzayVvac7K1UQA\nVOdGidHVTNmVr87FdxAecvc02QKBgQDAl1fCGyfcoFhJUiXRfK1HA0V5rb0jIzL5\n92rgJ5zY8sGbID3nuHBMDcX9OF376LrxY3640azxOJZJTKs9LUAK/kZWhSLayJEb\nWszrEe/O6wz2x+xRA2ifE4J83xPegFXGt1pyntO2sNNazIlTbDNgk+SKv47jZI5r\n99deFS8QcwKBgDHWEFBLepj++r7QDRS45VVVk21O2ptaE5OwG2uhUYXNM/hj0Y0+\n3cAnJO5OnxU72kRbbUbWu7uufYStiF4FWsbPnn6o2oUREOezfUR8cC3mf/14pkxr\nB1ym/dbo66q2l/LxbxtKs1zONm9VskFWcwI/z1bl/dEje80B9dvnxpdRAoGBAKZy\n5rzy/VuYFVWhMuA/8f5a3HPSbZHtvQP/CxaaBdwWyq9IiVg4to10pfY4/jlWpiM0\nC3SuetqsPm8xXRntftlBdAcY38vY5liO/GX5xZm+2iB7H0nROV2q3e8QWbrGjdvF\n4d0IWhAd+T0TY2h/LlQ83Zvw/QyYfuLfe/prMpbzAoGBAKFXEm6NxN5yI9vVop40\nswM1WPI7rzoxLIhZgnuQDl6n7BVFoxRg2FdRHaTuNOYdOyIEukhugAI51RA0cLJF\nhfpZ86SR/oEfh+WVY/KcQevqkES8neyNN16o+Ej55vVxsknwNwt+5fFUrmRU9+K3\n4JOvejr9WLSMp8UpQkdTIOC1\n-----END PRIVATE KEY-----\n";
		var pHeader 				= {"alg":"RS256","typ":"JWT"}
		var sHeader 				= JSON.stringify(pHeader);
		var pClaim 					= {};
		pClaim.iss 					= (iss != null) ? iss : "mealist-database-editor@brave-smile-173315.iam.gserviceaccount.com"; // TODO CHANGE
		pClaim.scope 				= "https://www.googleapis.com/auth/spreadsheets";
		pClaim.aud 					= "https://www.googleapis.com/oauth2/v4/token";
		pClaim.exp 					= KJUR.jws.IntDate.get("now + 1hour");
		pClaim.iat 					= KJUR.jws.IntDate.get("now");
		var sClaim 					= JSON.stringify(pClaim);
		var sJWS 					= KJUR.jws.JWS.sign(null, sHeader, sClaim, key);
		var XHR 					= new XMLHttpRequest();
		var urlEncodedData		 	= "";
		var urlEncodedDataPairs 	= [];

		urlEncodedDataPairs.push(encodeURIComponent("grant_type") + '=' + encodeURIComponent("urn:ietf:params:oauth:grant-type:jwt-bearer"));
		urlEncodedDataPairs.push(encodeURIComponent("assertion")  + '=' + encodeURIComponent(sJWS));
		urlEncodedData 				= urlEncodedDataPairs.join('&').replace(/%20/g, '+');

		XHR.addEventListener('load', function(event) 
		{
			var response = JSON.parse(XHR.responseText);
			var token = response["access_token"];
			cb(token);
		});

		XHR.addEventListener('error', function(event) 
		{
			console.log('Oops! Something went wrong.');
		});

		XHR.open('POST', 'https://www.googleapis.com/oauth2/v4/token');
		XHR.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		XHR.send(urlEncodedData);
	}
	
	function getPlatform()
	{
		var OSName 		= "UnknownOS";
		var userAgent 	= navigator.userAgent;

		if (userAgent.indexOf("Win") 		!= -1) 	OSName = "Windows";
		if (userAgent.indexOf("Mac") 		!= -1) 	OSName = "Macintosh";
		if (userAgent.indexOf("Linux") 		!= -1) 	OSName = "Linux";
		if (userAgent.indexOf("Android") 	!= -1) 	OSName = "Android";
		if (userAgent.indexOf("like Mac")	!= -1) 	OSName = "iOS";

		return OSName;
	}
	
	function loadScript(url, callback)
	{
		// Adding the script tag to the head as suggested before
		var head = document.getElementsByTagName('head')[0];
		var script = document.createElement('script');
		script.type = 'text/javascript';
		script.src = url;

		// Then bind the event to the callback function.
		// There are several events for cross browser compatibility.
		script.onreadystatechange = callback;
		script.onload = callback;

		// Fire the loading
		head.appendChild(script);
	}
	
	function sha1(msg)
	{
		function rotl(n,s) { return n<<s|n>>>32-s; };
		function tohex(i) { for(var h="", s=28;;s-=4) { h+=(i>>>s&0xf).toString(16); if(!s) return h; } };

		var H0=0x67452301, H1=0xEFCDAB89, H2=0x98BADCFE, H3=0x10325476, H4=0xC3D2E1F0, M=0x0ffffffff; 
		var i, t, W=new Array(80), ml=msg.length, wa=new Array();
		msg += String.fromCharCode(0x80);
		while(msg.length%4) msg+=String.fromCharCode(0);
		for(i=0;i<msg.length;i+=4) wa.push(msg.charCodeAt(i)<<24|msg.charCodeAt(i+1)<<16|msg.charCodeAt(i+2)<<8|msg.charCodeAt(i+3));
		while(wa.length%16!=14) wa.push(0);
		wa.push(ml>>>29),wa.push((ml<<3)&M);
		
		for( var bo=0;bo<wa.length;bo+=16 ) 
		{
			for(i=0;i<16;i++) W[i]=wa[bo+i];
			for(i=16;i<=79;i++) W[i]=rotl(W[i-3]^W[i-8]^W[i-14]^W[i-16],1);
			
			var A=H0, B=H1, C=H2, D=H3, E=H4;
			
			for(i=0 ;i<=19;i++) t=(rotl(A,5)+(B&C|~B&D)+E+W[i]+0x5A827999)&M, E=D, D=C, C=rotl(B,30), B=A, A=t;
			for(i=20;i<=39;i++) t=(rotl(A,5)+(B^C^D)+E+W[i]+0x6ED9EBA1)&M, E=D, D=C, C=rotl(B,30), B=A, A=t;
			for(i=40;i<=59;i++) t=(rotl(A,5)+(B&C|B&D|C&D)+E+W[i]+0x8F1BBCDC)&M, E=D, D=C, C=rotl(B,30), B=A, A=t;
			for(i=60;i<=79;i++) t=(rotl(A,5)+(B^C^D)+E+W[i]+0xCA62C1D6)&M, E=D, D=C, C=rotl(B,30), B=A, A=t;
			
			H0=H0+A&M;H1=H1+B&M;H2=H2+C&M;H3=H3+D&M;H4=H4+E&M;
		}

		return tohex(H0)+tohex(H1)+tohex(H2)+tohex(H3)+tohex(H4);
	}
	
	// https://gist.github.com/sarciszewski/88a7ed143204d17c3e42
	// Javascript CSPRNG for Integers
	function csprng(min, max) 
	{
		var i = rval = bits = bytes = 0;
		var range = max - min;
		
		if (range < 1) {
			return min;
		}
		
		if (window.crypto && window.crypto.getRandomValues) 
		{
			// Calculate Math.ceil(Math.log(range, 2)) using binary operators
			var tmp = range;
			/**
			* mask is a binary string of 1s that we can & (binary AND) with our random
			* value to reduce the number of lookups
			*/
			var mask = 1;
			
			while (tmp > 0) 
			{
				if (bits % 8 === 0) 
				{
					bytes++;
				}
				
				bits++;
				mask = mask << 1 | 1; // 0x00001111 -> 0x00011111
				tmp = tmp >>> 1;      // 0x01000000 -> 0x00100000
			}

			var values = new Uint8Array(bytes);
			
			do 
			{
			  window.crypto.getRandomValues(values);

			  // Turn the random bytes into an integer
			  rval = 0;
				
			  for (i = 0; i < bytes; i++) 
			  {
				rval |= (values[i] << (8 * i));
			  }
			  // Apply the mask
			  rval &= mask;
				
			  // We discard random values outside of the range and try again
			  // rather than reducing by a modulo to avoid introducing bias
			  // to our random numbers.
			} while (rval > range);

			// We should return a value in the interval [min, max]
			return (rval + min);
		} 
		else 
		{
    		// CSPRNG not available, fail closed
    		throw Error('placeholder; this should be customized with accordance to whatever practices are best for Node.js')
  		}
	}
	
	var POST_USER_ACTION 		= "https://docs.google.com/forms/d/e/1FAIpQLSd6FzcD_QKiVmA38y1uPrOlW-wAOL1KiTUJxKoRn4jRC7lmTg/formResponse";
	var POST_USER_EMAIL 		= "entry.616118198";
	var POST_USER_USERNAME 		= "entry.124797391";
	var POST_USER_PASSWORD_HASH = "entry.1830313673";
	var POST_USER_PASSWORD_SALT = "entry.867916028";
	
	function encode(str)
	{
		return encodeURIComponent(str);
	}
	
	function QueryCTor(sheetID)
	{
		this.sheetID 	= "https://docs.google.com/a/google.com/spreadsheets/d/" + sheetID + "/gviz/tq?tq=";
		this.postData 	= "";
		this.query 		= "";
		
		this.add = function(key, value)
		{
			this.postData += "&" + encode(key) + "=" + encode(value);
		};
		
		this.query = function(value)
		{
			this.query = value;
		};
		
		this.send = function(callback)
		{
			var xhttp = new XMLHttpRequest();

			xhttp.onreadystatechange = function() 
			{
				if (this.readyState == 4 && this.status == 200) 
				{
					if (callback != null) 
					{
						callback(this.responseText);
					}
				}
			};

			xhttp.open("GET", this.sheetID + encode(this.query) + this.postData, true);
			xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
			xhttp.send();
		};
	}
	
	function DatabaseCtor(sheetID, apiKey)
	{
		this.sheetID 	= sheetID;
		this.apiKey 	= apiKey;
		this.page 		= "";
		
		this.sheet = function(pageName)
		{
			this.page = pageName;
			return this;
		};
		
		this.get = function(range, callback, error)
		{
			if (this.page.length > 0) {
				range = this.page + "!" + range;
			}
			
			gapi.client.sheets.spreadsheets.values.get({
		  		spreadsheetId: 	this.sheetID,
		  		range: 			range,
		  		key: 			this.apiKey
			})
			.then(function(response) 
			{
			 	var range = response.result;

			  	if (range.values != null) 
				{
					callback(range.values);
			  	}
				else
				{
					callback([]);	
				}
			}, 
			function(response) 
			{
				console.log('Mealist.Database.get::Error: ' + response.result.error.message);
				
				if (error != null) {
					error(response.result.error.message);
				}
			});	
		};
		
		this.update = function(range, values, callback, error)
		{
			if (this.page.length > 0) { range = this.page + "!" + range; }
			
			var request = {
				spreadsheetId: 		this.sheetID,
		  		range: 				range,
		  		key: 				this.apiKey,
				valueInputOption: 	'USER_ENTERED',
				values: 			values,
				access_token: 		GLOBALS._accessToken
		  	};
			
			gapi.client.sheets.spreadsheets.values.update(request)
			.then(function(response) 
			{
			  	if (callback != null) 
				{
					callback(response);
			  	} 
			}, 
			function(response) 
			{
				console.log('Mealist.Database.update::Error: ' + response.result.error.message);
				
				if (error != null) {
					error(response.result.error.message);
				}
			});
		};
		
		this.append = function(range, values, callback, error)
		{
			if (this.page.length > 0) { range = this.page + "!" + range; }
			
			var request = {
				spreadsheetId: 		this.sheetID,
		  		range: 				range,
		  		key: 				this.apiKey,
				valueInputOption: 	'USER_ENTERED',
				insertDataOption: 	"INSERT_ROWS",
				values: 			values,
				access_token: 		GLOBALS._accessToken
		  	};
			
			gapi.client.sheets.spreadsheets.values.append(request)
			.then(function(response) 
			{
			  	if (callback != null) 
				{
					callback(response);
			  	} 
			}, 
			function(response) 
			{
				console.log('Mealist.Database.append::Error: ' + response.result.error.message);
				
				if (error != null) {
					error(response.result.error.message);
				}
			});
		};
		
		this.delete = function(range, callback, error)
		{
			if (this.page.length > 0) { range = this.page + "!" + range; }
			
			var request = {
				spreadsheetId: 		this.sheetID,
		  		range: 				range,
		  		key: 				this.apiKey,
				access_token: 		GLOBALS._accessToken
		  	};
			console.log(request);
			
			gapi.client.sheets.spreadsheets.values.clear(request)
			.then(function(response) 
			{
			  	if (callback != null) 
				{
					callback(response);
			  	} 
			}, 
			function(response) 
			{
				console.log('Mealist.Database.delete::Error: ' + response.result.error.message);
				
				if (error != null) {
					error(response.result.error.message);
				}
			});
			
			/*
			var requests = [];
			
			requests.push({
				  "deleteNamedRange": {
					"namedRangeId": range
				  }
				});
			
			var request = {
				spreadsheetId: this.sheetID,
				key: 		this.apiKey,

				resource: {
				  requests: requests
				}
			  };
			
			
			gapi.client.sheets.spreadsheets.batchUpdate(request, function(err, response) 
			{
				if (err) {
					console.error("DELETE ERR: " + err);
					return;
				}
				
				console.log("DELETE: " + JSON.stringify(response, null, 2));
			});
			*/
		};	
	}
	
	function makeAccount(email, username, password, callback)
	{
		var xhttp = new XMLHttpRequest();
		
		var salt = csprng(0, 999999);
		var hash = sha1(salt + password);
		
		var postData = "";
		
		postData += encode(POST_USER_EMAIL) 		+ "=" + encode(email) 		+ "&";
		postData += encode(POST_USER_USERNAME) 		+ "=" + encode(username) 	+ "&";
		postData += encode(POST_USER_PASSWORD_HASH) + "=" + encode(hash) 		+ "&";
		postData += encode(POST_USER_PASSWORD_SALT) + "=" + encode(salt);
		
		xhttp.onreadystatechange = function() 
		{
			if (this.readyState == 4 && this.status == 200) 
			{
				if (callback != null) 
				{
					callback();
				}
			}
		};
		
		xhttp.open("POST", POST_USER_ACTION, true);
		xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
		xhttp.send(postData);
	}
	
	function update_token(token)
	{
		GLOBALS._accessToken = token;
	}
	
	return function MealistCtor(CLIENT_ID, API_KEY, ACCESS_KEY, ISS_EMAIL)
	{
		this.hash 			= sha1;
		this.salt 			= csprng;
		this.createAccount 	= makeAccount;
		this.encodeURL 		= encode;	
		this.$_GET 			= $_GET;
		this.platform 		= getPlatform;
		this.load 			= function(callback)
		{
			/*
			loadScript("https://apis.google.com/js/api.js", function()
			{
				loadScript("http://mealist.bluwhirlapps.com/js/external_libs.js", function()
				{
					
				});
			});
			*/
			gapi.load('client:auth2', function()
			{
				gapi.client.init({
					apiKey: 		API_KEY,
					discoveryDocs: 	["https://sheets.googleapis.com/$discovery/rest?version=v4"],
					clientId: 		CLIENT_ID,
					scope: 			"https://www.googleapis.com/auth/spreadsheets" // Allows read/write access
				}).then(function() 
				{	
					get_token(ACCESS_KEY, ISS_EMAIL, function(token)
					{
						GLOBALS._intervalID = setInterval(function()
						{
							get_token(ACCESS_KEY, ISS_EMAIL, update_token);	
						}, 
						3600000); // 1hr

						update_token(token);
						callback();
					});
				});
			});
		};
		
		this.kill = function()
		{
			clearInterval(GLOBALS._intervalID);
		};
		
		this.Query 			= QueryCTor;
		this.Database 		= DatabaseCtor;
	};
}());

window.Mealist = Mealist;

//var m = new Mealist();
//var q = new m.Query("18ULaT9QjBtK39--wuk2Nev0UIkEOkmHWpi03k7coIL8");
//q.add("sheet", "Sheet1");
//q.query("select *");
//q.send(function(response) { alert(response); }); 