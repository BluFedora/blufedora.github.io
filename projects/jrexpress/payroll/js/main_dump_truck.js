function onSelectedWeekChange(evt)
{
  window.globals.week_selector.value =
            lib_date.to_string_yyyy_mm_dd(
            lib_date.get_monday(new Date(window.globals.week_selector.value + "T00:00:00")))
  globals.selected_week =
    lib_date.to_string_yyyy_mm_dd(new Date(window.globals.week_selector.value + "T00:00:00"));
  
  var new_data = {};
  new_data[globals.selected_week] = [
    {"sunday" : "sunday"},
    {"monday" : "monday"},
    {"tuesday" : "tuesday"},
    {"wednesday" : "wednesday"},
    {"thursday" : "thursday"},
    {"friday" : "friday"},
    {"saturday" : "saturday"}
  ];
   
  const truck_db    = firebase.firestore().collection("db_trucks");
  const truck_data  = truck_db.doc(truck_to_view);
  truck_data.set(new_data, { merge: true });
}
