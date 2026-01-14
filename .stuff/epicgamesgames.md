```js
// JavaScript snippet to fetch all purchased games from Epic Games Store order history
// do this in the browser console (F12) while logged into your Epic Games account
(async () => {
  let allOrders = [];
  let nextToken = "";
  const baseUrl =
    "https://www.epicgames.com/account/v2/payment/ajaxGetOrderHistory?count=10&sortDir=DESC&sortBy=DATE&locale=en-US";

  do {
    const url = nextToken ? `${baseUrl}&nextPageToken=${nextToken}` : baseUrl;
    const res = await fetch(url);
    const data = await res.json();

    allOrders.push(...data.orders);
    nextToken = data.nextPageToken;
    console.log(`Fetched ${allOrders.length} orders...`);
  } while (nextToken);

  // Extract game titles from the saved orders
  const gameTitles = [
    ...new Set(allOrders.flatMap((o) => o.items.map((i) => i.description))),
  ].sort();

  console.log("Full Order History Objects:", allOrders);
  console.log("Unique Games List:", gameTitles);
  console.log(gameTitles.join("\n"));
})();
```
