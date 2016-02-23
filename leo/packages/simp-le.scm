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

(define-module (leo packages simp-le)
  #:use-module (gnu packages python)
  #:use-module (gnu packages tls)
  #:use-module (guix build-system python)
  #:use-module (guix git-download)
  #:use-module (guix licenses)
  #:use-module (guix packages))

(define-public simp-le
  (let ((commit "01afa8c64264a7674e51471ea4bf7ce524d8b77e"))
    (package
      (name "simp-le")
      (version (string-append "2015-12-07T040251Z-" commit))
      (source (origin
               (method git-fetch)
               (uri (git-reference
                      (url "https://github.com/kuba/simp_le")
                      (commit commit)))
               (sha256
                (base32
                 "1q4s9j9jcjfnbirmivnz6nx2pzp741ix8gfk90l5l5zjjx370cqw"))))
      (build-system python-build-system)
      (arguments
       ;; The dependency "acme" only supports python-2, according to its
       ;; pypi page.
       `(#:python ,python-2))
      (native-inputs
       `(("python2-mock" ,python2-mock)))
      (propagated-inputs
       `(("python2-acme" ,python2-acme)
         ("python2-pyopenssl" ,python2-pyopenssl)
         ("python2-pytz" ,python2-pytz)
         ("python2-requests" ,python2-requests)))
      (synopsis "Simple Let’s Encrypt client")
      (description "A basic, unofficial Let's Encrypt client from the deveoper
of the official client.")
      (home-page "https://github.com/kuba/simp_le")
      (license gpl3+))))
