TARGET=tmux-prompt
INSTALLDIR=$(HOME)/bin

$(TARGET): $(TARGET).go
	go build -ldflags=-s -o $@

install: $(TARGET)
	cp $< "$(HOME)/bin"

clean:
	rm -f $(TARGET)
