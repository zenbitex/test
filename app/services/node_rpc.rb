require 'net/http'
require 'uri'
require 'json'
class NodeRPC

  class JSONRPCError < RuntimeError; end
  class ConnectionRefusedError < StandardError; end

  @node_url_xrp = "http://5.189.142.89:2222" #port index.js 
  @node_url_xlm = "http://94.237.85.20:5555"
  @node_url_eth = "http://94.237.85.20:1111"

  def self.newAddressXRP
    url = "#{@node_url_xrp}/getNewAddress?username=scatterp&password=magic123"
    address = self.node_rpc_request_plain url
  end
  def self.newAddressXLM
    url = "#{@node_url_xlm}/getNewAddress?username=scatterp&password=magic123"
    address = self.node_rpc_request_plain url
  end

  def self.node_rpc_request_plain(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }
    result = res.body
  end

  def self.node_rpc_request_json(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }
    result = JSON.parse(res.body)
  end
end

