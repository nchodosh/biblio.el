;;; biblio-dblp.el --- Lookup and import bibliographic entries from DBLP -*- lexical-binding: t -*-

;; Copyright (C) 2016  Clément Pit-Claudel

;; Author: Clément Pit-Claudel
;; Version: 0.1
;; Package-Requires: ((emacs "24.3") (biblio-core "0.0"))
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
;;
;; Lookup and download bibliographic records from DBLP (a great source of
;; references for Computer Science papers) using `dblp-lookup'.
;;
;; This package uses `biblio-selection-mode', and plugs into the more general
;; `biblio' package (which see for more documentation).

;;; Code:

(require 'biblio-core)

(defun biblio-dblp--forward-bibtex (metadata forward-to)
  "Forward BibTeX for DBLP entry METADATA to FORWARD-TO."
  (let* ((source-url (biblio-alist-get 'url metadata))
         (url (replace-regexp-in-string "/rec/" "/rec/bib2/" source-url t t)))
    (biblio-url-retrieve url (biblio-generic-url-callback
                              (lambda () ;; No allowed errors, so no arguments
                                "Parse DBLP BibTeX results."
                                (funcall forward-to
                                         (biblio-format-bibtex
                                          (biblio-response-as-utf-8))))))))

(defun biblio-dblp--extract-interesting-fields (item)
  "Prepare a DBLP search result ITEM for display."
  (let-alist (biblio-alist-get 'info item)
    (list (cons 'title (cadr .title))
          (cons 'authors (seq-map #'cl-caddr (cdr .authors)))
          (cons 'container (cadr .venue))
          (cons 'references nil)
          (cons 'type (cadr .type))
          (cons 'url (cadr .url)))))

(defun biblio-dblp--hitp (item)
  "Check if ITEM is a DBLP hit."
  (eq (car-safe item) 'hit))

(defun biblio-dblp--parse-search-results ()
  "Extract search results from DBLP response."
  (set-buffer-multibyte t) ;; URL buffer is unibyte
  (decode-coding-region (point-min) (point-max) 'utf-8)
  (let-alist (car (xml-parse-region (point-min) (point-max)))
    (unless (string= (cadr .status) "OK")
      (display-warning 'biblio-dblp "DBLP query failed"))
    (seq-map #'biblio-dblp--extract-interesting-fields (seq-filter #'biblio-dblp--hitp .hits))))

(defun biblio-dblp--url (query)
  "Create a DBLP url to look up QUERY."
  (format "http://dblp.uni-trier.de/search/publ/api?q=%s&format=xml" (url-encode-url query)))

(defun biblio-dblp-backend (command &optional arg &rest more)
  "A DBLP backend for biblio.el.
COMMAND, ARG, MORE: See `biblio-backends'."
  (pcase command
    (`name "DBLP")
    (`prompt "DBLP query: ")
    (`url (biblio-dblp--url arg))
    (`parse-buffer (biblio-dblp--parse-search-results))
    (`forward-bibtex (biblio-dblp--forward-bibtex arg (car more)))
    (`register (add-to-list 'biblio-backends #'biblio-dblp-backend))))

;;;###autoload
(add-hook 'biblio-init-hook #'biblio-dblp-backend)

;;;###autoload
(defun biblio-dblp-lookup ()
  "Start a DBLP search."
  (interactive)
  (biblio-lookup #'biblio-dblp-backend))

;;;###autoload
(defalias 'dblp-lookup 'biblio-dblp-lookup)

(provide 'biblio-dblp)
;;; biblio-dblp.el ends here
