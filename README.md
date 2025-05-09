# IF Archive test framework

This repository agglomerates all (most) of the repos involved in running the [IF Archive][ifarch]. It allows you to build a test-mode Archive as a Docker container.

Note: I don't have the container published anywhere. This is meant for testing and development, not real-world use. But you can build it yourself, using the Dockerfile in this repo.

[ifarch]: https://ifarchive.org

## How does this differ from the real IF Archive?

The real Archive is not built on Docker! Maybe it should be, but the current configuration was set up in 2017 and I didn't use Docker then. This setup is only for testing.

The real Archive service is split across several subdomains: [ifarchive.org][ifarch], [search.ifarchive.org][if-search], [upload.ifarchive.org][if-upload], and so on. They all currently run on the same Linux instance; the subdomain split is just futureproofing. But it means that the pages have some absolute-URL links to each other. In test mode, we adjust (some of) those links to be server-relative.

Another Archive subdomain is [unbox.ifarchive.org][if-unbox], which runs on a second Linux instance. Unbox is not yet included in this test framework.

[if-search]: https://search.ifarchive.org/search
[if-upload]: https://upload.ifarchive.org/cgi-bin/upload.py
[if-unbox]: https://unbox.ifarchive.org/

The real Archive hosts several other domains (babel.ifarchive.org, spagmag.org, inform-fiction.org) which are unrelated to the core Archive service. These are not represented in this test framework either.

On the real Archive, the file directory (`/var/ifarchive/htdocs/if-archive`) is a mount point for a separate storage volume.

## To run

	# If the submodules were not filled in by your git client
	git submodule init; git submodule update
	
	# Construct and launch the image (takes a while the first time)
	docker compose up

Then visit `http://localhost:8888/` in your browser.

The admin interface is at `http://localhost:8888/admin`. Log in with username `fred`, password `password`.

To get a root shell inside the container:

	docker compose exec -i -t ifarch bash


## To develop

Most of the scripts and templates used by the various repos are mounted into the container. (See the `volumes` list of `docker-compose.yml`.) This means you can edit files and the updated versions will be visible (and active) immediately inside the container.

Some changes require you to restart Apache, which means `docker compose restart`. Changes to files in `tinyapp`, `searchlib`, and `adminlib` are in this category.

A few files are copied into the Docker image and cannot be changed on the fly. Currently these are `ifarch.config` and the test files that populate the Archive. If you change these, you'll need to do `docker compose down; docker compose build; docker compose up`.
