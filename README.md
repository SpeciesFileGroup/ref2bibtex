ref2bibtex
==========

A single purpose gem wrapping Crossref's API.  Pass it a full reference string, get back bibtex.

usage
=====

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

faq
===

What if there are multiple results?
-----------------------------------
The code is dumb, it takes the first.

acknowledgements
================

The Crossref API, and Jon Hill, University of York, for his Python version and bringing up the approach.

license
=======

NCSA, UI flavor. [http://opensource.org/licenses/NCSA]

