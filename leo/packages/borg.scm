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

(define-module (leo packages borg)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix build-system python)
  #:use-module (gnu packages)
  #:use-module (gnu packages acl)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages python)
  #:use-module (gnu packages tls))

(define-public borg
  (package
    (name "borg")
    (version "0.29.0")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "borgbackup" version))
              (sha256
               (base32
                "1gvx036a7j16hd5rg8cr3ibiig7gwqhmddrilsakcw4wnfimjy5m"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before
          'build 'set-openssl-prefix
          (lambda* (#:key inputs #:allow-other-keys)
            (setenv "BORG_OPENSSL_PREFIX" (assoc-ref inputs "openssl"))
            #t))
         (add-before
          'build 'set-lz4-prefix
          (lambda* (#:key inputs #:allow-other-keys)
            (setenv "BORG_LZ4_PREFIX" (assoc-ref inputs "lz4"))
            #t)))))
    (native-inputs
     `(("python-setuptools-scm" ,python-setuptools-scm)))
    (inputs
     `(("acl" ,acl)
       ("lz4" ,lz4)
       ("openssl" ,openssl)
       ("python-llfuse" ,python-llfuse)
       ("python-msgpack" ,python-msgpack)))
    (synopsis "Deduplicated, encrypted, authenticated and compressed backups")
    (description "Borg is a deduplicating backup program.  Optionally, it
supports compression and authenticated encryption.  The main goal of Borg is to
provide an efficient and secure way to backup data.  The data deduplication
technique used makes Borg suitable for daily backups since only changes are
stored.  The authenticated encryption technique makes it suitable for backups
to not fully trusted targets.")
    (home-page "https://borgbackup.github.io/borgbackup/")
    (license license:bsd-3)))
