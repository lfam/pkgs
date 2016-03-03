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

(define-module (leo packages kccmp)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (gnu packages qt)
  )

(define-public kccmp
  (package
    (name "kccmp")
    (version "0.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://stoopidsimple.com/files/kccmp-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "009pixbr94ssjylfasak6ryn5dpfjwyfq2jxvz68gz10wxvlynl1"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (delete 'configure) ; no ./configure
                  (add-before 'build 'qt-qmake
                    (lambda _
                      (zero? (system* "qmake"
                                      (string-append "DESTDIR="
                                                     (assoc-ref %outputs "out")
                                                     "/bin"))))))))
    (inputs
      `(("qt-4" ,qt-4)))
    (synopsis "Compare Linux kernel configurations")
    (description "kccmp is a graphical tool for comparing two Linux kernel
\".config\" files. It has the following features:
@enumerate
@item Display the configuration variables with different values in a table form.
@item Display the configuration variables and values which are found in only one
of the compared files.
@end enumerate")
    (home-page "http://stoopidsimple.com/kccmp")
    (license gpl2))) ; "later version" never mentioned
