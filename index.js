const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({ message: 'Hello from Node.Js Microservice!' });
});

app.listen(port, () => {
  console.log('Microservice running on port ${port}');
});
