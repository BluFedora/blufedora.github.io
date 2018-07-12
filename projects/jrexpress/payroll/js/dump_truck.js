function DumpTruckEntry()
{
  this.date_str       = "";
  this.hours_worked   = 0.0;
  this.tons           = 0.0;
  this.driver_advance = 0.0;
  this.gross_pay      = 0.0;
  this.net_pay        = 0.0;
}

function DumpTruckWeek(monday_date)
{
  this.mon  = new DumpTruckEntry();
  this.tue  = new DumpTruckEntry();
  this.wed  = new DumpTruckEntry();
  this.thu  = new DumpTruckEntry();
  this.fri  = new DumpTruckEntry();
  this.sat  = new DumpTruckEntry();
  this.sun  = new DumpTruckEntry();
}

function DumpTruck(name)
{
  this.data =
  {
    name: name,
    weeks: {}
  };
  
  // Meta Info
  this.viewer = "dump_truck.html";
}

DumpTruck.prototype.addWeek = function(monday_date, week_data)
{
  this.data.weeks[lib_date.to_string_mm_dd_yyy(monday_date)] = week_data;
};
