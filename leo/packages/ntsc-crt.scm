;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2022 Leo Famulari <leo@famulari.name>
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

(define-module (leo packages ntsc-crt)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu))

(define-public ntsc-crt
  (let ((revision "0")
        (commit "e675a95be56b97ec8677d6d5fb9ca22bff72af34"))
    (package
      (name "ntsc-crt")
      (version (git-version "0.0.0" revision commit))
      (source (origin
                (method git-fetch)
                (file-name (git-file-name name version))
                (uri (git-reference
                      (url "https://github.com/LMP88959/NTSC-CRT")
                      (commit commit)))
                (sha256
                 (base32
                  "1bc3kffs15n52mq2vnzmz3286n0gnkw9dm1ckhh3r441194gbdiq"))))
      (build-system gnu-build-system)
      (arguments
       (list #:tests? #f ; no test suite
             #:phases
             #~(modify-phases %standard-phases
                 (delete 'configure) ; No ./configure script
                 ; No Makefile
                 (replace 'build
                   (lambda _
                     (invoke "gcc" "-O3" "-o" "ntsc" "crt.c" "ntsc_crt.c" "ppm_rw.c")))
                 ; No installation procedure
                 (replace 'install
                   (lambda _
                     (install-file "ntsc"
                                   (string-append (assoc-ref %outputs "out")
                                                  "/bin")))))))
      (home-page "https://github.com/LMP88959/NTSC-CRT")
      (synopsis "NTSC encoding and decoding")
      (description "This package provides NTSC encoding and decoding in C89
using only integers and fixed point math.  It can be used as an image filter for
games or real-time applications.")
      ; A unique and informal license
      (license (non-copyleft "https://github.com/LMP88959/NTSC-CRT/blob/main/LICENSE")))))
