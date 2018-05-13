;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2018 Leo Famulari <leo@famulari.name>
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

(define-module (leo packages zbar)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages qt))

;; This package is basically abandoned upstream, so I'm not planning to
;; add it to GNU Guix.
(define-public zbar
  (package
    (name "zbar")
    (version "0.10")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://sourceforge.net/projects/zbar/files/"
                                  "zbar/" version "/zbar-" version ".tar.bz2"))
              ;; As patched in Debian Stretch
              (patches (search-patches "zbar-1.patch"
                                       "zbar-2.patch"
                                       "zbar-3.patch"
                                       "zbar-4.patch"))
              (sha256
               (base32
                "1imdvf5k34g1x2zr6975basczkz3zdxg6xnci50yyp5yvcwznki3"))))
    (build-system gnu-build-system)
    (arguments
     '(;; The build scripts fail to find v4l-utils.
       #:configure-flags '("--disable-video")
       ;; They fail!
       #:tests? #f))
    (native-inputs
     `(("glib" ,glib "bin")
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("gtk+" ,gtk+-2)
       ("imagemagick" ,imagemagick)
       ("python" ,python-2)
       ("python2-pygtk" ,python2-pygtk)
       ("qt" ,qt-4)))
    (home-page  "http://zbar.sourceforge.net/")
    (synopsis "Read various types of barcodes")
    (description "ZBar can read barcodes from a variety of sources, such as
video streams, image files, and raw intensity sensors.  It supports several
types of barcodes, such as EAN-13/UPC-A, UPC-E, EAN-8, Code 128, Code 39, and QR
codes.  It can provide a command-line application, a GUI, and several language
bindings.")
    (license lgpl2.1+)))
