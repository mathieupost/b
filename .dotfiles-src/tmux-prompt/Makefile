TARGET=tmux-prompt
INSTALLDIR=$(HOME)/bin

$(TARGET): $(TARGET).go
	go build -o $@

install: $(TARGET)
	cp $< "$(HOME)/bin"

clean:
	rm -f $(TARGET)
