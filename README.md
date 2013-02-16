# Web API of database connector

Through this API, you can perform a query on the database.  
When you send a query, it will authenticate with Basic Authentication.  
The response is returned by XML or JSON.  


## How To

1. gem bundle (first time, to install the dependencies)
2. Edit conf/config.yaml (first time, describe the authentication information and the database to connect to)
3. Access the endpoint (as an end point, is provided /dbc.xml and /dbc.json)

Use the GET method when you access the endpoint.
Write query in a GET parameter.
The parameter name is 'query'.
