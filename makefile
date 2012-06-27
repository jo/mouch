build :
	cat head.html > index.html
	markdown_py -ohtml5 README.md >> index.html
	cat foot.html >> index.html
