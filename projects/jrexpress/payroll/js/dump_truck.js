function DumpTruckEntry()
{
  var ret = {};
  ret.date_str       = "";
  ret.hours_worked   = 0.0;
  ret.tons           = 0.0;
  ret.driver_advance = 0.0;
  ret.gross_pay      = 0.0;
  ret.net_pay        = 0.0;
  return ret;
}

function DumpTruckWeek()
{
  var ret = [
    DumpTruckEntry(),
    DumpTruckEntry(),
    DumpTruckEntry(),
    DumpTruckEntry(),
    DumpTruckEntry(),
    DumpTruckEntry(),
    DumpTruckEntry()
  ];
  return ret;
}

function DumpTruck(name)
{
  this.data =
  {
    name: name,
    weeks: { }
  };
  
  // Meta Info
  this.viewer = "dump_truck.html";
}

DumpTruck.prototype.addWeek = function(date)
{
  this.data.weeks[
    lib_date.to_string_mm_dd_yyy(
      window.lib_date.get_monday(date)
    )
  ] = DumpTruckWeek();
};

DumpTruck.prototype.hasWeek = function(date)
{
  return this.data.weeks[
    lib_date.to_string_mm_dd_yyy(
      window.lib_date.get_monday(date)
    )
  ] !== undefined;
};
