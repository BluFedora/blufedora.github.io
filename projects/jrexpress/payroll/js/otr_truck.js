function OverTheRoadTruck(name)
{
  this.name = name;
  this.entries = {
    
    "10/10/2018" : new OTREntry()
    
  };
  
  // Meta Info
  this.viewer = "otr_truck.html";
}

function OTREntry()
{
  this.trip_miles               = 0.0;
  this.driver_advance           = 0.0;
  this.driver_at_fault_damages  = 0.0;
  this.driver_reimbursed        = 0.0;
  this.driver_gross_pay         = 0.0;
  this.net_pay                  = 0.0;
}
