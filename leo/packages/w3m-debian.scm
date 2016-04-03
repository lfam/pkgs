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

(define-module (leo packages w3m-debian)
  #:use-module (guix packages)
  #:use-module (gnu packages w3m)
  #:use-module (guix git-download))

;;; The "official" w3m development is abandonded. The only public
;;; developement of w3m is happening in Debian.

(define-public w3m-debian
  (package (inherit w3m)
    (name "w3m-debian")
    (version "v0.5.3+git20160228")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://anonscm.debian.org/git/collab-maint/w3m.git")
                     (commit version)))
              (sha256
               (base32
                "1f9vnw4bd20j66x8w4qh17l48awnws880mbq6xw6ydf2d6hg9k8c"))))))
