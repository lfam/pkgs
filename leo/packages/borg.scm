(define-module (leo packages borg)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (guix build utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (gnu packages)
  #:use-module (gnu packages acl)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages dejagnu)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages mcrypt)
  #:use-module (gnu packages nettle)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages rsync)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages xml))

(define-public borg
  (package
    (name "borg")
    (version "0.28.0")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://pypi.python.org/packages/source/b/borgbackup/"
                    "borgbackup-" version ".tar.gz"))
              (sha256
               (base32
                "0ghpkcbnvi2k3xc3x8p60wvvlrbfz9bpd3wir5mimn4y3n1zfsib"))))
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
     `(("python-setuptools-scm" ,python-setuptools-scm)
       ("python-mock" ,python-mock)))
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
