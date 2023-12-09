help:
	@echo "Makefile for vscode extensions: \n\tavailable commands: \"freeze\", \"install\", and \"clean\""

# freeze vscode extensions
freeze:
	code --list-extensions > extensions.txt

# install extensions from freezed list
install:
	cat extensions.txt | xargs -L 1 code --install-extension

# clean up freezed extension list
clean:
	rm extensions.txt
