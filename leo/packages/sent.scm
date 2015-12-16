;;; GNU Guix --- Functional package management for GNU
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

(define-module (leo packages sent)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages image)
  #:use-module (gnu packages xorg)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages))

(define-public sent
  (package
    (name "sent")
    (version "0.2")
    (source (origin
             (method url-fetch)
             (uri (string-append
                  "http://dl.suckless.org/tools/sent-"
                  version ".tar.gz"))
             (sha256
              (base32
               "0xhh752hwaa26k4q6wvrb9jnpbnylss2aw6z11j7l9rav7wn3fak"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (delete 'check)) ; no test suite
       #:make-flags (list
                      "CC=gcc"
                      (string-append "PREFIX=" %output)
                      (string-append "INCS +="
                                     " -I" (assoc-ref %build-inputs "freetype")
                                     "/include/freetype2"))))
    (inputs
      `(("libpng" ,libpng)
        ("libx11" ,libx11)
        ("libxft" ,libxft)
        ("freetype" ,freetype)))
    (synopsis "Simple plaintext presentation tool")
    (description "Uses plaintext files and PNG images to create slideshow
presentations.  Each paragraph represents a slide in the presentation.
Especially for presentations using the Takahashi method this is very nice and
allows you to write down the presentation for a quick lightning talk within a
few minutes.")
    (home-page "http://tools.suckless.org/sent")
    (license license:x11)))
