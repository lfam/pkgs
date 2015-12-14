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
