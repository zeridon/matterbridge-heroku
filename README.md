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

## Configuration: g0v

As a summary, [this repo's configuration][config] does some specific things
for the g0v chat ecosystem:

- The IRC-Slack bridge ability that was provided by
  [`g0v/slack-irc-plugin`][slack-irc-plugin] in the past, is now
provided by this service.
tool, using [these][config1] [parts][config2] of config. Some notes:
  - The NickServ username and password are set via envvar on Heroku.
  - Matterbridge doesn't yet support spoofing of nicknames for incoming
    messages like the `slack-irc-plugin` seems to already allow, but
there is an issue for implementing spoofing [`#667`][spoof-issue].

   [slack-irc-plugin]: https://github.com/g0v/slack-irc-plugin
   [config1]: https://github.com/patcon/matterbridge-heroku/blob/0a1191c9bd0c4525e45ca47bcec8ff71beddebe2/config/config-heroku-template.toml#L39-L46
   [config2]: https://github.com/patcon/matterbridge-heroku/blob/master/config/config-heroku-template.toml#L150-L152
   [spoof-issue]: https://github.com/42wim/matterbridge/issues/667

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

## Using API Endpoints

Matterbridge uses API endpoints for some things, like the API bridge and
webhooks. In order to bind to a port and serve HTTP pages, the app must
be run as a "web" dyno. If there is no need for HTTP endpoints (ie. no
API nor incoming webhook access) then the app can be run as a "worker"
dyno. The catch of using a web dyno is that it will fall asleep after 30
minutes of no incoming requests. This is bad if we're depending on this
bridge to be running all the time.

To get around this, we can enable Heroku's "scheduler" add-on service.
It is essentially like cron. We will set it up to hit our own app every
10 minutes, therefore keeping it from sleeping. If you have the [Heroku
CLI][heroku-cli] installed, you can enable this like so, from your
project repo:

   [heroku-cli]: https://devcenter.heroku.com/articles/heroku-cli

```
heroku addons:create scheduler
heroku addons:open scheduler
```

If you don't have Heroku CLI, you will need to configure this manually
from the Heroku website.

Now, using the web interface, create a task to run this command every 10
minutes:

```
curl --silent --head https://MY-APP-NAME.herokuapp.com/api/ping > /dev/null
```

Now that you're ready to keep the app awake, just switch over from using
the "worker" dyno to using the "web" dyno. (Both are defined in the
`Procfile`.)

```
# Via Heroku CLI:
heroku ps:scale worker=0 web=1
# Without Heroku CLI, do it from the Heroku web interface
```


Ok, now you're all set to go! But **be WARNED**, Heroku only gives out
enough free hours to allow a single app to run continuously like this.
If you have any other apps running, this will make you run over, and
charges will likely result. But perhaps most importantly, **all your
other apps will immediately stop working**. Paying $7/month for a hobby
dyno will allow for a "web" dyno that never sleeps, and so this
work-around won't be required.

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
