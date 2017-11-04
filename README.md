# Matterbridge-heroku

This is a fork of [the original
`matterbridge-heroku`](https://github.com/cadecairos/matterbridge-heroku).

## About this Fork

[**Heroku**](https://www.heroku.com/what) is a platform for easily deploying
applications.

A [**buildpack**](https://docs.cloudfoundry.org/buildpacks/) provides
framework and runtime support for apps running on platforms like Heroku.

An [**_inline_ buildpack**](https://github.com/kr/heroku-buildpack-inline#readme) is a special buildpack that includes code for both the app and the
buildpack that _runs_ the app.

[**Matterbridge**](https://github.com/42wim/matterbridge#readme) is a
simple _bridge_ that can relay messages between a number of different
chat services, essentially connecting separate chat tools.

This fork is intended to help bridge channels between both the EDGI and
Archivers Slack teams.

* Required envvars:
  * `MATTERBRIDGE_VERSION`. Use a [matterbridge git tag][git-tags].
  * `SLACK_ARCHIVERS_TOKEN`. See [_Slack bot setup_ documentation][bot-setup].
  * `SLACK_EDGI_TOKEN`. See [_Slack bot setup_ documentation][bot-setup].
* Optional envvars:
  * `MATTERBRIDGE_URL`. Use this to download the binary from a custom
    url instead of the tagged release from the official GitHub repo.
    (Setting this makes `MATTERBRIDGE_VERSION` ignored.)
* Auto-deploys `edgi` branch to our heroku app: `edgi-matterbridge`
* `edgi` branch is protected branch, and changes must go through pull
  request process.
* Edit channel bridge config via [`config/config-heroku-template.toml`](config/config-heroku-template.toml).

   [bot-setup]: https://github.com/42wim/matterbridge/wiki/Slack-bot-setup
   [git-tags]: https://github.com/42wim/matterbridge/tags
