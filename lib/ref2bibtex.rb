
recent_ruby = RUBY_VERSION >= '2.1.0'
raise "IMPORTANT:  gem requires ruby >= 2.1.0" unless recent_ruby

require "ref2bibtex/version"
require 'json'
require 'net/http'

module Ref2bibtex

  CROSSREF_URI = URI('http://search.crossref.org/links')



  # Parse the json, and store it in @json.
  def self.parse_json(string)
    begin
      @json = JSON.parse(string) 
    rescue JSON::ParserError => e
      puts e.message
      ap request
    end
  end



 #def new_post_to_crossref
 #  Net::HTTP::Post.new(CROSSREF_URI, initheader = {'Content-Type' =>'application/json'})
 #end

 #def translate(citation)
 #  req = new_post_to_crossref

 #  res = Net::HTTP.start(request.uri.hostname, request.uri.port) do |http|
 #    req.body = request.json_payload
 #    http.request(req)
 #  end
 #end

 #def get_doi_from_crossref(citation)
 #  citations = [citation]
 #  payload = citations
 #  res = Net::HTTP.start(request.uri.hostname, request.uri.port) do |http|
 #    req.body = request.json_payload
 #    http.request(req)
 #  end
 #  res
 #end

  def self.request(url = CROSSREF_URI, payload: nil, headers: {'content-type' => 'application/json' }, protocol: 'POST', process_response_as: 'json')
    data = nil
    if protocol == 'POST'
      if payload.nil?
        payload = {}
      end
      data = JSON.generate(payload) # Json.new(payload) # utf-8 encoding?
    else
      data = nil
    end

    case protocol
    when 'POST'
      request = Net::HTTP::Post.new(url, initheader = headers) 
    when 'GET' 
      request = Net::HTTP::Get.new(url)
    else
      raise "Protocol #{protocol} not handled."
    end

    response = Net::HTTP.start(request.uri.hostname, request.uri.port) do |http|
      request.body = data 
      http.request(request)
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
  # Your code goes here...

# def scrub(value):
#    """
#   Clean up the incoming queries to remove unfriendly
#   characters that may come from copy and pasted citations.

#   Also remove all punctuation from text.
#   
#   """
#   from curses import ascii
#   import string

#   punctuation = set(string.punctuation)
#   if not value:
#       return
#   n = ''.join([c for c in value.strip() if not ascii.isctrl(c)])
#   #Strip newline or \f characters.
#   n2 = n.replace('\n', '').replace('\f', '')
#   cleaned = ''.join(ch for ch in n2 if ch not in punctuation)
#   return cleaned

#ef fetch_doi_from_crossref(citation):
#   import urllib2
#   import requests
#   import json
#   url = 'http://search.crossref.org/links'
#   #Scrub the citation query.
#   cleaned = scrub(citation)
#   #Turn query into a list because the API is expecting a list.
#   citations = [cleaned]
#   payload = citations
#   citation_data = request(url,payload,headers={'Content-Type': 'application/json'})
#   if len(citation_data['results']) == 0:
#       bibtex = ""
#   else:
#       #Lookup the DOIs and get metadata for the located citations.
#       item = citation_data['results'][0] # get first hit
#       doi = item.get('doi')
#       if doi == None:
#           bibtex = ""
#       else:
#           bibtex = request(doi,payload,headers={'Accept': 'application/x-bibtex'},process_response_as='text')
#   return bibtex

#ef request(url,payload=None,headers=None,protocol="POST",process_response_as="json"):
#   import json
#   from urllib2 import Request
#   from urllib2 import urlopen
#   from urllib import urlencode
#   
#   if headers is None:
#       headers = {'content-type': 'application/json'}
#   if protocol == "POST":
#       if payload is None:
#           payload = {}
#       data = json.dumps(payload).encode("utf-8")
#   else:
#       data = None
#   request = Request(
#           url=url,
#           data=data,
#           headers=headers)
#   response = urlopen(request)
#   response_contents = response.read()
#   if process_response_as == "json":
#       response_contents = json.loads(response_contents)
#   elif process_response_as == "text":
#       pass
#   else:
#       raise ValueError("Response type '{}' is not supported".format(process_response_as))
#   return response_contents






end
