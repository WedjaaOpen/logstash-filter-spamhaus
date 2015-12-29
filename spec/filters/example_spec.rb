# encoding: utf-8
require 'spec_helper'
require "logstash/filters/spamhaus"

describe LogStash::Filters::SpamHaus do
  describe "Spamhaus should fail on local addresses" do
    let(:config) do <<-CONFIG
      filter {
        spamhaus {
          ip => "client_ip"
        }
      }
    CONFIG
    end

    sample('client_ip' => '192.168.66.1' ) do
        expect(subject).to include("client_ip")
        expect(subject['client_ip']).to eq('192.168.66.1')
	expect(subject).to include("tags")
	expect(subject['tags']).to include('spamhaus_whitelisted')
    end
  end

  describe "Spamhaus should report 185.106.92.33 as blacklisted" do
    let(:config) do <<-CONFIG
      filter {
        spamhaus {
          ip => "client_ip"
        }
      }
    CONFIG
    end

    sample('client_ip' => '185.106.92.33' ) do
        expect(subject).to include("client_ip")
        expect(subject['client_ip']).to eq('185.106.92.33')
	expect(subject).to include('spamhaus')
	expect(subject['spamhaus']).to include('code')
	expect(subject['spamhaus']['code']).to eq(4)
	expect(subject['spamhaus']).to include('blocklist')
	expect(subject['spamhaus']['blocklist']).to eq('Exploits Block List')
	expect(subject).to include("tags")
	expect(subject['tags']).to include('spamhaus_blacklisted')
    end
  end

end
