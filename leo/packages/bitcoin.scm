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

(define-module (leo packages bitcoin)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages protobuf) 
  #:use-module (gnu packages python)
  #:use-module (gnu packages qt) 
  #:use-module (gnu packages tls))

(define-public bitcoin-unlimited
  (package
    (name "bitcoin-unlimited")
    (version "1.1.2.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/BitcoinUnlimited/"
                                  "BitcoinUnlimited/archive/"
                                  "bucash" version ".tar.gz"))
              (sha256
               (base32
                "0hplsv36xdqjhs2mk2z1h34sg8xdjs5l73fcmyzh14yplnr7cs6n"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags
       (list "--with-incompatible-bdb"
             (string-append "--with-boost=" (assoc-ref %build-inputs "boost"))

             ;; XXX: The configure script looks up Qt paths by
             ;; `pkg-config --variable=host_bins Qt5Core`, which fails to pick
             ;; up executables residing in 'qttools', so we specify them here.
             (string-append "ac_cv_path_LRELEASE="
                            (assoc-ref %build-inputs "qttools")
                            "/bin/lrelease")
             (string-append "ac_cv_path_LUPDATE="
                            (assoc-ref %build-inputs "qttools")
                            "/bin/lupdate"))
       #:phases
       (modify-phases %standard-phases
         (add-before 'check 'set-home
           (lambda _ (setenv "HOME" (getenv "TMPDIR"))))
         (add-after 'unpack 'bootstrap
           (lambda _ (zero? (system* "sh" "autogen.sh"))))
;         (add-before 'check 'patch-shebang
;           (lambda _
;             (patch-shebang "src/test/bitcoin-util-test.py")
;             (patch-shebang "src/test/buildenv.py")))
         )))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("libtool" ,libtool)
       ("python" ,python-wrapper) ; tests
       ("pkg-config" ,pkg-config)
       ("qttools" ,qttools)
       ("util-linux" ,util-linux))) ; hexdump, for tests
    (inputs
     `(("bdb" ,bdb-5.3)
       ("boost" ,boost)
       ("libevent" ,libevent)
       ("openssl" ,openssl)
       ("protobuf" ,protobuf)
;       ("upnp" ,miniupnpc)
       ("qtbase", qtbase)
       ("zlib" ,zlib)))
    (synopsis "Bitcoin fork focused on high transaction volume")
    (description "Bitcoin Unlimited is a fork of Bitcoin Core focused on
allowing the Bitcoin network to process a higher number of transactions.")
    (home-page "https://www.bitcoinunlimited.info/")
    (license license:expat)))
