// if (typeof (Storage) !== "undefined"){ /* browser supports it */ }

function require_script(url, callback)
{
  'use strict';
  var head = document.getElementsByTagName('head')[0];
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = url;
    // There are several events for cross browser compatibility.
  script.onreadystatechange = callback;
  script.onload = callback;
  head.appendChild(script);
}

  // NOTE(Shareef): Will be called when all resources are done loading ala scripts
function onLoad(load_event)
{
  window.jr_express_payroller = {
    "truck_list"    : document.getElementById("js_truck_list"),
    "add_truck_btn" : document.getElementById("js_add_truck_btn"),
    "truck_map"     : {}
  };
  
  initJRExpressPayroll(firebase, function()
                      {
    console.log("JR Express: Payroll Initialized");
  });
  
  const firestore = payroll.firestore;
  const truck_db  = firestore.collection("db_trucks");
  
  TruckList_clearChildren();
  
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
  
   jr_express_payroller.truck_map[doc.id] = truck_child;
   jr_express_payroller.truck_list.appendChild(truck_child);
  
  var truck_delete_button = lib_dom.createDivWithClass("truck_list_item_delete");
  
  truck_delete_button.innerHTML = "Delete";
  
  truck_delete_button.onclick = function(e)
  {
    var dialog = new Dialog("Are You Sure?");
    
    var btns = dialog.pushButtons(["No", "Yes"]);
    
    btns[0].onclick = function()
    {
      this.dialog_parent.hide();
    };
    
    btns[1].truck_data = truck_child.truck_data;
    
    btns[1].onclick = function()
    {
      jrexpress.payroll.db_trucks.doc(this.truck_data.data.name).delete().then(function() {
          console.log("Document successfully deleted!");
      }).catch(function(error) {
          console.error("Error removing document: ", error);
      });
      this.dialog_parent.hide();
    };
    
    dialog.show();
    
    e.stopImmediatePropagation();
  };
  
  truck_child.appendChild(truck_delete_button);

  truck_child.onclick = function()
  {
    window.sessionStorage.setItem("ss_truck", this.truck_data.data.name);
    window.location.assign(this.truck_data.viewer);
  };
}

main();
