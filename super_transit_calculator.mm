#include "super_transit_calculator.h"
#include "../super_transit_calculator/src/super_transit.hpp"

@implementation TripWaypoint
@end

@implementation TripOptions
@end


NSArray *getTrips(TripOptions* options) {
    std::string schedule = std::string([options.stopSchedule UTF8String]);
    std::string locations = std::string([options.stopLocations UTF8String]);
    
    stransit::transit_info info = stransit::generate_transit_info_from_json(schedule, locations);
    stransit::trip_options options_for_search = {
        .start_position = {options.startLongitude, options.startLatitude},
        .start_time = {std::chrono::hours(options.startHour), std::chrono::minutes(options.startMinute)},
        .start_day = std::string([options.stopSchedule UTF8String]),
        .info = info,
        .end_position = {options.endLongitude, options.endLatitude},
        .max_wait_time = std::chrono::minutes(options.maxWaitMinutes),
        .max_walk_dist = options.maxWalkingMiles
    };
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    std::vector<stransit::trip> trips = stransit::get_trips(options_for_search);
    
    for (stransit::trip& t : trips) {
        NSMutableArray *waypoints = [[NSMutableArray alloc] init];
        for (stransit::trip::trip_waypoint& point : t.waypoints) {
            TripWaypoint *waypointObject = [[TripWaypoint alloc] init];
            waypointObject.name = [[NSString alloc] initWithUTF8String: point.name.c_str()];
            waypointObject.hour = point.time.m_hours.count();
            waypointObject.minute = point.time.m_minutes.count();
            
            switch (point.point_kind) {
            case stransit::trip::trip_waypoint::waypoint_begin:
                    waypointObject.waypointKind = tripWaypointBegin;
                    break;
            case stransit::trip::trip_waypoint::waypoint_stop:
                    waypointObject.waypointKind = tripWaypointStop;
                    break;
            case stransit::trip::trip_waypoint::waypoint_finish:
                    waypointObject.waypointKind = tripWaypointFinish;
                    break;
            }
            waypointObject.minutesOfTravelToNext = point.path_to_next.period_of_travel.count();
            waypointObject.milesOfTravelToNext = point.path_to_next.length_of_travel;
            waypointObject.edgeDescription = [[NSString alloc] initWithUTF8String: point.path_to_next.description.c_str()];
            [waypoints addObject:waypointObject];
        }

        [result addObject: waypoints];
    }

    return result;
}
