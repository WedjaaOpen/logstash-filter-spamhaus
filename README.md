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

