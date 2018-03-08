recent_ruby = RUBY_VERSION >= '2.1.0'
raise "IMPORTANT:  gem requires ruby >= 2.1.0" unless recent_ruby

require "ref2bibtex/version"
require 'json'
require 'net/http'

module Ref2bibtex

  USER_EMAIL_FILE_PATH = File.expand_path("#{ENV['HOME']}/.ref2bibtex_user_email")
  key = nil
  key = File.read(USER_EMAIL_FILE_PATH).strip if File.exists?(USER_EMAIL_FILE_PATH)
  USER_EMAIL_FILE = key 
  USER_EMAIL_ENV = ENV['REF2BIBTEX_USER_EMAIL'] 

  USER_EMAIL = USER_EMAIL_FILE || USER_EMAIL_ENV || nil

  warn "\n\n !! User email not set in ~/.ref2bibtex_user_email, .env, or ENV, you're not being a polite user! (https://github.com/CrossRef/rest-api-doc)!! \n\n" if USER_EMAIL.nil? || USER_EMAIL == 'https%3A%2F%2Fgithub.com%2FSpeciesFileGroup%2Fref2bibtex'

  # By default sorts by score
  CROSSREF_URI = URI("https://search.crossref.org/links?mailto=#{USER_EMAIL}")

  DEFAULT_CUTOFF = 50

  @@cutoff = DEFAULT_CUTOFF

  def self.cutoff
    @@cutoff
  end

  def self.cutoff=(value)
    @@cutoff = value
  end

  def self.reset_cutoff
    @@cutoff = DEFAULT_CUTOFF
  end

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
 
  # Pass a String citation, get a DOI back
  def self.get_doi(citation)
    citation = validate_query(citation)
    response = Ref2bibtex.request(payload: citation) 

    return false if !response['results'][0]['match']
    return false if response['results'][0]['score'] < @@cutoff

    response['results'][0]['doi']
  end

  # Pass a String citation, get a score back
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

  # Pass a citation, get a String in BibTeX back
  def self.citation2bibtex(citation)
    get_bibtex(get_doi(citation) )
  end

  class << self
    alias_method :get, :citation2bibtex
  end

  def self.request(url = CROSSREF_URI, payload: nil, headers: {'content-type' => 'application/json' }, protocol: 'POST', process_response_as: 'json', redirect_limit: 10)
    raise 'Infinite redirect?' if redirect_limit == 0

    body = request_body(protocol, payload)
    request = new_request(protocol, url, headers)

    response = Net::HTTP.start(request.uri.hostname, request.uri.port, use_ssl: request.uri.scheme == 'https') do |http|
      request.body = body 
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

     process_response(response, process_response_as)
  end

  protected

  def self.interpret_response(response)
  end

  def self.request_body(protocol, payload)
    if protocol == 'POST'
      payload = {} if payload.nil?
      JSON.generate(payload) # Json.new(payload) # utf-8 encoding?
    else
      nil
    end
  end

  def self.new_request(protocol, url, headers)
    case protocol
    when 'POST'
      Net::HTTP::Post.new(url, initheader = headers) 
    when 'GET'
      Net::HTTP::Get.new(url, initheader = headers) 
    else
      raise 'invalid protocol'
    end
  end

  def self.process_response(response, as)
    case as
    when 'text' 
      response.body
    when 'json'
      parse_json(response.body)
    else
      raise 'response process type not provided'
    end
  end

end
