[out:json][timeout:400];

// Select country or state/province nodes inside the bounding box
node["place"~"country|state|province"]({{bbox}}) -> .places;

// Find administrative boundaries that match the selected admin level
relation["boundary"="administrative"]["admin_level"="2"](bn.places) -> .admin_boundary;

// Map the relation to an area
.admin_boundary map_to_area -> .searchArea;

// ================================
// Find power lines without a voltage tag
// ================================

// Find all power lines within the administrative boundary that lack a voltage tag
way["power"="line"](if:!is_tag("voltage"))(area.searchArea) -> .lines_no_voltage;

// ================================
// Find substations without a voltage tag
// ================================

// Find all substations within the administrative boundary that lack a voltage tag
node["power"="substation"](if:!is_tag("voltage"))(area.searchArea) -> .substations_no_voltage;
way["power"="substation"](if:!is_tag("voltage"))(area.searchArea) -> .substation_ways_no_voltage;
relation["power"="substation"](if:!is_tag("voltage"))(area.searchArea) -> .substation_relations_no_voltage;

// ================================
// Combine all relevant results
// ================================

(
  .lines_no_voltage;
  .substations_no_voltage;
  .substation_ways_no_voltage;
  .substation_relations_no_voltage;
  .admin_boundary;
);

out body;
>;
out skel qt;
