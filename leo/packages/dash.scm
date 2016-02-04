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

(define-module (leo packages dash)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix licenses)
  #:use-module (guix packages))

(define-public dash
  (package
    (name "dash")
    (version "0.5.8")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://gondor.apana.org.au/~herbert/dash/"
                                  "files/dash-" version ".tar.gz"))
              (sha256
               (base32
                "03y6z8akj72swa6f42h2dhq3p09xasbi6xia70h2vc27fwikmny6"))))
    (build-system gnu-build-system)
    (synopsis "POSIX shell")
    (description "DASH is a POSIX-compliant implementation of /bin/sh that aims
to be as small as possible.  It does this without sacrificing speed where
possible.")
    (home-page "http://gondor.apana.org.au/~herbert/dash/")
    ;; DASH is BSD-3 but is linked against the output of the GPL mksignames.c
    ;; from BASH.
    (license (list bsd-3 gpl3+))))
