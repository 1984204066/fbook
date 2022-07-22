SHELL:=/bin/zsh

clean:
	@for f (`fd -t d -d 1`) {cd $$f; mdbook clean; cd ..;}
