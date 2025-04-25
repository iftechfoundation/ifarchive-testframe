# IF Archive test framework

This repository agglomerates all (most) of the repos involved in running the [IF Archive][ifarch]. It allows you to build a test-mode Archive as a Docker container.

[ifarch]: https://ifarchive.org.

## How does this differ from the real IF Archive?

The real Archive service is split across several subdomains: [ifarchive.org][ifarch], [search.ifarchive.org][if-search], [upload.ifarchive.org][if-upload], and so on. They all currently run on the same Linux instance; the subdomain split is just futureproofing. But it means that the pages have some absolute-URL links to each other. In test mode, we adjust (some of) those links to be server-relative.

Another Archive subdomain is [unbox.ifarchive.org][if-unbox], which runs on a second Linux instance. Unbox is not yet included in this test framework.

[if-search]: https://search.ifarchive.org/search
[if-upload]: https://upload.ifarchive.org/cgi-bin/upload.py
[if-unbox]: https://unbox.ifarchive.org/

## To run

	# If the submodules were not filled in by your git client
	git submodule init; git submodule update
	
	# Construct the image (takes a while the first time)
	docker build -t ifarch .
	
	# Launch a container with the image, mapping container port 80 (Apache) to real port 8888
	docker run -p 8888:80 -i -t ifarch

Then visit `http://localhost:8888` in your browser.

