# Jellybean

## Summary
- The rails backend follows the typical MVC framework. The downside to this is that the controller is fairly heavy. It would be cleaner to separate the external API logic like OpenAI inside another class.
- The react code is pretty minimal, again its primarily focused in a single component. One key part that can be pulled out of the component is the network request. The styling is pretty minimal, bootstrap classes handle most if not all of the styling.
- The database schema is barebones, only storing what actually gets used. 

## Improvements
- The main bottlenck in the POST request is parsing the CSV file on every request. Specifically, the `JSON.parse` call is holding up the entire request because its called iteratively. An improvement is storing the CSV data in memory using Redis or any other KV store.
- The question input needs to becleansed before storing into the database. This is a basic SQL injection attack waiting to happen.
- The database query can be improved in a few ways. The query can be shortened/compressed, since currently the entire question is being searched. Alternatively, an indexed can be added for the question column. A combination of both would yield even better results.
- The frontend can be improved with better styling and a loading spinner.
- If this were to become more like a chatbot, websockets can be used to instead of the typical request/response model for lower latencies 
