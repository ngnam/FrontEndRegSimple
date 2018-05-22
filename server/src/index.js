import express from 'express';
import morgan from 'morgan';

const PORT = 4000;

const app = express();

app.use(morgan('combined'));
app.get('/', (req, res) => {
  res.send('Hello World');
});

app.listen(PORT, () => {
  console.log(`Listening at http://localhost:${PORT}`);
});
