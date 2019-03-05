require 'spec_helper'

describe Ref2bibtex do

  context '.request' do
    let(:request) { Ref2bibtex.request(payload: [CITATIONS[:first]]) }

    specify 'makes a query_ok request' do
      expect(request['query_ok']).to eq(true)
    end

    specify 'returns Hash' do
      expect(request.class).to eq(Hash)
    end

    specify 'results is an Array' do
      expect(request['results'].class).to eq(Array)
    end

    specify 'results is an Array of Hashes' do
      expect(request['results'].first.class).to eq(Hash)
    end

    specify 'results is an Array of Hashes, each one having a doi' do
      expect(request['results'].first['doi']).to be_truthy 
    end
  end

  context '.get_doi' do
    specify 'takes a full citation and returns a string' do
      expect(Ref2bibtex.get_doi(CITATIONS[:first])).to eq('https://doi.org/10.3897/zookeys.20.205')
    end

    specify 'a citation that can not be resolved returns false' do
      expect(Ref2bibtex.get_doi(CITATIONS[:eighth])).to eq(false)
    end

    specify 'a badly formed DOI returns false' do
      expect(Ref2bibtex.get_doi('asfas')).to eq(false)
    end
  end

  context '.get_bibtex' do  
    let(:response) { Ref2bibtex.get_bibtex('https://dx.doi.org/10.3897/zookeys.20.205')}
    specify 'takes a full citation and returns bibtex' do
      expect(response).to match(/author\s=/)
      expect(response).to match(/title\s=/)
      expect(response).to match(/year\s=\s2009/)
    end

    specify 'a bad doi returns false' do
      expect(Ref2bibtex.get_bibtex('asfasf')).to eq(false)
    end

    context 'random DOIs from the wild' do
      specify '#1' do
        expect(Ref2bibtex.get_bibtex('https://doi.org/10.1649/0010-065X(2001)055[0363:HHPANS]2.0.CO;2')).to be_truthy 
      end
    end
  end

  specify "a citation that can not be resolved returns false from .get" do
    expect(Ref2bibtex.get(CITATIONS[:eighth])).to eq(false)
  end

  context 'score' do
    specify 'can be returned with .get_score' do
      expect(Ref2bibtex.get_score(CITATIONS[:first])).to be > 0
    end

    context 'interpretation' do
      before(:all) {
        @scores =  CITATIONS.keys.inject({}) { |hsh, c|
          sleep 0.5 # throttle timing a little 
          hsh.merge!(
            c => Ref2bibtex.get_score(CITATIONS[c])
          )
        }
        @scores
      }

      specify 'mangled text is worse than good text' do
        expect( @scores[:second] > @scores[:seventh] ).to be_truthy
      end

      context 'default @@cutoff is reasonable and slightly conservative' do
        let(:good_citations) { [:first, :second, :third] } # remainders have moved to unresolvable
        let(:bad_citations) { CITATIONS.keys - good_citations }

        specify 'for good citations' do
          good_citations.each do |c|
            expect(@scores[c]).to be > Ref2bibtex.cutoff
          end
        end

        specify 'for bad citations' do
          bad_citations.each do |c|
            if @scores[c]

              expect(@scores[c]).to be < Ref2bibtex.cutoff
            end
          end
        end
      end
    end

    context 'cutoff' do
      after(:all) {
        Ref2bibtex.reset_cutoff
      }

      specify 'can be used to reject good matches' do
        Ref2bibtex.cutoff = 1000
        expect(Ref2bibtex.get_doi(CITATIONS[:first])).to eq(false)
      end 

      # Cutoff is more finely tuned to exclude bad matches now. 
      xspecify 'can be used to accept bad matches' do
        Ref2bibtex.cutoff = 1 
        expect(Ref2bibtex.get_doi(CITATIONS[:fifth])).to be_truthy
      end 

    end

  end
end 
