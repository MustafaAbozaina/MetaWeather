# MetaWeather App 

### Story: Customer requests to see weather feed info

### Narrative #1

```
As an online customer I want the app to see a home page screen with empty search that can search for weather for any city
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
When the customer requests to see a city weather
Then the app should display the current day and the days after that returns from api
```

#### Narrative #2 
```
As an Offline customer I want the app to see a home page screen with empty search that can search for last selected cities and its saved data 
```
#### Scenarios (Acceptance criteria)

```
Given the customer has no connectivity
When the customer requests to see a city weather
Then the app should display the only saved cities
```




