;;; biblio.el --- Browse and import bibliographic references from CrossRef, arXiv, DBLP, doi.org etc. -*- lexical-binding: t -*-

;; Copyright (C) 2016  Clément Pit-Claudel

;; Author: Clément Pit-Claudel
;; Version: 0.1
;; Package-Requires: ((emacs "24.3") (biblio-core "0.0") (biblio-doi "0.0") (biblio-arxiv "0.0") (biblio-dblp "0.0") (biblio-crossref "0.0") (biblio-dissemin "0.0"))
;; Keywords: bib, tex, convenience, hypermedia
;; URL: http://github.com/cpitclaudel/biblio.el

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; # `biblio.el': An extensible Emacs package for browsing and fetching references
;;
;; `biblio.el' makes it easy to browse and gather bibliographic references and
;; publications from various sources, by keywords or by DOI.  References are
;; automatically fetched from well-curated sources, and formatted as BibTeX.
;;
;; ## Supported sources:
;;
;; * `CrossRef', an exhaustive academic search engine (recommended)
;; * `arXiv', an archive of pre-prints in various scientific fields
;; * `DBLP', a database of Computer Science publications
;; * `doi.org', a DOI resolver (to retrieve BibTeX records from DOIs)
;; * `CrossCite', an alternative DOI resolver and BibTeX formatting service
;; * `Dissemin', a database tracking the open access status of scholarly articles
;;
;; ## Usage
;;
;; Quick start: `M-x biblio-lookup'.  Each source can also be accessed independently:
;;
;; * `M-x crossref-lookup' to query CrossRef
;; * `M-x arxiv-lookup` to query arXiv
;; * `M-x dblp-lookup' to query DBLP
;; * `M-x doi-insert' to insert a BibTeX record by DOI
;; * `M-x dissemin-lookup' to show information about the open access status of a
;;   particular DOI
;;
;; Most of these commands work together: for example, `crossref-lookup' displays a
;; list of results in `biblio-selection-mode'.  In that mode, use:
;;
;; * `RET' to visit the corresponding web page
;; * `c' or `M-w' to copy the BibTeX record of the current entry
;; * `i' or `C-y' to insert the BibTeX record of the current entry
;; * `x' to run an extended action, such as fetching a Dissemin record
;;
;; `C' and `I' do the same as `c' and `i', but additionally close the search window.
;;
;; ## Examples
;;
;; * To insert a clean BibTeX entry for http://doi.org/10.1145/2676726.2677006
;;   in the current buffer, use
;;
;;         M-x crossref-lookup RET fiat deductive delaware RET i
;;
;;   (the last `i' inserts the BibTeX record of the currently selected entry in
;;    your buffer).
;;
;; * To find publications by computer scientist Leslie Lamport, use `M-x
;;   dblp-lookup RET author:Lamport RET' (see more info about DBLP's syntax at
;;   <http://dblp.uni-trier.de/search/>)
;;
;; * To check whether an article is available online for example Stallman's paper
;;   on EMACS, use `x' in the list of results.  This only works with CrossRef at the
;;   moment.  For example: `M-x crossref-lookup RET Emacs stallman RET', then press
;;   `o Dissemin RET'.
;;
;; See http://github.com/cpitclaudel/biblio.el for more information, including
;; documentation on extending this framework.

;;; Code:

(require 'biblio-core)
(require 'biblio-doi)
(require 'biblio-arxiv)
(require 'biblio-crossref)
(require 'biblio-dblp)
(require 'biblio-dissemin)

(provide 'biblio)
;;; biblio.el ends here
