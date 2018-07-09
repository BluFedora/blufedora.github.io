// if (typeof (Storage) !== "undefined"){ /* browser supports it */ }

function UrlVars()
{
  this.vars = {};
  
  window.location.href.replace(
    /[?&]+([^=&]+)=([^&]*)/gi,
    function(m, key, value)
    {
      this.vars[key] = value;
    }
  );
}

UrlVars.prototype.get = function(key, defaultValue)
{
  var return_value = defaultValue;
  
  if (this.has(key))
  {
    return_value = this.vars[key];
  }
  
  return return_value;
};

UrlVars.prototype.has = function(key)
{
  return (key in this.vars);
};

var lib_dom = {
  
  createDivWithClass : function(clzName)
  {
    var element = document.createElement("div");
    element.classList.add(clzName);
    return element;
  }
  
};

function require_script(url, callback)
{
  'use strict';
  
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

  // Will be called when all resources are done loading ala scripts
function onLoad(load_event)
{
  window.jr_express_payroller = {
    "truck_list"    : document.getElementById("js_truck_list"),
    "add_truck_btn" : document.getElementById("js_add_truck_btn")
  };
  
  console.log(jr_express_payroller);
  console.log(new OverTheRoadTruck());
  
  const firestore = firebase.firestore();
  const settings = { timestampsInSnapshots: true };
  firestore.settings(settings);
  
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
  
  var truck_db = firestore.collection("db_trucks");
  
  truck_db.get().then(
    (querySnapshot) =>
    {
      while (jr_express_payroller.truck_list.lastChild)
      {
        jr_express_payroller.truck_list.removeChild(jr_express_payroller.truck_list.lastChild);
      }
      
      querySnapshot.forEach(
        (doc) =>
        {
          var truck_child = lib_dom.createDivWithClass("truck_list_item");
          truck_child.innerHTML = doc.id;
          truck_child.truck_data = new DumpTruck(doc.id);
          
          // console.log(doc.data());

          truck_child.onclick = function()
          {
            window.sessionStorage.setItem("ss_truck", this.innerHTML);
            window.location.assign(this.truck_data.viewer);
            //this.classList.toggle("expanded");
          };

          jr_express_payroller.truck_list.appendChild(truck_child);
        }
      );
    }
  );
  
  var emailObject = {
    email: "hello 3 sdfsdjfhskdjhkj"
  };
  
  truck_db.onSnapshot(
    function(snapshot)
    {
      snapshot.docChanges().forEach(
        function(change) 
        {
          if (change.type === "added")
          {
            console.log("Added: ", change.doc.id, change.doc.data());
          }
          
          if (change.type === "modified") 
          {
            console.log("Modified: ", change.doc.id, change.doc.data());
          }
          
          if (change.type === "removed")
          {
            console.log("Removed: ", change.doc.id, change.doc.data());
          }
        }
      );
    }
  );
  
  truck_db.doc("new_doc2").set(emailObject);
  truck_db.doc("new_doc3").set(emailObject);
  truck_db.doc("new_doc4").set(emailObject);
  truck_db.doc("new_doc5").set(emailObject);
  
  truck_db.doc("new_doc3").delete().then(function() {
    console.log("Document successfully deleted!");
  }).catch(function(error) {
      console.error("Error removing document: ", error);
  });
  
  var add_truck_btn = window.jr_express_payroller.add_truck_btn;
  
  add_truck_btn.addEventListener(
    "click",
    function(evt)
    {
      var truck_name = window.prompt("Name Of the New Truck");
      
      if (truck_name != null)
      {
        truck_db.doc(truck_name).set({
          "name" : "This is the new truck"
        });
      }
    }
  );
}

function main()
{
  'use strict';
  
  require_script(
    "js/dump_truck.js",
    function()
    {
      require_script(
        "js/otr_truck.js",
        function()
        {
          console.log("All required scripts loaded");
          console.log(new DumpTruck("Test"));
        }
      );
    }
  );
  
  window.addEventListener("load", onLoad);
}

main();
