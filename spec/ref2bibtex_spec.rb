require 'spec_helper'

describe Ref2bibtex do


  specify '#Ref2bibtex.request makes a request' do

    expect(Ref2bibtex.request(payload: [CITATIONS[:first]]).first[1][0]['match']).to eq(true)
  end

end 
