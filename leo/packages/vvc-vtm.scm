;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2020 Leo Famulari <leo@famulari.name>
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

(define-module (leo packages vvc-vtm)
  #:use-module (guix packages) 
  #:use-module (guix licenses)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake))

;; XXX This package fails to "build" because the CMake build scripts lack an
;; installation procedure. You could build it with --keep-failed and run it from
;; the build directory.
(define-public vtm
  (package
    (name "vtm")
    (version "12.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://vcgit.hhi.fraunhofer.de/jvet/VVCSoftware_VTM.git")
                     (commit (string-append "VTM-" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0fvlnngzifcaqvhykpv1j8l3pd6s5fh2i82fgwrp29iqp4zakjk3"))))
    ;; Only 64-bit architectures are supported upstream. For more info:
    ;; https://vcgit.hhi.fraunhofer.de/jvet/VVCSoftware_VTM#build-instructions
    (supported-systems '("x86_64-linux" "aarch64-linux"))
    (build-system cmake-build-system)
    (arguments
     '(#:tests? #f))
    (home-page "https://jvet.hhi.fraunhofer.de/")
    (synopsis "Versatile Video Coding (H.266) reference implementation")
    (description "@{VTM, VVC Test Model} is the reference software
implementation of @acronym{VVC, Versatile Video Coding}, also known as H.266.
This video coding standard is registered as ITU-T Recommendation H.266 | ISO/IEC
23090-3, and is intended to surpass @{HEVC, High Efficiency Video Coding}, also 
known as H.265.")
    (license bsd-3)))
