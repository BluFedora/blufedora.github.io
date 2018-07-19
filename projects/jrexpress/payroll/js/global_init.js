  // NOTE(Shareef): To Be Called After the Window has Loaded.
function initJRExpress()
{
  window.jrexpress = {
    "payroll" : { }
  };
}
  
  // NOTE(Shareef): To Be Called After the Window has Loaded.
function initJRExpressPayroll(firebase, callback)
{
  initJRExpress();
 
  var config = {
          apiKey: "AIzaSyD28u3r-lUzC8KaMrHNCp-uWGXJFgxTHLE",
          authDomain: "jr-express-payroller.firebaseapp.com",
          databaseURL: "https://jr-express-payroller.firebaseio.com",
          projectId: "jr-express-payroller",
          storageBucket: "",
          messagingSenderId: "757148896133"
        };
        firebase.initializeApp(config);
  
  const firestore = firebase.firestore();
  const settings  = { timestampsInSnapshots : true };
  firestore.settings(settings);
  
  jrexpress.payroll["firestore"] = firestore;
  jrexpress.payroll["db_trucks"] = firestore.collection("db_trucks");
  
    // NOTE(Shareef): Alias for easier development
  window.payroll = jrexpress.payroll;
  
  /*
    TODO(Shareef): Offline Support would be Great.
  
  firestore.enablePersistence()
  .then(function() {
      // Initialize Cloud Firestore through firebase
      var db = firebase.firestore();
  })
  .catch(function(err) {
      if (err.code == 'failed-precondition') {
          // Multiple tabs open, persistence can only be enabled
          // in one tab at a a time.
          // ...
      } else if (err.code == 'unimplemented') {
          // The current browser does not support all of the
          // features required to enable persistence
          // ...
      }
  });
  */
  
  if (callback)
  {
    callback(jrexpress.payroll);
  }
}
