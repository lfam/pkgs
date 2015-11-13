These are Guix packages that are for some reason not included in GNU Guix.

Assuming the path to this directory is ~/pkgs, you  can use these
packages with Guix by including the path to the repo in your
GUIX_PACKAGE_PATH, like this:

    $ GUIX_PACKAGE_PATH="~/pkgs" guix package -i package-name

or by specifying the load path, like this:

    guix package -L ~/pkgs -i package-name
