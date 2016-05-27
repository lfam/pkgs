;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Taylan Ulrich Bayırlı/Kammer <taylanbayirli@gmail.com>
;;; Copyright © 2015 Leo Famulari <leo@famulari.name>
;;;
;;; This file is NOT part of GNU Guix, but is supposed to be used with GNU
;;; Guix and thus has the same license.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (leo packages moreutils-perpendicular)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages docbook) 
  #:use-module (gnu packages moreutils)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages xml))

(define-public moreutils-perpendicular
  (package
    (name "moreutils-perpendicular")
    (version (package-version moreutils))
    (source (package-source moreutils))

    (build-system gnu-build-system)
    (inputs (package-inputs moreutils))
    (arguments
     `(#:phases (modify-phases %standard-phases
        (replace 'configure
          (lambda* (#:key inputs #:allow-other-keys)
            (use-modules (srfi srfi-1))
            (substitute* "Makefile"
              (("/usr/share/xml/.*/docbook.xsl")
               (let* ((docbook-xsl (assoc-ref inputs "docbook-xsl"))
                      (files (find-files docbook-xsl "^docbook\\.xsl$")))
                 (find (lambda (file)
                         (string-suffix? "/manpages/docbook.xsl" file))
                       files)))))))
       #:make-flags
       (list (string-append "PREFIX=" (assoc-ref %outputs "out"))
             "CC=gcc"
             ;; It's annoying to have moreutils' `parallel` conflict
             ;; with GNU Parallel, so this package omits it.
             "BINS=isutf8 ifdata ifne pee sponge mispipe lckdo errno"
             (string-append "MANS=sponge.1 vidir.1 vipe.1 isutf8.1 ts.1 "
                            "combine.1 ifdata.1 ifne.1 pee.1 zrun.1 chronic.1 "
                            "mispipe.1 lckdo.1 errno.1"))))
    (home-page (package-home-page moreutils))
    (synopsis "Miscellaneous general-purpose command-line tools")
    (description
     "Moreutils is a collection of general-purpose command-line tools to
augment the traditional Unix toolbox.  This packaging of moreutils omits the
'parallel' application.")
    (license gpl2+)))
