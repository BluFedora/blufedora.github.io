const week_item_names = [
                    "js_sun_week_item",
                    "js_mon_week_item",
                    "js_tue_week_item",
                    "js_wed_week_item",
                    "js_thu_week_item",
                    "js_fri_week_item",
                    "js_sat_week_item"
                  ];

function onSelectedWeekChange(evt)
{
  window.globals.week_selector.value =
            lib_date.to_string_yyyy_mm_dd(
            lib_date.get_monday(new Date(window.globals.week_selector.value + "T00:00:00")))
  globals.selected_week =
    lib_date.to_string_yyyy_mm_dd(new Date(window.globals.week_selector.value + "T00:00:00"));
  
  
   
  const truck_db    = firebase.firestore().collection("db_trucks");
  const truck_data  = truck_db.doc(truck_to_view);
  
  clearElementsOfClass("week_item_slot");
  
  truck_data
  .get()
  .then(
    function(doc)
    {
      if (doc.exists)
      {
        const document_data     = doc.data();
        const current_week_str  = globals.selected_week;
        const current_week_data = document_data["weeks"][current_week_str];

        if (current_week_data === undefined)
        {
            var new_data = { "weeks" : {} };
            new_data["weeks"][globals.selected_week] = DumpTruckWeek();
            truck_data.set(new_data, { merge: true });
            current_week_data = DumpTruckWeek();
        }

        for (var day = 0; day < 7; ++day)
        {
          var week_item_name = week_item_names[day];
          var day_data = current_week_data[day];
          var week_item_element = document.getElementById(week_item_name);
          var week_item_edit = week_item_element.getElementsByClassName("week_item_edit")[0];

          week_item_edit.truck_data = day_data;

          week_item_edit.onclick = function()
          {
            var dialog = new Dialog("Edit Window");

            var keys = Object.keys(this.truck_data);

            for (var key_index = 0; key_index < keys.length; ++key_index)
            {
              var key = keys[key_index];
              var input = dialog.pushInputNumber(this.truck_data[key].toString(), key);
              input.obj_to_change = this.truck_data;
              input.key_to_change = key;

              input.onchange = function()
              {
                this.obj_to_change[this.key_to_change] = parseFloat(this.value);
              };
            }

            var save_btn = dialog.pushButton("Save");

            save_btn.onclick = function()
            {
              //*
              truck_data.set(document_data).then(function() {
                  console.log("Document successfully written!");
              })
              .catch(function(error) {
                  console.error("Error writing document: ", error);
              });
              //*/
              this.dialog_parent.hide();
            };

            dialog.show();
          };

          Object.keys(day_data).forEach(function(key)
          {
            var week_item_slot = lib_dom.createDivWithClass("week_item_slot");
            week_item_slot.innerHTML = key + " = " + day_data[key];
            week_item_element.appendChild(week_item_slot);
          });
        }
      }
      else
      {
          // NOTE(Shareef): doc.data() will be undefined in this case.
        alert("No such document could be found");
      }
    }
  )
  .catch(
    function(error)
    {
      console.log("Error getting document:", error);
    }
  );
}

function clearElementsOfClass(className)
{
  var elements = document.getElementsByClassName(className);
  while(elements.length > 0){
      elements[0].parentNode.removeChild(elements[0]);
  }
}
