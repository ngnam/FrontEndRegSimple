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

## Build
Follow these steps to compile the app for production:

1. To compile the node server: `npm run server-build`
1. To build the elm app: `npm run client-build`
