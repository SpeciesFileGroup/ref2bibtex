recent_ruby = RUBY_VERSION >= '2.1.0'
raise "IMPORTANT:  gem requires ruby >= 2.1.0" unless recent_ruby

require "ref2bibtex/version"
require 'json'
require 'net/http'

module Ref2bibtex

  # By default sorts by score
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
  def self.get_doi(citation, cuttoff: 50)
    citation = validate_query(citation)
    response = Ref2bibtex.request(payload: citation) 

    return false if !response['results'][0]['match']
    response['results'][0]['doi']
  end

  def self.get_score(citation)
    citation = validate_query(citation)
    response = Ref2bibtex.request(payload: citation) 
    return false if !response['results'][0]['match']
    response['results'][0]['score']
  end

  def self.validate_query(citation)
    return [citation] if citation.kind_of?(String) && citation.length > 0
    raise 'citation is not String or Array' if !citation.kind_of?(Array) 
    raise 'citation in array is empty' if citation.empty? || citation.select{|a| a.length == 0}.size > 0
    citation
  end

  # Pass a citation, get a String in bibtex back
  def self.citation2bibtex(citation)
    get_bibtex(get_doi(citation) )
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

    response = Net::HTTP.start(request.uri.hostname, request.uri.port, use_ssl: request.uri.scheme == 'https') do |http|
      request.body = data 
      http.request(request)
    end

    case response
    when Net::HTTPSuccess 
      response = response
    when Net::HTTPRedirection 

      url = URI(response['location'])
      request = Net::HTTP::Get.new(url, initheader = {'Accept' => 'application/x-bibtex'}) 

      response = Net::HTTP.start(request.uri.hostname, request.uri.port, use_ssl: request.uri.scheme == 'https') do |http|
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
      raise 'response process type not provided'
    end

  end

end
