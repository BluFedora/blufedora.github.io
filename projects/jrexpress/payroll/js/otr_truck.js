function OverTheRoadTruck(name)
{
  this.data = {
    "name"    : name,
    "entries" : []
  };
  
  // Meta Info
  this.viewer = "otr_truck.html";
  this.document_ref = payroll.db_trucks.doc(name);
}

OverTheRoadTruck.prototype.addEntry = function(date)
{
    // Local Data Update
  var entry = OTREntry();
  entry.date = lib_date.to_string_yyyy_mm_dd(date);
  this.data.entries.push(entry);
  
    // Server Data Update
  this.document_ref.set(this.data, { merge: true });
  
  return entry;
}

function OTREntry()
{
  var ret = {};
  ret.date                    = "DATE_HERE";
  ret.load_number             = 0;
  ret.trip_miles              = 0.0;
  ret.driver_advance          = 0.0;
  ret.driver_gross_pay        = 0.0;
  ret.driver_at_fault_damages = 0.0;
  ret.driver_reimbursed       = 0.0;
  ret.net_pay                 = 0.0;
  return ret;
}
