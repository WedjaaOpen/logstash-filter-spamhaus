# Logstash SpamHaus Plugin

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Documentation

This filter allows you to lookup an IP address in the SpamHaus ZEN list. This list includes all of the SpamHaus blacklists.

This filter can be used in the simplest form as follows:

```
	spamhaus {}
```

It will run with the following defaults:

 * It will loookup the IP address in the `clientip` field
 * It will tag IPs in the blacklist as `spamhaus_blacklisted`
 * It will tag IPs not in the blacklist as `spamhaus_whitelisted`

If an IP is blacklisted it will add a `spamhaus` object to the event with the following properties:
 * `code`: it's the SpamHaus code for the blocking reason
 * `blocklist`: it's the SpamHaus blacklist name where this IP was found

## Configuration

The filter accepts the following configuration options:

  * `ip` - It's the field that contains the IP address to resolve. *Default: `clientip`*.
  * `tag_blacklisted` - The tag to add to the event in case the IP is blacklisted. *Default: `spamhaus_blacklisted`*.
  * `tag_whitelisted` - The tag to add to the event in case the IP is not in any blacklist. *Default: `spamhaus_whitelisted`*.

A more involved filter configuration could look like:

```
  spamhaus {
    ip => 'client_ip'
    tag_blacklisted => 'blacklisted'
    tag_whitelisted => 'whitelisted'
  }
```

## Missing functionality

This is a bare minimum implementation of the filter. Some things could be good to implement:

  * Lookup multiple IPs
  * Select the blacklists to lookup

## Compiling and testing

Compiling, deploying and testing this plugin requires JRuby. Not only - you want to make sure that the bundle, rake and rspec commands are run using JRuby.

If you start seeing errors that look like:

```
Could not find gem 'logstash-devutils (>= 0.0.18) ruby' in any of the gem sources listed in your Gemfile or available on this machine.
```

*notice the `ruby` bit after the version* - try and make it explicit that you want to use the JRuby versions of the commands:

```
alias rspec="jruby -S rspec"
alias rake="jruby -S rake"
alias bundle="jruby -S bundle"
```

Once you specified these aliases things should start working as expected -- unless you don't have jruby in your path.

Test it our by running `bundle install && bundle exec rspec` - it should produce some output, ending with the test results:

```
Finished in 0.382 seconds (files took 4.03 seconds to load)
2 examples, 0 failures

Randomized with seed xxxxx
```
