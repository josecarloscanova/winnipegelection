## WinnipegElection.ca

WinnipegElection.ca is a citizen driven website originally created for the 2010 Winnipeg general election.

This site was created by [Open Democracy Manitoba](http://opendemocracymanitoba.ca/). Our mission is to empower voters, helping them learn about the roles, issues, and visions of our representatives in order have a more accountable and respectful democracy.

The website is powered by:

* Ruby on Rails
* PostgreSQL
* Apache with Phushion Passenger
* Google News

WinnipegElection.ca features interactive ward maps, ward statistics, historical information about past elections, and a calendar of election related events. Candidates are listed along with links to their web pages, email addresses, Facebook fan pages and Twitter feeds. News articles that mention candidates are also linked providing up to date information from a variety of media sources.

## Deployment Instructions

Start by cloning this repository into your `/var/www/` folder:

    git clone 

Create a `config/secrets.yml` file structured as follows:

    development:
      secret_key_base: {secret}
      json_api_token: {secret}

    test:
      secret_key_base: {secret}
      json_api_token: {secret}

    production:
      secret_key_base: {secret}
      devise_secret_key: {secret}
      json_api_token: {secret}

In the place of each `{secret}` place a unique secret generated by `rake secret`.

Create a tmp folder in your project root:

    mkdir tmp

Run the project migrations, ensuring first that you have configured your `config/database.yml` file:

    bundle exec rake db:migrate

If you're deploying to production the migration command is:

    RAILS_ENV=production bundle exec rake db:migrate

Also for production you will need to precompile the assets:

    RAILS_ENV=production bundle exec rake assets:precompile

## License

This is **free and unencumbered** software released into the public domain.  See UNLICENSE for details.
