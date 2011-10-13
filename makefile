SRC = app.json.erb
TARGET = app.json
DEPENDFILE = .dependencies

# build app
$(TARGET) : $(SRC)
	./build $(SRC) > $(TARGET)

# create dependency file
dep: 
	echo '$(TARGET) :' `./build $(SRC) --deps` > $(DEPENDFILE)

# create database
create :
	curl -XPUT $(URL)

# install app
install : $(TARGET)
	./push $(TARGET) $(URL)

# clean build files
clean : 
	rm -rf $(DEPENDFILE)
	rm -rf $(TARGET)

# make all from scratch
all : clean dep $(TARGET) install

-include $(DEPENDFILE)
