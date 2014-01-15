test301
=======

Simple bash script to check redirections after a migration, from a csv file

<pre>
	test301.sh --url www.mydomain.com --file mapping-file.csv
</pre>

The CSV file to use has the following format:

source-uri;target-uri

/my/source/folder/page.html;/my/target/folder/page.html

The script generates two report files, one with the URL not redirected, the other one with the URL not redirected to the good target URL.
TODO
====
* add an option to pass the URL root (domain) as a CLI argument
* add a check for the final URL (no 404)
* enhance the output files


