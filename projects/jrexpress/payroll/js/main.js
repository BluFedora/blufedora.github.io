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
    "add_truck_btn" : document.getElementById("js_add_truck_btn"),
    "truck_map"     : {}
  };
  
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
      
      TruckList_clearChildren();
      querySnapshot.forEach(TruckList_add);
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
            TruckList_add(change.doc);
          }
          
          if (change.type === "modified") 
          {
            // NOTE(Shareef): Not needed for no but maybe in the future...
            console.log("Modified: ", change.doc.id, change.doc.data());
          }
          
          if (change.type === "removed")
          {
            var truck_item = jr_express_payroller.truck_map[change.doc.id];
            truck_item.parentElement.removeChild(truck_item);
            console.log("Removed: ", change.doc.id, change.doc.data());
          }
        }
      );
    }
  );
  /*
  truck_db.doc("new_doc2").set(emailObject);
  truck_db.doc("new_doc3").set(emailObject);
  truck_db.doc("new_doc4").set(emailObject);
  truck_db.doc("new_doc5").set(emailObject);
  
  truck_db.doc("new_doc3").delete().then(function() {
    console.log("Document successfully deleted!");
  }).catch(function(error) {
      console.error("Error removing document: ", error);
  });
  */
  var add_truck_btn = window.jr_express_payroller.add_truck_btn;
  
  jr_express_payroller.dialog_is_open = false;
  
  add_truck_btn.addEventListener(
    "click",
    function(evt)
    {
      if (!jr_express_payroller.dialog_is_open)
      {
        var dialog = new Dialog("New Truck", function(dialog) { jr_express_payroller.dialog_is_open = false; });

        dialog.pushLabel("Truck Name:");
        var truck_name_input = dialog.pushInputText(null, "Truck Name Here");
        dialog.pushLabel("Truck Type:");
        var truck_type_input = dialog.pushOptions([
          { value : "dump_truck", label : "Dump Truck"    },
          { value : "otr_truck",  label : "Over The Road" }
        ]);
        var accept_btn = dialog.pushButton("Make Truck");

        accept_btn.addEventListener(
          "click", function()
          {
            const truck_type = truck_type_input.value;
            var truck_data = null;
            
            if (truck_type == "dump_truck")
            {
              truck_data = new DumpTruck(truck_name_input.value);
              truck_data.addWeek(new Date());
            }
            else if (truck_type == "otr_truck")
            {
              truck_data = new OverTheRoadTruck(truck_name_input.value);
            }
            
            truck_db.doc(truck_name_input.value).set(truck_data.data);
            
            jr_express_payroller.dialog_is_open = false;
            this.dialog_parent.hide();
          }
        );

        dialog.show();
        
        jr_express_payroller.dialog_is_open = true;
      }
    }
  );
  
  console.log(jr_express_payroller);
  console.log(new OverTheRoadTruck());
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

function TruckList_clearChildren()
{
  var truck_map   = jr_express_payroller.truck_map;
  var truck_list  = jr_express_payroller.truck_list;
  
  Object.keys(truck_map).forEach(function(key) {
    delete truck_map[key];
  });
  
  while (truck_list.lastChild)
  {
    truck_list.removeChild(truck_list.lastChild);
  }
}

function TruckList_add(doc)
{
  var truck_child = lib_dom.createDivWithClass("truck_list_item");
  truck_child.innerHTML = doc.id;
  truck_child.truck_data = new DumpTruck(doc.id);

  truck_child.onclick = function()
  {
    window.sessionStorage.setItem("ss_truck", this.innerHTML);
    window.location.assign(this.truck_data.viewer);
  };

  jr_express_payroller.truck_map[doc.id] = truck_child;
  jr_express_payroller.truck_list.appendChild(truck_child);
}

main();
