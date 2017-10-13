# Matterbridge-heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

This inline buildpack downloads and installs matterbridge, and lets you connect an irc channel to a Mattermost channel.

This is a work in progress. I'd like it to eventually support an arbitrary number of bridges and services, but IRC only is a fine MVP for now.

## About this Fork

Heroku is...

An buildpack is...

An inline buildpack is...

Matterbridge is...

This fork is intended to help EDGI bridge its Slack channels with
Archivers Slack.

* Required envvars:
  * `MATTERBRIDGE_VERSION`. Use a [matterbridge git tag][git-tags].
  * `SLACK_ARCHIVERS_TOKEN`. See [_Slack bot setup_ documentation][bot-setup].
  * `SLACK_EDGI_TOKEN`. See [_Slack bot setup_ documentation][bot-setup].
* Auto-deploys `edgi` branch to our heroku app: `edgi-matterbridge`
* `edgi` branch is protected branch, and changes must go through pull
  request process.
* Edit channel bridge config via [`config/config-heroku-template.toml`](config/config-heroku-template.toml).

   [bot-setup]: https://github.com/42wim/matterbridge/wiki/Slack-bot-setup
   [git-tags]: https://github.com/42wim/matterbridge/tags
