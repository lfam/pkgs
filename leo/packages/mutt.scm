;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2017 Leo Famulari <leo@famulari.name>
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

(define-module (leo packages mutt)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages mail))

;;; This package is a variant of Mutt with NeoMutt's "encrypt to self" GPGME
;;; patches.
(define-public my-mutt
  (package
    (inherit mutt)
    (name "my-mutt")
    (source
      (origin
        (inherit (package-source mutt))
        (patches
          (append
            (origin-patches (package-source mutt))
            (search-patches "mutt-smime-encrypt-self.patch"
                            "mutt-pgp-encrypt-self.patch")))))))
