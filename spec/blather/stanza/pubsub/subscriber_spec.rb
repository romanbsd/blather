require File.join(File.dirname(__FILE__), *%w[.. .. .. spec_helper])
require File.join(File.dirname(__FILE__), *%w[.. .. .. fixtures pubsub])

module Blather
  describe 'Blather::Stanza::PubSub::Subscriber' do
    it 'can request a subscription' do
      sub = Blather::Stanza::PubSub.subscribe 'host.name', 'node_name', 'j@i.d'
      sub.to.must_equal JID.new('host.name')
      sub.set?.must_equal true
      sub.find('//ns:pubsub/ns:subscription[@node="node_name" and @jid="j@i.d"]', :ns => Stanza::PubSub.registered_ns).wont_be_empty
    end

    it 'can request an unsubscribe' do
      sub = Blather::Stanza::PubSub.unsubscribe 'host.name', 'node_name', 'j@i.d'
      sub.to.must_equal JID.new('host.name')
      sub.set?.must_equal true
      sub.find_first('//ns:pubsub/ns:unsubscribe[@node="node_name" and @jid="j@i.d"]', :ns => Stanza::PubSub.registered_ns).wont_be_nil
    end
  
    it 'can request an unsubscribe with a subscription id' do
      sub = Blather::Stanza::PubSub.unsubscribe 'host.name', 'node_name', 'j@i.d', 'subid'
      sub.to.must_equal JID.new('host.name')
      sub.set?.must_equal true
      sub.find_first('//ns:pubsub/ns:unsubscribe[@node="node_name" and @jid="j@i.d" and @subid="subid"]', :ns => Stanza::PubSub.registered_ns).wont_be_nil
    end

    it 'knows if it is a subscription' do
      stanza = Blather::Stanza::PubSub.import(parse_stanza(subscriber_xml).root)
      stanza.subscription?.wont_be_nil
    end

    it 'knows if it is not a subscription' do
      stanza = Blather::Stanza::PubSub.import(parse_stanza(unsubscribe_xml).root)
      stanza.subscription?.must_be_nil
    end

    it 'knows the values of a subscription' do
      stanza = Blather::Stanza::PubSub.import(parse_stanza(subscriber_xml).root)
      stanza.subscription.must_equal({
        :node         => 'princely_musings',
        :jid          => JID.new('francisco@denmark.lit'),
        :subid        => 'ba49252aaa4f5d320c24d3766f0bdcade78c78d3',
        :subscription => 'subscribed'
      })
    end

    it 'knows if it is an unsubscribe' do
      stanza = Blather::Stanza::PubSub.import(parse_stanza(unsubscribe_xml).root)
      stanza.unsubscribe?.wont_be_nil
    end

    it 'knows if it is not a unsubscribe' do
      stanza = Blather::Stanza::PubSub.import(parse_stanza(subscriber_xml).root)
      stanza.unsubscribe?.must_be_nil
    end

    it 'knows the values of the unsubscribe' do
      node = parse_stanza(unsubscribe_xml).root
      stanza = Blather::Stanza::PubSub.import node
      stanza.unsubscribe.must_equal({
        :node => 'princely_musings',
        :jid  => JID.new('francisco@denmark.lit')
      })
    end
  end
end