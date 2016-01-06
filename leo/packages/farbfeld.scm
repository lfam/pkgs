;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2016 Leo Famulari <leo@famulari.name>
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

(define-module (leo packages farbfeld)
  #:use-module (gnu packages image)
  #:use-module (guix build-system gnu)
  #:use-module (guix git-download)
  #:use-module (guix licenses)
  #:use-module (guix packages))

(define-public farbfeld
  (let ((commit "1c801ebeaacd92d08b0225dd7e8c8e7963aa59d8"))
    (package
      (name "farbfeld")
      (version (string-append "20160105-" (substring commit 0 8)))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "git://git.suckless.org/farbfeld")
                      (commit commit)))
                (file-name (string-append name "-" version))
                (sha256
                 (base32
                  "0g7wmbi8zyyqryrsw7gbp741k2nw5kr23vybgbhinirym5rbpv62"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f
         #:phases (modify-phases %standard-phases
                    (delete 'configure))
         #:make-flags (list "CC=gcc"
                      (string-append "PREFIX=" %output))))
      (inputs
       `(("libpng" ,libpng)
         ("libjpeg" ,libjpeg)))
      (synopsis "Lossless image format")
      (description "Farbfeld is a lossless image-format designed to
be parsed and piped easily.  It can be compressed easily and beats PNG's
filesize in many cases.")
      (home-page "http://git.suckless.org/farbfeld/")
      (license isc))))
