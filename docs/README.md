# API documentation

## Endpoints list

- [Health check](#health-check)
- [Get hotel prices](#get-hotel-prices)

---

## Health check

This is health check endpoint for the API

Request: GET https://tranquil-refuge-98145.herokuapp.com/hotels/heartbeat

Response: OK

## Get hotel prices

This is search endpoint for hotel prices. The endpoint does two main things:

- Fetch prices from suppliers and store: It asychronously sends requests to a list of suppliers to get list of hotels with their prices and store the results to redis using search key as key. The results will be expired after 5 minutes.

- Serve the results from redis to client: It fetch all the data for a certain search key, pick out the cheapest price for each hotel and return the result

When a search request comes in, the server will:

- Asychronously fire search requests to each and every suplliers in the list and store the results to redis

- Without waiting for the first step, it immediately searches on redis for results for the search key and return to the response

Because of this principle, clients need to keep polling the API during the process of the backend sending requests to suppliers to get the most complete and updated hotel prices

Request: POST https://tranquil-refuge-98145.herokuapp.com/hotels/prices

```
{
	"checkin": "30/08/2017",
	"checkout": "01/09/2017",
	"destination": "London",
	"guests": 2,
	"suppliers": []
}
```

Response:

First poll

```
[]
```

Second poll

```
[
  {
      "id": "abcd",
      "price": 299.9,
      "supplier": "supplier2"
  },
  {
      "id": "defg",
      "price": 320.49,
      "supplier": "supplier3"
  },
  {
      "id": "mnop",
      "price": 288.3,
      "supplier": "supplier1"
  }
]
```

