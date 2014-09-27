require 'spec_helper'

describe Ref2bibtex do

  context '#request' do
    let(:request) { Ref2bibtex.request(payload: [CITATIONS[:first]]) }

    specify '#Ref2bibtex.request makes a query_ok request' do
      expect(request['query_ok']).to eq(true)
    end

    specify '#Ref2bibtex.request returns Hash' do
      expect(request.class).to eq(Hash)
    end

    specify '#Ref2bibtex.request results is an Array' do
      expect(request['results'].class).to eq(Array)
    end

    specify '#Ref2bibtex.request results is an Array of Hashes' do
      expect(request['results'].first.class).to eq(Hash)
    end

    specify '#Ref2bibtex.request results is an Array of Hashes, each one having a doi' do
      expect(request['results'].first['doi']).to be_truthy 
    end
  end

  context '#get_doi' do
    specify 'Ref2bibtex.get_doi() takes a full citation and returns a string' do
      expect(Ref2bibtex.get_doi(CITATIONS[:first])).to eq('http://dx.doi.org/10.3897/zookeys.20.205')
    end
  end

  context '#get_bibtex' do
    let(:response) { Ref2bibtex.get_bibtex('http://dx.doi.org/10.3897/zookeys.20.205')}
    specify 'Ref2bibtex.get_bibtex() takes a full citation and returns bibtex' do
      expect(response).to match(/author\s=/)
      expect(response).to match(/title\s=/)
      expect(response).to match(/year\s=\s2009/)
    end
  end


end 
