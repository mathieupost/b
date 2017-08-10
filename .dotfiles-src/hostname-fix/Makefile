TARGET=hostname-fix
INSTALLDIR=$(HOME)/bin

$(TARGET): $(TARGET).c
	sudo rm -f $(TARGET)
	cc -o $@ $<
	sudo chown root:wheel $@
	sudo chmod ug+s $@

install: $(TARGET)
	sudo cp -a $< "$(HOME)/bin"

clean:
	sudo rm -f $(TARGET)
