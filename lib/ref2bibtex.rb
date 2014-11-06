recent_ruby = RUBY_VERSION >= '2.1.0'
raise "IMPORTANT:  gem requires ruby >= 2.1.0" unless recent_ruby

require "ref2bibtex/version"
require 'json'
require 'net/http'

module Ref2bibtex

  CROSSREF_URI = URI('http://search.crossref.org/links')

  # Parse the response into json
  def self.parse_json(string)
    begin
      @json = JSON.parse(string) 
    rescue JSON::ParserError => e
      puts e.message
      ap request
    end
  end

  # Pass a String doi get a bibtex formatted string back 
  def self.get_bibtex(doi)
    return false if !doi
    uri = URI(doi)
    return false if uri.class == URI::Generic
    response = Ref2bibtex.request(uri, headers: {'Accept' => 'application/x-bibtex' }, protocol: 'GET', process_response_as: 'text') 
  end

  # Pass a String citation, get a doi back
  def self.get_doi(citation)
    if citation.class == String
      citation = [citation]
    elsif citation.class != Array
      raise
    end
    
    response = Ref2bibtex.request(payload: citation) 
    if response['results'][0]['match']
      response['results'].first['doi']
    else
      false
    end
  end

  # Pass a citation, get a String in bibtex back
  def self.citation2bibtex(citation)
    get_bibtex( get_doi(citation) )
  end

  class << self
    alias_method :get, :citation2bibtex
  end

  def self.request(url = CROSSREF_URI, payload: nil, headers: {'content-type' => 'application/json' }, protocol: 'POST', process_response_as: 'json', redirect_limit: 10)
    raise 'Infinite redirect?' if redirect_limit == 0
    data = nil
    if protocol == 'POST'
      if payload.nil?
        payload = {}
      end
      data = JSON.generate(payload) # Json.new(payload) # utf-8 encoding?
    else
      data = nil
    end

    if protocol == 'POST'
      request = Net::HTTP::Post.new(url, initheader = headers) 
    elsif protocol == 'GET'
      request = Net::HTTP::Get.new(url, initheader = headers) 
    end

    response = Net::HTTP.start(request.uri.hostname, request.uri.port) do |http|
      request.body = data 
      http.request(request)
    end

    case response
    when Net::HTTPSuccess then
      response = response
    when Net::HTTPRedirection then
      url = URI(response['location'])
      request = Net::HTTP::Get.new(url, initheader = {'Accept' => 'application/x-bibtex'}) 
      response = Net::HTTP.start(request.uri.hostname, request.uri.port) do |http|
        http.request(request) 
      end
    else
      response = response.value
    end

    case process_response_as
    when 'text' 
      response.body
    when 'json'
      parse_json(response.body)
    else
      raise
    end
  end

end
