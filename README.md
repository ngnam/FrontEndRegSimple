# RegSimple

## Getting Started
Follow these steps to run the app locally:

1. Clone this repository
1. `cd FrontEndRegSimple`
1. `npm i`
1. Create a `.env` file in the root of the project with the following variables
```bash
  PUBLIC_URL=*******
  PORT=********
  SESSION_SECRET=*******
  SMTP_PORT=*******
  SMTP_HOST=*******
  SMTP_USER=*******
  SMTP_PASS=*******
```

1. To start the node server: `npm run server-dev`
1. To start elm app: `npm run client-dev`
1. To compile the css: `npm run css-dev`

## Build

To build the app ready for deploying to production run `make build` - see `Makefile` for more details.

## Deploy

We've set up Travis and Heroku to deploy the `master` branch of this repo. So when a new commit goes into `master`, Travis will run and deploy to heroku (see `.travis.yml` for config)

## CSS - Tachyons & Postcss

We are using [Tachyons](http://tachyons.io/docs/) for styling (a functional CSS library). There is a small learning curve but once learnt it is really good for mobile first/responsive design and in general keeping consistency.

In `./client/src/css/_variables.css` you'll find that we override the default styles at the bottom of the file using the designs found [here](https://projects.invisionapp.com/d/main#/projects/prototypes/14286087).

Any custom css goes in `_custom.css`.

Using the script `npm run css-build`, the compiled css is output `style.min.css` to the `./client/public` folder. Then its linked to the `./client/public/index.html` file in the `<head>`
