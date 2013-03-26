This app allows a user to monitor the "on-time-ness" of journeys they take on Seattle public transit (ex. daily commutes) by regularly checking the real-time transit data provided by One Bus Away in a window that matches the route-stop-time of when the user typically takes the journey.

The app collects this data and determines if the bus actually arrived or departed early, late or on-time (based on it's scheduled time). As it builds up historical data for this route-stop-time, it can better predict the behavior of this bus at this stop at this time.

For multi-leg trips, the app will also determine if there is enough predicted transfer time (as suggested by Google transit directions) between legs, or if the historical performance of the bus on each leg will interfere with the user completing their anticipated journey.

By presenting this aggregated information in a visual way to the user, she can make better judgements about the routes she takes on public transit.

![Bus Trip Planner Mindmap](/mindmap.png " Bus Trip Planner Mindmap")

## Roadmap

+ ✓ Create repository
+ ✓ Create readme
+ ▢ Setup 'bootstrap-sass' gem to use Twitter Bootstrap in project
+ ▢ **Feature:** CRUD trips to monitor (startpoint, endpoint, arrive_by/leave_by, time)
+ ▢ Figure out how to use Google Maps JS API to fetch possible routes to user
+ ▢ **Feature:** Let user store/CRUD selected routes
+ ▢ Figure out how to use GMaps API to fetch legs
+ ▢ **Feature:** store these legs to monitor

## Process flow

![Process flow for bus trip app](/process.png "Process flow")

Sequence diagram generated at http://bramp.github.com/js-sequence-diagrams with the following code:

```
User->Trip: Creates new Trip
Trip-->Google API: Requests directions
Google API-->Trip:
Note left of One Bus Away API: To do: \nReplace the following \n'transit stop ID' req/resp \nwith local db lookup
Trip-->One Bus Away API: Requests transit stop IDs
One Bus Away API-->Trip:
Note over Route: Route model cleans up\nraw API response
Trip-->Route: Adds new Route object to Trip for each route
Trip->User: Shows possible Routes
Note over User: User slects a specific route \n to expand directions.
Note right of User: Load Real Time Data \n event triggered
User-->Real Time Controller: AJAX request to get real time data for route stops
Real Time Controller-->One Bus Away API: Request latest data from OBA
One Bus Away API-->Real Time Controller:
Real Time Controller-->User:
Note over User: AJAX refreshes realtime data every minute
User->Account: Registers / Login
Account->Trip: Load saved trip
```
