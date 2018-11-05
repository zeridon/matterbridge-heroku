# Matterbridge-heroku

This is a fork of [the original
`matterbridge-heroku`](https://github.com/cadecairos/matterbridge-heroku).

It includes [a custom config file][config] specific to one implementation, but this can easily be modified in a new fork.

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
  * `SLACK_<team name>_TOKEN`. See [_Slack bot setup_ documentation][bot-setup].
* Optional envvars:
  * `MATTERBRIDGE_URL`. Use this to download the binary from a custom
    url instead of the tagged release from the official GitHub repo.
    (Setting this makes `MATTERBRIDGE_VERSION` ignored.)
    * With caution, you may want to use the [latest nightly matterbridge
      build](https://bintray.com/42wim/nightly/Matterbridge/_latestVersion)
      while waiting on the next official release.
  * `DEBUG`. Set to "1" to log all message events across bridges.
* Auto-deploys `edgi` branch to our heroku app: `edgi-matterbridge`
* `edgi` branch is protected branch, and changes must go through pull
  request process.
* Edit channel bridge config via [`config/config-heroku-template.toml`][config].

## Setting Matterbridge Configuration

Matterbridge uses Viper, and so each value in the TOML configuration can
be set by envvar.

Basically, here are the rules:

- Each config envvar is prefixed with `MATTERBRIDGE_`.
- Each nested level of config object is separated by an underscore `_`.
- Any dash in a config key is converted to an underscore `_`.

So for example, with this in your TOML config:

```toml
[slack.g0v-tw]
Token="xoxp-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

You could instead set an environment variable for
`MATTERBRIDGE_SLACK_G0V_TW_TOKEN` and leave that key out of in the
configuration file template.

## Related Projects

- [**Matterbridge Config Viewer.**][viewer] Render a Matterbridge config
  file as a simple read-only web app.
- [**Matterbridge Auto-Config.**][autoconfig] Generate a config file
  based on Slack channel naming conventions.

   [bot-setup]: https://github.com/42wim/matterbridge/wiki/Slack-bot-setup
   [git-tags]: https://github.com/42wim/matterbridge/tags
   [config]: config/config-heroku-template.toml
   [viewer]: https://github.com/patcon/matterbridge-heroku-viewer
   [autoconfig]: https://github.com/patcon/matterbridge-autoconfig/
