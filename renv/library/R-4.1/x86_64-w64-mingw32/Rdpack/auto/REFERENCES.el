(TeX-add-style-hook
 "REFERENCES"
 (lambda ()
   (LaTeX-add-bibitems
    "Rpack:bibtex"
    "Rpackage:rbibutils"
    "parseRd"
    "Rdevtools"
    "dummyArticle"))
 :bibtex)

