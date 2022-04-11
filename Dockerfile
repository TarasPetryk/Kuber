FROM httpd:2.4
COPY index.html /usr/local/apache2/htdocs/
#ENTRYPOINT echo "<h2>Build number is $(SPECIAL_VAR) and secret is $(USER_NAME)</h2></body></html>" >> /usr/local/apache2/htdocs/index.html
