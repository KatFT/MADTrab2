set Planet;
set Type;
set Operation;


param ShuttleCost;
param NoMonths;
param InventoryPricePerUnit;
param InventoryPricePerUnitP;

param Price{Planet, Type, {1..NoMonths}};
param ShuttleCapacity;
param ProductionCapacity{Operation, Type};


var Active{Planet, {1..NoMonths}} binary;
var Produced{Type, {1..NoMonths}} >= 0;
var Exported{Planet, Type, {1..NoMonths}} >= 0;
var Inventory{Type, {0..NoMonths}} >= 0;

var InventoryPlanet{Planet,Type,{0..NoMonths}} >=0;
var Delivered{Planet, Type, {1..NoMonths}}>=0;


maximize Revenue:
  sum{p in Planet, t in Type, m in {1..NoMonths}}
     (Delivered[p, t, m] * Price[p, t, m])
  - InventoryPricePerUnit * sum {t in Type, m in {1..NoMonths}} Inventory[t, m]
  - ShuttleCost * sum{p in Planet, m in {1..NoMonths}} Active[p,m]
  - InventoryPricePerUnitP * sum {p in Planet,t in Type, m in {1..NoMonths}} InventoryPlanet[p,t, m];

subject to
  Shuttle{m in {1..NoMonths}, p in Planet}:
     sum{t in Type}
        Exported[p, t, m] <= ShuttleCapacity*Active[p,m];


  ProductionLineCapacity{o in Operation, m in {1..NoMonths}}:
    sum{t in Type} (Produced[t, m] / ProductionCapacity[o,t]) <= 1;

  InitialInventoryCapacity{t in Type}:
     Inventory[t, 0] = 0;

  InventoryBalance{t in Type, m in {1..NoMonths}}:
    Inventory[t, m] = Inventory[t, m-1] + Produced[t, m] - sum{p in Planet} Exported[p, t, m];

  InitialInventoryCapacityPlanet{p in Planet,t in Type}:
     InventoryPlanet[p,t, 0] = 0;

  InventoryBalancePlanet{p in Planet,t in Type, m in {1..NoMonths}}:
    InventoryPlanet[p,t, m] = InventoryPlanet[p,t, m-1] + Exported[p,t,m] - Delivered[p,t,m];
