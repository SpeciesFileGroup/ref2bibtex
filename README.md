[![Build Status](https://travis-ci.org/SpeciesFileGroup/ref2bibtex.svg?branch=master)](https://travis-ci.org/SpeciesFileGroup/ref2bibtex)
[![Dependency Status](https://gemnasium.com/badges/github.com/SpeciesFileGroup/ref2bibtex.svg)](https://gemnasium.com/github.com/SpeciesFileGroup/ref2bibtex)

# ref2bibtex

An (almost) single purpose gem wrapping Crossref's API.  Pass it a full reference string, get back BibTeX.  Pass it a DOI, get BibTeX.  Want something more complex? See [serrano](https://github.com/sckott/serrano).

# usage

Be polite (https://github.com/CrossRef/rest-api-doc#etiquette).  Provide a email as per CrossRef recommendations. Do this by:

1) Add it to the file ~/.ref2bibtex_user_email.

2) Add it to the file .env in the root of your application:

REF2BIBTEX_USER_EMAIL=user@example.com

3) Set REF2BIBTEX_USER_EMAIL in your shell profile.

If the email is set in multiple places priority is reverse order listed here.

Use citation2bibtex (aliased _get_):

```ruby

 gem install ref2bibtex

 require 'ref2bibtex' 

 Ref2bibtex.get('Yoder, M. J., A. A. Valerio, A. Polaszek, L. Masner, and N. F. Johnson. 2009. Revision of Scelio pulchripennis - group species (Hymenoptera, Platygastroidea, Platygastridae). ZooKeys 20:53-118.') # => "@article{Yoder_2009,\n\tdoi = {10.3897/zookeys.20.205},\n\turl = {http://dx.doi.org/10.3897/zookeys.20.205},\n\tyear = 2009,\n\tmonth = {sep},\n\tpublisher = {Pensoft Publishers},\n\tvolume = {20},\n\tnumber = {0},\n\tauthor = {Matthew Yoder and Andrew Polaszek and Lubomir Masner and Norman Johnson and Alejandro Valerio},\n\ttitle = {Revision of Scelio pulchripennis - group species (Hymenoptera, Platygastroidea, Platygastridae)},\n\tjournal = {{ZOOKEYS}}\n}"

```

If you want the doi:

```ruby

   Ref2bibtex.get_doi('Yoder, M. J., A. A. Valerio, A. Polaszek, L. Masner, and N. F. Johnson. 2009. Revision of Scelio pulchripennis - group species (Hymenoptera, Platygastroidea, Platygastridae). ZooKeys 20:53-118.') #  => "http://dx.doi.org/10.3897/zookeys.20.205" 

```

If you have the doi:

```ruby

 Ref2bibtex.get_bibtex('http://dx.doi.org/10.3897/zookeys.20.205') # => "@article{Yoder_2009,\n\tdoi = {10.3897/zookeys.20.205},\n\turl = {http://dx.doi.org/10.3897/zookeys.20.205},\n\tyear = 2009,\n\tmonth = {sep},\n\tpublisher = {Pensoft Publishers},\n\tvolume = {20},\n\tnumber = {0},\n\tauthor = {Matthew Yoder and Andrew Polaszek and Lubomir Masner and Norman Johnson and Alejandro Valerio},\n\ttitle = {Revision of Scelio pulchripennis - group species (Hymenoptera, Platygastroidea, Platygastridae)},\n\tjournal = {{ZOOKEYS}}\n}" 

```

If you want a score: 

```ruby

  Ref2bibtex.get_score('E. Ven. 1337. Fake articles. Journal Get Scores. Hm:mm') # => 23.688715

```

Uses a cutoff against score, below cutoff returns false, set the cutoff:
```ruby

  Ref2bibtex.cutoff            # => 50 
  Ref2bibtex.cutoff = 10       # => 10
  Ref2bibtex.reset_cutoff      # => 50 

``` 

# faq

## What if there are multiple results?
The code is dumb, it takes the first. You could use the internals to get more results.

# acknowledgements

The Crossref API. Jon Hill, University of York, for his Python version and bringing up the approach.

# license

[NCSA, UI flavor](http://opensource.org/licenses/NCSA)

