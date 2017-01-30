/**
 * Public header for super transit
 */

#ifndef SUPER_TRANSIT_CALCULATOR_H
#define SUPER_TRANSIT_CALCULATOR_H

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    typedef enum TripWaypointKind {
        tripWaypointBegin, tripWaypointStop, tripWaypointFinish
    } TripWaypointKind;
    
@interface TripWaypoint : NSObject
@property NSString *name;
@property int hour, minute;
@property TripWaypointKind waypointKind;
@property int minutesOfTravelToNext;
@property double milesOfTravelToNext;
@property NSString *edgeDescription;
@end
    
    typedef NSArray* Trip;
    
@interface TripOptions : NSObject

@property double startLongitude;
@property double startLatitude;
@property int startHour;
@property int startMinute;
@property NSString *startDay;
@property double endLongitude;
@property double endLatitude;
@property int maxWaitMinutes;
@property double maxWalkingMiles;
@property NSString *stopSchedule;
@property NSString *stopLocations;

@end
    
    NSArray *getTrips(TripOptions* options);
    
#ifdef __cplusplus
}
#endif

#endif
