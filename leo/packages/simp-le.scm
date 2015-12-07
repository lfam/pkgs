(define-module (leo packages simp-le)
  #:use-module (gnu packages python)
  #:use-module (gnu packages tls)
  #:use-module (guix build-system python)
  #:use-module (guix git-download)
  #:use-module (guix licenses)
  #:use-module (guix packages))

(define-public simp-le
  (let ((commit "01afa8c64264a7674e51471ea4bf7ce524d8b77e"))
    (package
      (name "simp-le")
      (version (string-append "2015-12-07T040251Z-" commit))
      (source (origin
               (method git-fetch)
               (uri (git-reference
                      (url "https://github.com/kuba/simp_le")
                      (commit commit)))
               (sha256
                (base32
                 "1q4s9j9jcjfnbirmivnz6nx2pzp741ix8gfk90l5l5zjjx370cqw"))))
      (build-system python-build-system)
      (arguments
       ;; The dependency "acme" only supports python-2, according to its
       ;; pypi page.
       `(#:python ,python-2))
      (native-inputs
       `(("python2-mock" ,python2-mock)))
      (propagated-inputs
       `(("acme" ,acme)
         ("python2-pyopenssl" ,python2-pyopenssl)
         ("python2-pytz" ,python2-pytz)
         ("python2-requests" ,python2-requests)))
      (synopsis "Simple Let’s Encrypt client")
      (description "A basic, unofficial Let's Encrypt client from the deveoper
of the official client.")
      (home-page "https://github.com/kuba/simp_le")
      (license gpl3+))))
