TARGET=hostname-fix
INSTALLDIR=$(HOME)/bin

$(TARGET): $(TARGET).c
	cc -o $@ $<
	sudo chown root:wheel $@
	sudo chmod ug+s $@

install: $(TARGET)
	cp $< "$(HOME)/bin"

clean:
	rm -f $(TARGET)
