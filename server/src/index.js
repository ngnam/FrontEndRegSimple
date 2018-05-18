import express from 'express';

const PORT = 4000;

const app = express();

app.get('/', (req, res) => {
  res.send('Hello World');
});

app.listen(PORT, () => {
  console.log(`Listening at http://localhost:${PORT}`);
});
