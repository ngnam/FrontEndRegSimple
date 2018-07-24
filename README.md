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
  POSTGRES_CONNECTION_STRING=*********
  CLIENT_APP_BASE_URL=*******
  REGSIMPLE_SEARCH_API=*******
```
1. If you don't have it already download `psql` - https://www.postgresql.org/download/
1. To create the necessary database run `psql` and then enter `create database regsimpledb;`
1. Exit the psql shell
1. To create the necessary tables run `psql -U your_username -d regsimpledb -a -f './server/sql/create-tables.sql'`
1. To start the node server: `npm run server-dev`
1. To start elm app: `npm run client-dev`
1. To compile the css: `npm run css-dev`

## Deploy

We've set up Travis and Heroku to deploy the `master` branch of this repo. So when a new commit goes into `master`, Travis will build and deploy to heroku (see `.travis.yml` for config)

NB. The heroku deploy api token will expire 06/01/2019

## Build

You only need to do this if you want to manually deploy.
To build the app ready for deploying to production run `make build` - see `Makefile` for more details.

## Scripts

### set-user-role

`npm run set-user-role -- --email=example@regsimple.io --role=ROLE_ADMIN --pgConnectionString=postgres://pgUser:pgPass@localhost/regsimpledb`

This role will alter the role of the user with the specified email address.

**Args**

- `email`: *(optional)* Specify a single email address whose user role you wish to alter. They must already be signed up, ie have attempted a log in.
- `role`: *(optional)* Specify a new role for the user of ROLE_USER, ROLE_EDITOR, ROLE_ADMIN.
- `pgConnectionString`: *(optional)*: Specify the connection string to the database where the users table lives. Defaults to PG_CONNECTION_STRING in either NODE_ENV or in ./dev.env file.

**Important:** If neither email nor role are specified, then the script will read the list of user emails from shared/editors.json, and alter all their roles to be ROLE_EDITOR.

## CSS - Tachyons & Postcss

We are using [Tachyons](http://tachyons.io/docs/) for styling (a functional CSS library). There is a small learning curve but once learnt it is really good for mobile first/responsive design and in general keeping consistency.

In `./client/src/css/_variables.css` you'll find that we override the default styles at the bottom of the file using the designs found [here](https://projects.invisionapp.com/d/main#/projects/prototypes/14286087).

Any custom css goes in `_custom.css`.

Using the script `npm run css-build`, the compiled css is output `style.min.css` to the `./client/public` folder. Then its linked to the `./client/public/index.html` file in the `<head>`

## Logs & Monitoring - https://papertrailapp.com/systems/reg-simple/events

We've connected our heroku app to Papertrail for logging. Any errors that get thrown up are posted to the `app` slack channel every hour.
