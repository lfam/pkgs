;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2019 Leo Famulari <leo@famulari.name>
;;;
;;; This file is NOT part of GNU Guix, but is supposed to be used with GNU
;;; Guix and has the same license.
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

(define-module (leo packages encpipe)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix git-download))

(define-public encpipe
  (package
    (name "encpipe")
    (version "0.5")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/jedisct1/encpipe.git")
                     (commit version)
                     ;; Download libhydrogen
                     (recursive? #t)))
    (file-name (git-file-name name version))
    (sha256
     (base32
      "1mk178kf7vbk92hshylfm20giy8dgncc16s9if1hrffrdi4hllb2"))))
    (build-system gnu-build-system)
    (arguments
      ;; XXX Disable -march=native
     `(#:make-flags (list "CC=gcc"
                          (string-append "PREFIX=" (assoc-ref %outputs "out")))
       #:phases
       (modify-phases %standard-phases
         ;; No ./configure script
         (delete 'configure))))
    (home-page "https://github.com/jedisct1/encpipe/")
    (synopsis "Encrypt a file using a password")
    (description "Encpipe is a password-based file encryption tool.  It can
act on files or standard input and output.  Encpipe is based on libhydrogen,
using Curve25519 and the Gimli permutation.")
    (license isc)))
