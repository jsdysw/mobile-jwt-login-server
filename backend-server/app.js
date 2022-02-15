const express = require('express');
const morgan = require('morgan');
const dotenv = require('dotenv');
const authRouter = require('./routes/auth');

const { verifyToken } = require('./routes/middlewares');

dotenv.config();

const { sequelize } = require('./models');

const app = express();
app.set('port', process.env.PORT || 3000);
sequelize.sync({ force: false })
  .then(() => {
    console.log('database connection succeed');
  })
  .catch((err) => {
    console.error(err);
  });



app.use(morgan('dev'));
app.use(express.json());

app.use('/', authRouter);

// app.get('/test' , (req, res) => {
//   return res.json("hi");
// });


app.get('/test', verifyToken , (req, res) => {
  return res.json(req.decoded.email);
});

app.use((req, res, next) => {
  const error =  new Error(`${req.method} ${req.url} router doesn't exist`);
  error.status = 404;
  next(error);
});

app.use((err, req, res, next) => {
  res.json({
    status: err.status || 500,
    message: err.message
 });
});

app.listen(app.get('port'), () => {
  console.log(app.get('port'), 'waiting');
});

